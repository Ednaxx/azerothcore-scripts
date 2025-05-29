#!/bin/bash

# Load environment variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/.env" ]; then
    source "$SCRIPT_DIR/.env"
elif [ -f "$HOME/.env" ]; then
    source "$HOME/.env"
else
    echo "Error: .env file not found!"
    exit 1
fi

# Create timestamp for backup files
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Function to backup a single database
backup_database() {
    local db_name=$1
    local backup_file="$BACKUP_DIR/${db_name}_${TIMESTAMP}.sql"
    
    echo "Backing up $db_name..."
    
    mysqldump \
        --host="$DB_HOST" \
        --port="$DB_PORT" \
        --user="$DB_USER" \
        --password="$DB_PASSWORD" \
        --single-transaction \
        --routines \
        --triggers \
        --events \
        --compression-algorithms=zstd \
        "$db_name" > "$backup_file"
    
    if [ $? -eq 0 ]; then
        # Compress the backup
        gzip "$backup_file"
        echo "✓ $db_name backed up successfully: ${backup_file}.gz"
        
        # Get file size
        local size=$(du -h "${backup_file}.gz" | cut -f1)
        echo "  Size: $size"
    else
        echo "✗ Failed to backup $db_name"
        return 1
    fi
}

# Function to clean old backups
cleanup_old_backups() {
    echo ""
    echo "Cleaning up backups older than $BACKUP_RETENTION_DAYS days..."
    
    find "$BACKUP_DIR" -name "*.sql.gz" -type f -mtime +$BACKUP_RETENTION_DAYS -delete
    
    local deleted=$(find "$BACKUP_DIR" -name "*.sql.gz" -type f -mtime +$BACKUP_RETENTION_DAYS | wc -l)
    echo "Cleaned up $deleted old backup files"
}

# Main backup process
echo "=================================================="
echo "AzerothCore Database Backup"
echo "Started: $BACKUP_DATE"
echo "Backup Directory: $BACKUP_DIR"
echo "=================================================="

# Test MySQL connection
echo "Testing MySQL connection..."
mysql --host="$DB_HOST" --port="$DB_PORT" --user="$DB_USER" --password="$DB_PASSWORD" -e "SELECT 1;" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "✗ Failed to connect to MySQL. Please check your credentials in .env"
    exit 1
fi
echo "✓ MySQL connection successful"
echo ""

# Backup each database
backup_database "$DB_WORLD"
backup_database "$DB_CHARACTERS"
backup_database "$DB_PLAYERBOTS"
backup_database "$DB_AUTH"

# Clean up old backups
cleanup_old_backups

echo ""
echo "=================================================="
echo "Backup completed: $(date +"%Y-%m-%d %H:%M:%S")"
echo "Backup location: $BACKUP_DIR"
echo "=================================================="
