## Submitted by

**Name:** Satya Sourav Patel  
**Email:** satyasouravssp0@gmail.com

---

## Repository Layout

```text
infra/
  modules/
    network/    # VPC, public/private subnets, routes, NAT
    ecs/        # ALB, ECS cluster, task definition, service, security groups
    rds/        # private PostgreSQL RDS, subnet group, security group
  envs/
    dev/        # smaller sizing, short retention, deletion protection off
    prod/       # larger sizing, Multi-AZ, longer retention, deletion protection on
db/
  migrations/   # table and index creation
  seeds/        # deterministic 120 booking seed
  queries/      # optimized report query with EXPLAIN
scripts/
  migrate.sh
  query-demo.sh
  backup.sh
  restore.sh
```

## Terraform Review

The environment directories use local backend state by default so the assessment commands can run without creating an S3 state bucket.

The AWS provider is configured with mock credentials and provider validation skips so `terraform plan -refresh=false` can run as a design review without deploying or contacting AWS APIs for account validation.

Run the review commands from the repository root:

```bash
terraform fmt -check -recursive infra

cd infra/envs/dev
terraform init
terraform validate
terraform plan -refresh=false

cd ../prod
terraform init
terraform validate
terraform plan -refresh=false
```

Environment differences are defined in:

- `infra/envs/dev/terraform.tfvars`
- `infra/envs/prod/terraform.tfvars`

Key differences:

| Setting | dev | prod |
| --- | --- | --- |
| ECS desired count | 1 | 2 |
| Fargate CPU/memory | 256 / 512 MB | 512 / 1024 MB |
| RDS class | db.t4g.micro | db.t4g.small |
| RDS Multi-AZ | false | true |
| RDS backup retention | 3 days | 14 days |
| RDS deletion protection | false | true |
| Final snapshot on delete | skipped | required |

---


## Local Database Setup

Start PostgreSQL:

```bash
docker compose up -d
```

Create the tables:

```bash
docker exec -i hotel_postgres psql -U postgres -d hotel_local_dev < db/migrations/create_tables.sql
```
Load seed data:

```bash
docker exec -i hotel_postgres psql -U postgres -d hotel_local_dev < db/seeds/seed_data.sql
```

Confirm row counts:

```bash
docker exec -i hotel_postgres psql -U postgres -d hotel_db_restored -c \
  "SELECT COUNT(*) AS bookings FROM hotel_bookings; SELECT COUNT(*) AS events FROM booking_events;"
```

Expected minimums:

- `hotel_bookings`: 10,000 rows
- `booking_events`: 1000 rows

## Query Optimization

Required query:

```sql
SELECT org_id, status, COUNT(*), SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi'
AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;
```

Index added in `db/migrations/001_create_tables.sql`:

```sql
CREATE INDEX IF NOT EXISTS indexof_hotelbookings_covering_city_createdat_orgid_status
    ON hotel_bookings (city, created_at DESC, org_id, status)
    INCLUDE (amount);

```

I chose this index because city is used for exact filtering, so it is placed first. created_at is placed next because the query filters recent bookings from the last 30 days. I used created_at DESC because recent records are usually queried first.

The columns org_id and status are included in the index because they are used in the GROUP BY clause. The amount column is added using INCLUDE because it is required for SUM(amount).

This makes the index useful for the full query because PostgreSQL can use it to filter, group, and calculate the result with fewer table reads.

I also added this index:

```sql
CREATE INDEX IF NOT EXISTS indexof_bookingevents_covering_bookingid_createdat
    ON booking_events (booking_id, created_at DESC);
```
This index does not directly optimize the above query, but it helps when fetching events for a specific booking, especially when the latest events are needed first.


## Backup and Restore

Create a timestamped database backup:

```bash
./scripts/backup.sh
```

Backups are written to `backups/` and ignored by git.

Restore the latest backup into a fresh local database named `hotel_db_restored`:

```bash
./scripts/restore.sh
```


Verify restore success by checking the row-count output printed by `restore.sh`. You can also query the restored database directly:

```bash
docker exec -i hotel_postgres psql -U postgres -d hotel_db_restored -c \
"SELECT COUNT(*) FROM hotel_bookings;"
```

## Cleanup

Stop the database:

```bash
docker compose down
```

Remove the local database volume:

```bash
docker compose down -v
```
## GitHub Actions

The workflow at `.github/workflows/terraform-plan.yml` runs on pull requests that change Terraform files. It performs:

- `terraform fmt -check`
- `terraform init`
- `terraform validate`
- `terraform plan -refresh=false`

It writes the human-readable plan to the workflow summary and uploads `plan.txt` as an artifact for each environment.