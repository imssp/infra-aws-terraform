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
