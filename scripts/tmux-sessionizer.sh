#!/usr/bin/env bash
# tmux-sessionizer.sh — Quickly create or switch to project-based tmux sessions
# Usage: tmux-sessionizer.sh [directory]
#   If no directory given, uses fzf to pick from common project directories.
#   Bind to a key in .tmux.conf:
#     bind f run-shell "~/.local/bin/tmux-sessionizer.sh"
set -euo pipefail

# Directories to search for projects (customize these)
SEARCH_DIRS=(
    "$HOME/Projects"
    "$HOME/src"
    "$HOME/.config"
)

if [[ $# -eq 1 ]]; then
    selected="$1"
else
    if ! command -v fzf &>/dev/null; then
        echo "Error: fzf is required for interactive selection."
        echo "Install with: brew install fzf"
        exit 1
    fi

    # Build list of directories to choose from
    dirs=()
    for d in "${SEARCH_DIRS[@]}"; do
        [[ -d "$d" ]] && dirs+=("$d")
    done

    if [[ ${#dirs[@]} -eq 0 ]]; then
        echo "No search directories found. Edit SEARCH_DIRS in this script."
        exit 1
    fi

    selected=$(find "${dirs[@]}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | fzf)
fi

if [[ -z "${selected:-}" ]]; then
    exit 0
fi

# Create session name from directory basename (replace dots with underscores)
session_name=$(basename "$selected" | tr '.' '_')

# If not inside tmux
if [[ -z "${TMUX:-}" ]]; then
    tmux new-session -As "$session_name" -c "$selected"
    exit 0
fi

# If inside tmux, create session if needed and switch
if ! tmux has-session -t="$session_name" 2>/dev/null; then
    tmux new-session -ds "$session_name" -c "$selected"
fi

tmux switch-client -t "$session_name"
