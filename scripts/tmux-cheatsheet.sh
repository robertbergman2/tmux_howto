#!/usr/bin/env bash
# tmux-cheatsheet.sh — Display a quick-reference cheatsheet in the terminal
cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                        tmux Quick Reference                                ║
║                     Prefix = Ctrl+a  (custom config)                       ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                            ║
║  SESSION MANAGEMENT                                                        ║
║  ─────────────────                                                         ║
║  tmux                          Start new session                           ║
║  tmux new -s <name>            Start named session                         ║
║  tmux ls                       List sessions                               ║
║  tmux attach -t <name>         Attach to session                           ║
║  tmux kill-session -t <name>   Kill session                                ║
║  prefix + d                    Detach from session                         ║
║  prefix + s                    List/switch sessions                        ║
║  prefix + $                    Rename session                              ║
║                                                                            ║
║  WINDOW MANAGEMENT                                                         ║
║  ─────────────────                                                         ║
║  prefix + c                    Create new window                           ║
║  prefix + ,                    Rename window                               ║
║  prefix + &                    Close window                                ║
║  prefix + n / p                Next / Previous window                      ║
║  prefix + <number>             Go to window N                              ║
║  prefix + w                    List windows (interactive)                  ║
║  Shift + Left/Right            Switch windows (no prefix)                  ║
║  prefix + < / >                Swap window left / right                    ║
║                                                                            ║
║  PANE MANAGEMENT                                                           ║
║  ───────────────                                                           ║
║  prefix + |                    Split horizontally (side by side)           ║
║  prefix + -                    Split vertically (top and bottom)           ║
║  prefix + x                    Close pane                                  ║
║  prefix + z                    Toggle pane zoom (fullscreen)               ║
║  prefix + !                    Convert pane to window                      ║
║  prefix + q                    Show pane numbers (then press #)            ║
║  prefix + {  /  }              Swap pane left / right                      ║
║  prefix + Space                Cycle pane layouts                          ║
║                                                                            ║
║  PANE NAVIGATION                                                           ║
║  ───────────────                                                           ║
║  prefix + h/j/k/l              Vim-style pane switching                    ║
║  Alt + Arrow keys              Switch panes (no prefix)                    ║
║  prefix + H/J/K/L              Resize panes                               ║
║                                                                            ║
║  COPY MODE (vi-style)                                                      ║
║  ────────────────────                                                      ║
║  prefix + v                    Enter copy mode                             ║
║  prefix + [                    Enter copy mode (default)                   ║
║  v                             Start selection (in copy mode)              ║
║  y                             Yank/copy selection                         ║
║  Ctrl+v                        Toggle rectangle selection                  ║
║  q / Escape                    Exit copy mode                              ║
║  /  or  ?                      Search forward / backward                   ║
║  n  /  N                       Next / previous search match                ║
║                                                                            ║
║  MISC                                                                      ║
║  ────                                                                      ║
║  prefix + r                    Reload tmux config                          ║
║  prefix + t                    Show clock                                  ║
║  prefix + :                    Enter command mode                          ║
║  tmux list-keys                Show all key bindings                       ║
║  tmux list-commands            Show all tmux commands                      ║
║                                                                            ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
