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

# Check if session already exists
if tmux has-session -t "$AUTH_SESSION" 2>/dev/null; then
    echo "✗ authserver is already running in session: $AUTH_SESSION"
    echo "    Stop it first with: ./stop-auth.sh"
    echo "    Or attach with: tmux attach -t $AUTH_SESSION"
    exit 1
fi

# Expand variables (in case they contain other variables)
AUTH_PATH=$(eval echo "$AUTH_PATH")

# Check if executable exists
if [ ! -f "$AUTH_PATH" ]; then
    echo "Error: Auth server not found at $AUTH_PATH"
    exit 1
fi

echo "[+] Starting authserver..."
tmux new-session -d -s "$AUTH_SESSION" "$AUTH_PATH"
echo "[✓] authserver started in session: $AUTH_SESSION"
echo "    Attach with: tmux attach -t $AUTH_SESSION"