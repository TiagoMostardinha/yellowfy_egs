#!/bin/bash

# Set the YELLOWFY_DIR environment variable to the current directory
YELLOWFY_DIR=$PWD

# Create a new tmux session named yellowfy
tmux new-session -d -s runProject

# Split the window horizontally and vertically
tmux split-window -v -t runProject:bash
tmux split-window -h -t runProject:bash
tmux split-window -h -t runProject:bash.1

# send command to the first pane
tmux send-keys -t runProject:bash.1 "cd $YELLOWFY_DIR/announcements/api && ./api" C-m
tmux send-keys -t runProject:bash.2 "cd $YELLOWFY_DIR/Booking/ && uvicorn main:app --reload" C-m
tmux send-keys -t runProject:bash.3 "cd $YELLOWFY_DIR/auth_app/project/ && sh setup.sh" C-m
tmux send-keys -t runProject:bash.4 "cd $YELLOWFY_DIR/yellowfy/ && flutter run" C-m


tmux attach-session -t runProject

#tmux kill-session -t runProject

