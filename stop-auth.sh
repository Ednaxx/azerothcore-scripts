#!/bin/bash

AUTH_SESSION="azeroth-auth"

echo "[+] Stopping authserver..."
tmux send-keys -t $AUTH_SESSION C-c

# Wait until the session no longer exists
while tmux has-session -t $AUTH_SESSION 2>/dev/null; do
    sleep 1
done

echo "[✓] authserver shutdown complete."
