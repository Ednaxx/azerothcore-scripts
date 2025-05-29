#!/bin/bash

AUTH_SESSION="azeroth-auth"
WORLD_SESSION="azeroth-world"

AUTH_PATH="$AC_CODE_DIR/build/src/server/apps/authserver"
WORLD_PATH="$AC_CODE_DIR/build/src/server/apps/worldserver"

tmux new-session -d -s $AUTH_SESSION "$AUTH_PATH"
tmux new-session -d -s $WORLD_SESSION "$WORLD_PATH"

echo "Servers running!"
echo "  sudo tmux attach -t $AUTH_SESSION"
echo "  sudo tmux attach -t $WORLD_SESSION"
