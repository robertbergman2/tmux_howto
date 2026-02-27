#!/usr/bin/env bash
# tmux-layout-dev.sh — Create a development layout with editor, terminal, and watcher
# Usage: tmux-layout-dev.sh [session-name] [working-directory]
set -euo pipefail

SESSION="${1:-dev}"
DIR="${2:-$(pwd)}"

# Kill existing session if present
tmux kill-session -t "$SESSION" 2>/dev/null || true

# Create new session with main editor pane
tmux new-session -d -s "$SESSION" -c "$DIR" -x "$(tput cols)" -y "$(tput lines)"

# Rename first window
tmux rename-window -t "$SESSION:1" "editor"

# Split right: terminal (30% width)
tmux split-window -h -t "$SESSION:1" -c "$DIR" -l '30%'

# Split the right pane vertically: bottom for watcher/logs
tmux split-window -v -t "$SESSION:1.2" -c "$DIR" -l '40%'

# Create a second window for git operations
tmux new-window -t "$SESSION" -n "git" -c "$DIR"

# Create a third window for miscellaneous tasks
tmux new-window -t "$SESSION" -n "misc" -c "$DIR"

# Focus on the editor pane in window 1
tmux select-window -t "$SESSION:1"
tmux select-pane -t "$SESSION:1.1"

# Attach
if [[ -z "${TMUX:-}" ]]; then
    tmux attach-session -t "$SESSION"
else
    tmux switch-client -t "$SESSION"
fi
