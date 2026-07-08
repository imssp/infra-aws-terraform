#!/usr/bin/env bash

set -euo pipefail

DB_CONTAINER="hotel_postgres"
DB_USER="postgres"
RESTORE_DB="hotel_db_restored"
BACKUP_DIR="backups"

BACKUP_FILE=$(find "${BACKUP_DIR}" -type f -name "*.sql" -printf "%T@ %p\n" | sort -nr | head -n 1 | cut -d' ' -f2-)

if [ ! -f "${BACKUP_FILE}" ]; then
  echo "No backup file found in ${BACKUP_DIR}"
  exit 1
fi

echo "Using backup file: ${BACKUP_FILE}"

echo "Dropping restore database if it already exists..."
docker exec "${DB_CONTAINER}" psql \
  -U "${DB_USER}" \
  -d postgres \
  -c "DROP DATABASE IF EXISTS ${RESTORE_DB};"

echo "Creating fresh restore database..."
docker exec "${DB_CONTAINER}" psql \
  -U "${DB_USER}" \
  -d postgres \
  -c "CREATE DATABASE ${RESTORE_DB};"

echo "Restoring backup into ${RESTORE_DB}..."
cat "${BACKUP_FILE}" | docker exec -i "${DB_CONTAINER}" psql \
  -U "${DB_USER}" \
  -d "${RESTORE_DB}"

echo "Restore completed successfully into database: ${RESTORE_DB}"