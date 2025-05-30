#!/bin/bash

# Usage function
usage() {
    echo "Usage: $0 <database_name> <backup_file>"
    echo ""
    echo "Examples:"
    echo "  $0 acore_world /mnt/c/Users/xandr/OneDrive/AzerothcoreDBBackup/acore_world_20231201_143022.sql.gz"
    echo "  $0 acore_characters acore_characters_20231201_143022.sql.gz"
    echo ""
    echo "Available databases: acore_world, acore_characters, acore_playerbots, acore_auth"
    exit 1
}

# Check arguments
if [ $# -ne 2 ]; then
    usage
fi

DB_NAME=$1
BACKUP_FILE=$2

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

# Check if servers are running
SERVERS_RUNNING=false
if tmux has-session -t "$AUTH_SESSION" 2>/dev/null; then
    echo "⚠ Warning: authserver is running (session: $AUTH_SESSION)"
    SERVERS_RUNNING=true
fi

if tmux has-session -t "$WORLD_SESSION" 2>/dev/null; then
    echo "⚠ Warning: worldserver is running (session: $WORLD_SESSION)"
    SERVERS_RUNNING=true
fi

if [ "$SERVERS_RUNNING" = true ]; then
    echo ""
    echo "✗ Cannot restore database while servers are running."
    echo "  This can cause data corruption and server instability."
    echo "  Please stop the servers first with: ./stop-azeroth.sh"
    exit 1
fi

# Check if backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    # Try looking in backup directory
    if [ -f "$BACKUP_DIR/$BACKUP_FILE" ]; then
        BACKUP_FILE="$BACKUP_DIR/$BACKUP_FILE"
    else
        echo "Error: Backup file not found: $BACKUP_FILE"
        exit 1
    fi
fi

echo "=================================================="
echo "AzerothCore Database Restore"
echo "Database: $DB_NAME"
echo "Backup File: $BACKUP_FILE"
echo "=================================================="

# Confirm restoration
read -p "This will OVERWRITE the existing $DB_NAME database. Are you sure? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Restoration cancelled."
    exit 0
fi

# Test MySQL connection
echo "Testing MySQL connection..."
mysql --host="$DB_HOST" --port="$DB_PORT" --user="$DB_USER" --password="$DB_PASSWORD" -e "SELECT 1;" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "✗ Failed to connect to MySQL. Please check your credentials in .env"
    exit 1
fi
echo "✓ MySQL connection successful"

# Check if target database exists
echo "Checking if database $DB_NAME exists..."
mysql --host="$DB_HOST" --port="$DB_PORT" --user="$DB_USER" --password="$DB_PASSWORD" -e "USE $DB_NAME;" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "✗ Database $DB_NAME does not exist. Please create it first."
    exit 1
fi
echo "✓ Database $DB_NAME exists"

# Restore database
echo "Restoring $DB_NAME from $BACKUP_FILE..."

if [[ "$BACKUP_FILE" == *.gz ]]; then
    # Compressed backup
    zcat "$BACKUP_FILE" | mysql \
        --host="$DB_HOST" \
        --port="$DB_PORT" \
        --user="$DB_USER" \
        --password="$DB_PASSWORD" \
        "$DB_NAME"
elif [[ "$BACKUP_FILE" == *.sql ]]; then
    # Uncompressed backup
    mysql \
        --host="$DB_HOST" \
        --port="$DB_PORT" \
        --user="$DB_USER" \
        --password="$DB_PASSWORD" \
        "$DB_NAME" < "$BACKUP_FILE"
else
    echo "Error: Unsupported backup file format. Please provide a .sql or .sql.gz file."
    exit 1
fi

if [ $? -eq 0 ]; then
    echo "✓ Database $DB_NAME restored successfully!"
else
    echo "✗ Failed to restore database $DB_NAME"
    exit 1
fi

echo "=================================================="
echo "Restoration completed: $(date +"%Y-%m-%d %H:%M:%S")"
echo "=================================================="
