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

# Check if session exists
if ! tmux has-session -t "$WORLD_SESSION" 2>/dev/null; then
    echo "ℹ worldserver is not running (session: $WORLD_SESSION)"
    exit 0
fi

echo "[+] Stopping worldserver..."
tmux send-keys -t "$WORLD_SESSION" C-c

# Wait until the session no longer exists
while tmux has-session -t "$WORLD_SESSION" 2>/dev/null; do
    sleep 1
done

echo "[✓] worldserver shutdown complete."
