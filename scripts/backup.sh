#!/usr/bin/env bash

set -euo pipefail

DB_CONTAINER="hotel_postgres"
DB_USER="postgres"
DB_NAME="hotel_local_dev"
BACKUP_DIR="backups"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql"

mkdir -p "${BACKUP_DIR}"

echo "Creating backup for database: ${DB_NAME}"

docker exec "${DB_CONTAINER}" pg_dump \
  -U "${DB_USER}" \
  -d "${DB_NAME}" > "${BACKUP_FILE}"

echo "Backup created successfully:"
echo "${BACKUP_FILE}"