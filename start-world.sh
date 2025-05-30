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
if tmux has-session -t "$WORLD_SESSION" 2>/dev/null; then
    echo "✗ worldserver is already running in session: $WORLD_SESSION"
    echo "    Stop it first with: ./stop-world.sh"
    echo "    Or attach with: tmux attach -t $WORLD_SESSION"
    exit 1
fi

# Expand variables (in case they contain other variables)
WORLD_PATH=$(eval echo "$WORLD_PATH")

# Check if executable exists
if [ ! -f "$WORLD_PATH" ]; then
    echo "Error: World server not found at $WORLD_PATH"
    exit 1
fi

echo "[+] Starting worldserver..."
tmux new-session -d -s "$WORLD_SESSION" "$WORLD_PATH"
echo "[✓] worldserver started in session: $WORLD_SESSION"
echo "    Attach with: tmux attach -t $WORLD_SESSION"