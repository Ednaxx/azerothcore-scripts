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

echo "=================================================="
echo "Available Database Backups"
echo "Location: $BACKUP_DIR"
echo "=================================================="

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Backup directory does not exist: $BACKUP_DIR"
    exit 1
fi

# List all backup files with details
find "$BACKUP_DIR" -name "*.sql.gz" -type f -exec stat -c "%Y %s %n" {} \; | sort -nr | while read timestamp size filepath; do
    filename=$(basename "$filepath")
    db_name=$(echo "$filename" | cut -d'_' -f1-2)
    backup_date=$(echo "$filename" | sed 's/.*_\([0-9]\{8\}_[0-9]\{6\}\).*/\1/')
    formatted_date=$(echo "$backup_date" | sed 's/\([0-9]\{4\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)_\([0-9]\{2\}\)\([0-9]\{2\}\)\([0-9]\{2\}\)/\1-\2-\3 \4:\5:\6/')
    
    # Check if size is numeric before passing to numfmt
    if [[ "$size" =~ ^[0-9]+$ ]]; then
        size_human=$(numfmt --to=iec --suffix=B "$size")
    else
        size_human="unknown"
    fi
    
    printf "%-20s | %-19s | %-8s | %s\n" "$db_name" "$formatted_date" "$size_human" "$filename"
done

echo ""
echo "Usage examples:"
echo "  ./restore-database.sh acore_world acore_world_20231201_143022.sql.gz"
echo "  ./restore-database.sh acore_characters acore_characters_20231201_143022.sql.gz"
