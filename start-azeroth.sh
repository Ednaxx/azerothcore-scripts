
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

# Expand variables (in case they contain other variables)
AUTH_PATH=$(eval echo "$AUTH_PATH")
WORLD_PATH=$(eval echo "$WORLD_PATH")

# Check if executables exist
if [ ! -f "$AUTH_PATH" ]; then
    echo "Error: Auth server not found at $AUTH_PATH"
    exit 1
fi

if [ ! -f "$WORLD_PATH" ]; then
    echo "Error: World server not found at $WORLD_PATH"
    exit 1
fi

# Start servers
echo "Starting AzerothCore servers..."
tmux new-session -d -s "$AUTH_SESSION" "$AUTH_PATH"
tmux new-session -d -s "$WORLD_SESSION" "$WORLD_PATH"

echo "Servers running!"
echo "  tmux attach -t $AUTH_SESSION"
echo "  tmux attach -t $WORLD_SESSION"
