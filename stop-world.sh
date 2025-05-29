#!/bin/bash

WORLD_SESSION="azeroth-world"

echo "[+] Stopping worldserver..."
tmux send-keys -t $WORLD_SESSION C-c

# Wait until the session no longer exists
while tmux has-session -t $WORLD_SESSION 2>/dev/null; do
    sleep 1
done

echo "[✓] worldserver shutdown complete."
