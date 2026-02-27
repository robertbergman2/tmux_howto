// tmux-guide.typ — Comprehensive tmux How-To Guide
// Compile: typst compile tmux-guide.typ

#set document(
  title: "The Complete tmux Guide",
  author: "Robert Bergman",
  date: datetime.today(),
)

#set page(
  paper: "us-letter",
  margin: (x: 0.75in, y: 0.75in),
  header: context {
    if counter(page).get().first() > 1 [
      #set text(8pt, fill: luma(120))
      The Complete tmux Guide
      #h(1fr)
      #counter(page).display()
    ]
  },
  footer: context {
    if counter(page).get().first() == 1 [
      #set align(center)
      #set text(8pt, fill: luma(120))
      Generated #datetime.today().display("[month repr:long] [day], [year]")
    ]
  },
)

#set text(font: "New Computer Modern", size: 10pt)
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1")
#set enum(indent: 1em)
#set list(indent: 1em)

#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(0.5em)
  block(
    width: 100%,
    below: 1em,
    {
      set text(16pt, weight: "bold")
      it
      v(0.2em)
      line(length: 100%, stroke: 1pt + luma(180))
    }
  )
}

#show heading.where(level: 2): it => {
  block(above: 1.2em, below: 0.6em, {
    set text(12pt, weight: "bold")
    it
  })
}

#show heading.where(level: 3): it => {
  block(above: 1em, below: 0.4em, {
    set text(10.5pt, weight: "bold", style: "italic")
    it
  })
}

#show raw.where(block: true): block.with(
  fill: luma(245),
  inset: 8pt,
  radius: 3pt,
  width: 100%,
  stroke: 0.5pt + luma(200),
)

#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

// Helper for key display
#let key(body) = box(
  fill: luma(230),
  stroke: 0.5pt + luma(160),
  radius: 2pt,
  inset: (x: 4pt, y: 2pt),
  outset: (y: 1pt),
  text(size: 9pt, font: "DejaVu Sans Mono", body)
)

// Helper for keybinding table rows
#let kbd(keys, desc) = (key(keys), desc)

// Helper for tip/warning boxes
#let tip(body) = block(
  width: 100%,
  fill: rgb("#e8f5e9"),
  stroke: 1pt + rgb("#4caf50"),
  radius: 3pt,
  inset: 10pt,
  [*Tip:* #body]
)

#let warning(body) = block(
  width: 100%,
  fill: rgb("#fff3e0"),
  stroke: 1pt + rgb("#ff9800"),
  radius: 3pt,
  inset: 10pt,
  [*Warning:* #body]
)

// ═══════════════════════════════════════════════════════════════
// TITLE PAGE
// ═══════════════════════════════════════════════════════════════

#align(center)[
  #v(2in)
  #text(28pt, weight: "bold")[The Complete tmux Guide]
  #v(0.5em)
  #text(14pt, fill: luma(80))[Terminal Multiplexer Setup, Configuration & Usage]
  #v(2em)
  #text(12pt)[Robert Bergman]
  #v(0.3em)
  #text(10pt, fill: luma(100))[#datetime.today().display("[month repr:long] [year]")]
  #v(1em)
  #line(length: 40%, stroke: 0.5pt + luma(180))
  #v(0.5em)
  #text(9pt, fill: luma(120))[tmux 3.6a · macOS / Linux]
]

// ═══════════════════════════════════════════════════════════════
// TABLE OF CONTENTS
// ═══════════════════════════════════════════════════════════════

#pagebreak()
#outline(title: "Table of Contents", indent: 1.5em, depth: 3)

// ═══════════════════════════════════════════════════════════════
// 1. INTRODUCTION
// ═══════════════════════════════════════════════════════════════

= Introduction

== What is tmux?

*tmux* (terminal multiplexer) lets you run multiple terminal sessions inside a single terminal window. It provides three key capabilities:

+ *Multiplexing* — Split your terminal into multiple panes and windows, each running independent processes.
+ *Persistence* — Sessions survive if your terminal closes or your SSH connection drops. Re-attach and pick up where you left off.
+ *Sharing* — Multiple users can attach to the same session for pair programming or demonstrations.

== Key Concepts

#figure(
  table(
    columns: (auto, 1fr),
    inset: 8pt,
    stroke: 0.5pt + luma(200),
    fill: (col, _) => if col == 0 { luma(240) },
    align: (left, left),
    [*Concept*], [*Description*],
    [Server], [Background process that manages all sessions. Starts automatically.],
    [Session], [A collection of windows. You can have many sessions running simultaneously.],
    [Window], [A single screen within a session. Like browser tabs.],
    [Pane], [A subdivision of a window. Each pane runs its own shell.],
    [Prefix], [A key combination pressed before tmux commands. Default: #key("Ctrl+b"). \ Our config uses: #key("Ctrl+a")],
    [Client], [Your terminal connection to a tmux session.],
  ),
  caption: [tmux terminology],
)

== How It All Fits Together

```
tmux server
├── Session: "work"
│   ├── Window 1: "editor"    ← currently active
│   │   ├── Pane 1: vim       ← focused
│   │   ├── Pane 2: terminal
│   │   └── Pane 3: logs
│   ├── Window 2: "git"
│   │   └── Pane 1: shell
│   └── Window 3: "tests"
│       └── Pane 1: test runner
└── Session: "personal"
    └── Window 1: "scratch"
        └── Pane 1: shell
```

// ═══════════════════════════════════════════════════════════════
// 2. INSTALLATION
// ═══════════════════════════════════════════════════════════════

= Installation

== macOS (Homebrew)

```bash
brew install tmux
```

== Linux

```bash
# Debian / Ubuntu
sudo apt-get update && sudo apt-get install -y tmux

# Fedora / RHEL
sudo dnf install -y tmux

# Arch Linux
sudo pacman -Sy tmux
```

== Verify Installation

```bash
tmux -V
# Expected output: tmux 3.6a (or similar)
```

== Using the Install Script

The included `scripts/install-tmux.sh` automates installation across platforms:

```bash
chmod +x scripts/install-tmux.sh
./scripts/install-tmux.sh
```

// ═══════════════════════════════════════════════════════════════
// 3. CONFIGURATION
// ═══════════════════════════════════════════════════════════════

= Configuration

tmux reads its configuration from `~/.tmux.conf` on startup. The included setup script generates a fully-documented config file.

== Running the Setup Script

```bash
chmod +x scripts/setup-tmux-config.sh
./scripts/setup-tmux-config.sh
```

This creates `~/.tmux.conf` (backing up any existing config first).

== Configuration Walkthrough

=== Prefix Key

The default prefix #key("Ctrl+b") is awkward to reach. Our config remaps it to #key("Ctrl+a"):

```bash
unbind C-b
set -g prefix C-a
bind C-a send-prefix
```

#tip[To send a literal `Ctrl+a` to a program inside tmux (e.g., to jump to beginning of line in bash), press #key("Ctrl+a") twice.]

=== Terminal Colors

For proper 256-color and true-color support:

```bash
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"
```

=== Mouse Support

Our config enables mouse for:
- Pane selection (click to focus)
- Pane resizing (drag borders)
- Window selection (click on status bar)
- Scrolling (scroll wheel enters copy mode)

```bash
set -g mouse on
```

=== Intuitive Split Keys

Instead of the cryptic defaults (`"` and `%`), our config uses:

#figure(
  table(
    columns: (auto, 1fr),
    inset: 8pt,
    stroke: 0.5pt + luma(200),
    [*Key*], [*Action*],
    [#key("prefix + |")], [Split pane horizontally (side by side)],
    [#key("prefix + -")], [Split pane vertically (top/bottom)],
  ),
  caption: [Intuitive split bindings],
)

=== Status Bar

The status bar is positioned at the top with a Catppuccin-inspired color scheme:
- *Left:* Session name (pink badge)
- *Center:* Window list with active highlight (blue)
- *Right:* Date and time

== Configuration Reference

Every setting in the generated `.tmux.conf` is documented with inline comments. Key sections:

#figure(
  table(
    columns: (auto, 1fr),
    inset: 8pt,
    stroke: 0.5pt + luma(200),
    fill: (col, _) => if col == 0 { luma(240) },
    [*Section*], [*What It Configures*],
    [General Settings], [Prefix, colors, base index, history, mouse, escape time],
    [Window Management], [Config reload, splits, new window path],
    [Pane Navigation], [Vim-style and Alt+Arrow switching],
    [Pane Resizing], [Prefix + H/J/K/L resize by 5 cells],
    [Window Navigation], [Shift+Arrow switching, window swapping],
    [Copy Mode], [Vi-style selection, clipboard integration],
    [Status Bar], [Position, colors, format, update interval],
    [Plugins], [TPM plugin declarations (commented by default)],
  ),
  caption: [Configuration sections],
)

// ═══════════════════════════════════════════════════════════════
// 4. ESSENTIAL USAGE
// ═══════════════════════════════════════════════════════════════

= Essential Usage

== Starting tmux

```bash
# Start a new unnamed session
tmux

# Start a new named session
tmux new-session -s work

# Start with a specific working directory
tmux new-session -s project -c ~/Projects/myapp
```

== Sessions

Sessions are the top-level organizational unit. You typically create one session per project or context.

=== Creating and Managing Sessions

```bash
# From outside tmux:
tmux new -s <name>           # Create named session
tmux ls                      # List all sessions
tmux attach -t <name>        # Attach to a session
tmux kill-session -t <name>  # Destroy a session
tmux kill-server             # Kill ALL sessions

# From inside tmux (prefix commands):
```

#figure(
  table(
    columns: (auto, 1fr),
    inset: 8pt,
    stroke: 0.5pt + luma(200),
    [*Key*], [*Action*],
    [#key("prefix + d")], [Detach from current session],
    [#key("prefix + s")], [Interactive session list/switcher],
    [#key("prefix + $")], [Rename current session],
    [#key("prefix + (")], [Switch to previous session],
    [#key("prefix + )")], [Switch to next session],
  ),
  caption: [Session key bindings],
)

#tip[Detaching (#key("prefix + d")) leaves the session running in the background. All processes continue. Re-attach anytime with `tmux attach`.]

=== The Session Workflow

```
┌──────────┐    detach     ┌──────────────┐    attach     ┌──────────┐
│  Working  │ ──────────▶  │  Detached     │ ──────────▶  │  Working  │
│  in tmux  │              │  (background) │              │  in tmux  │
└──────────┘    Ctrl+a d   └──────────────┘  tmux attach  └──────────┘
      │                           │                             │
      │    SSH disconnects ──────▶│                             │
      │    Terminal closes ──────▶│                             │
      │    Laptop sleeps ────────▶│                             │
```

== Windows

Windows are like tabs within a session.

#figure(
  table(
    columns: (auto, 1fr),
    inset: 8pt,
    stroke: 0.5pt + luma(200),
    [*Key*], [*Action*],
    [#key("prefix + c")], [Create new window],
    [#key("prefix + ,")], [Rename current window],
    [#key("prefix + &")], [Close current window (with confirmation)],
    [#key("prefix + n")], [Next window],
    [#key("prefix + p")], [Previous window],
    [#key("prefix + 0-9")], [Go to window by number],
    [#key("prefix + w")], [Interactive window/session tree],
    [#key("Shift + Left")], [Previous window (no prefix needed)],
    [#key("Shift + Right")], [Next window (no prefix needed)],
    [#key("prefix + <")], [Swap window left],
    [#key("prefix + >")], [Swap window right],
  ),
  caption: [Window key bindings],
)

== Panes

Panes split a window into multiple terminal areas.

=== Creating Panes

#figure(
  table(
    columns: (auto, 1fr),
    inset: 8pt,
    stroke: 0.5pt + luma(200),
    [*Key*], [*Action*],
    [#key("prefix + |")], [Split horizontally (left/right)],
    [#key("prefix + -")], [Split vertically (top/bottom)],
    [#key("prefix + x")], [Close current pane],
    [#key("prefix + z")], [Toggle zoom (fullscreen pane)],
    [#key("prefix + !")], [Break pane out into its own window],
    [#key("prefix + q")], [Flash pane numbers — press a number to jump],
  ),
  caption: [Pane management bindings],
)

=== Navigating Panes

#figure(
  table(
    columns: (auto, 1fr),
    inset: 8pt,
    stroke: 0.5pt + luma(200),
    [*Key*], [*Action*],
    [#key("prefix + h")], [Move left],
    [#key("prefix + j")], [Move down],
    [#key("prefix + k")], [Move up],
    [#key("prefix + l")], [Move right],
    [#key("Alt + Arrow")], [Move in arrow direction (no prefix)],
  ),
  caption: [Pane navigation bindings],
)

=== Resizing Panes

#figure(
  table(
    columns: (auto, 1fr),
    inset: 8pt,
    stroke: 0.5pt + luma(200),
    [*Key*], [*Action*],
    [#key("prefix + H")], [Grow left by 5 cells],
    [#key("prefix + J")], [Grow down by 5 cells],
    [#key("prefix + K")], [Grow up by 5 cells],
    [#key("prefix + L")], [Grow right by 5 cells],
    [#key("prefix + Space")], [Cycle through preset layouts],
  ),
  caption: [Pane resizing bindings],
)

=== Pane Layouts

tmux has five built-in layouts. Cycle through them with #key("prefix + Space"):

```
even-horizontal    even-vertical      main-horizontal
┌────┬────┬────┐   ┌──────────────┐   ┌──────────────┐
│    │    │    │   │              │   │     main     │
│    │    │    │   ├──────────────┤   ├──────┬───────┤
│    │    │    │   │              │   │      │       │
│    │    │    │   ├──────────────┤   │      │       │
│    │    │    │   │              │   │      │       │
└────┴────┴────┘   └──────────────┘   └──────┴───────┘

main-vertical      tiled
┌──────┬───────┐   ┌──────┬───────┐
│      │       │   │      │       │
│      ├───────┤   │      │       │
│ main │       │   ├──────┼───────┤
│      ├───────┤   │      │       │
│      │       │   │      │       │
└──────┴───────┘   └──────┴───────┘
```

// ═══════════════════════════════════════════════════════════════
// 5. COPY MODE
// ═══════════════════════════════════════════════════════════════

= Copy Mode

Copy mode lets you scroll through terminal output and copy text using vi-style keybindings.

== Entering Copy Mode

- #key("prefix + v") — Enter copy mode (custom binding)
- #key("prefix + [") — Enter copy mode (default binding)
- Scroll up with mouse wheel (if mouse is enabled)

== Navigating in Copy Mode

#figure(
  table(
    columns: (auto, 1fr),
    inset: 8pt,
    stroke: 0.5pt + luma(200),
    [*Key*], [*Action*],
    [#key("h j k l")], [Move cursor (vi-style)],
    [#key("w / b")], [Forward / back by word],
    [#key("Ctrl+u / Ctrl+d")], [Half-page up / down],
    [#key("Ctrl+b / Ctrl+f")], [Full page up / down],
    [#key("g / G")], [Jump to top / bottom],
    [#key("/ or ?")], [Search forward / backward],
    [#key("n / N")], [Next / previous search match],
  ),
  caption: [Copy mode navigation],
)

== Selecting and Copying

+ Press #key("v") to start selection
+ Move cursor to extend selection
+ Press #key("y") to copy (yanks to system clipboard on macOS)
+ Press #key("Ctrl+v") before #key("v") for rectangle/block selection

#tip[On macOS, our config pipes yanked text through `pbcopy`, so it goes straight to your system clipboard. On Linux, change `pbcopy` to `xclip -selection clipboard` or `wl-copy` (Wayland) in `.tmux.conf`.]

== Pasting

- #key("prefix + ]") — Paste the most recent buffer
- `tmux list-buffers` — View all copy buffers
- `tmux show-buffer` — Display the most recent buffer
- `tmux choose-buffer` — Interactive buffer picker

// ═══════════════════════════════════════════════════════════════
// 6. COMMAND MODE
// ═══════════════════════════════════════════════════════════════

= Command Mode

Press #key("prefix + :") to open the tmux command prompt at the bottom of the screen. This gives you access to every tmux command.

== Useful Commands

```bash
# Window and pane manipulation
:new-window -n "logs"
:split-window -h -p 30         # horizontal split, 30% width
:swap-pane -D                  # swap pane downward
:join-pane -s 2 -t 1           # move pane from window 2 to window 1
:break-pane                    # move pane to its own window

# Session management
:new-session -s work
:rename-session production
:switch-client -t other

# Layout
:select-layout even-horizontal
:select-layout main-vertical
:resize-pane -R 10             # grow right 10 cells
:resize-pane -D 5              # grow down 5 cells

# Display
:set status off                # hide status bar
:set status on                 # show status bar
:display-message "#{pane_current_path}"

# Capture and save pane output
:capture-pane -S -3000         # capture last 3000 lines
:save-buffer ~/tmux-output.txt
```

// ═══════════════════════════════════════════════════════════════
// 7. PLUGINS WITH TPM
// ═══════════════════════════════════════════════════════════════

= Plugins with TPM

The Tmux Plugin Manager (TPM) makes it easy to install and manage plugins.

== Installing TPM

```bash
chmod +x scripts/setup-tpm.sh
./scripts/setup-tpm.sh
```

This clones TPM and enables the plugin lines in your `.tmux.conf`.

== Managing Plugins

#figure(
  table(
    columns: (auto, 1fr),
    inset: 8pt,
    stroke: 0.5pt + luma(200),
    [*Key*], [*Action*],
    [#key("prefix + I")], [Install plugins listed in `.tmux.conf`],
    [#key("prefix + U")], [Update all plugins],
    [#key("prefix + Alt+u")], [Remove unlisted plugins],
  ),
  caption: [TPM key bindings],
)

== Recommended Plugins

=== tmux-resurrect

Saves and restores tmux sessions (windows, panes, working directories):

- #key("prefix + Ctrl+s") — Save session
- #key("prefix + Ctrl+r") — Restore session

=== tmux-continuum

Automatic session saving every 15 minutes. Works with tmux-resurrect:

```bash
set -g @continuum-restore 'on'    # auto-restore on tmux start
set -g @continuum-save-interval '15'
```

=== tmux-yank

Enhanced clipboard support across platforms. Automatically uses the right clipboard command for your OS.

== Adding New Plugins

Add a plugin line to `~/.tmux.conf`:

```bash
set -g @plugin 'github-user/plugin-name'
```

Then press #key("prefix + I") to install.

// ═══════════════════════════════════════════════════════════════
// 8. SCRIPTING AND AUTOMATION
// ═══════════════════════════════════════════════════════════════

= Scripting & Automation

tmux's real power emerges when you script it.

== Session Layouts

The included `scripts/tmux-layout-dev.sh` creates a development workspace:

```bash
./scripts/tmux-layout-dev.sh myproject ~/Projects/myapp
```

This creates:
```
Window 1 "editor":              Window 2 "git":    Window 3 "misc":
┌────────────────┬──────────┐   ┌──────────────┐   ┌──────────────┐
│                │ terminal │   │              │   │              │
│   editor       │          │   │   git shell  │   │  free shell  │
│   (70%)        ├──────────┤   │              │   │              │
│                │ watcher  │   │              │   │              │
│                │ (40%)    │   │              │   │              │
└────────────────┴──────────┘   └──────────────┘   └──────────────┘
```

== The Sessionizer

The `scripts/tmux-sessionizer.sh` script provides fast project switching using `fzf`:

```bash
# Install fzf first
brew install fzf

# Run the sessionizer
./scripts/tmux-sessionizer.sh

# Or provide a directory directly
./scripts/tmux-sessionizer.sh ~/Projects/myapp
```

To bind it to a key in tmux, add to `.tmux.conf`:

```bash
bind f run-shell "path/to/tmux-sessionizer.sh"
```

#tip[Copy `tmux-sessionizer.sh` to `~/.local/bin/` and edit the `SEARCH_DIRS` array to match your project directories.]

== Sending Commands to Panes

You can script tmux to send keystrokes to specific panes:

```bash
# Start a session and run commands in specific panes
tmux new-session -d -s dev -c ~/project
tmux send-keys -t dev:1 'vim .' Enter
tmux split-window -h -t dev:1 -c ~/project
tmux send-keys -t dev:1.2 'npm run dev' Enter
tmux split-window -v -t dev:1.2 -c ~/project
tmux send-keys -t dev:1.3 'npm test -- --watch' Enter
tmux attach -t dev
```

== Target Syntax

tmux uses a target syntax to address sessions, windows, and panes:

```
session:window.pane

Examples:
  dev           → session "dev"
  dev:1         → session "dev", window 1
  dev:1.2       → session "dev", window 1, pane 2
  dev:editor    → session "dev", window named "editor"
  :1            → current session, window 1
  :.2           → current session, current window, pane 2
```

// ═══════════════════════════════════════════════════════════════
// 9. ADVANCED TECHNIQUES
// ═══════════════════════════════════════════════════════════════

= Advanced Techniques

== Synchronized Panes

Send the same keystrokes to all panes in a window simultaneously:

```bash
# Toggle synchronized input
:setw synchronize-panes on
:setw synchronize-panes off
```

This is invaluable for running the same command on multiple servers.

== Linking Windows

Share a window between sessions without duplicating it:

```bash
tmux link-window -s source_session:1 -t target_session:5
```

== Hooks

tmux can run commands in response to events:

```bash
# Run a command whenever a new session is created
set-hook -g session-created 'display "Welcome!"'

# Run a command when a pane is closed
set-hook -g pane-died 'respawn-pane -k'

# Auto-rename windows based on running command
set-hook -g pane-focus-in 'rename-window "#{pane_current_command}"'
```

== Environment Variables

tmux manages environment variables that are passed to new panes:

```bash
# Update environment on attach (useful for SSH agent forwarding)
set -g update-environment "SSH_AUTH_SOCK SSH_AGENT_PID DISPLAY"

# Set a variable in the tmux environment
tmux set-environment -g MY_VAR "value"

# Show tmux environment
tmux show-environment -g
```

== Pipe Pane (Logging)

Capture all output from a pane to a file:

```bash
# Start logging current pane
:pipe-pane -o 'cat >> ~/tmux-pane-#{pane_id}.log'

# Stop logging
:pipe-pane
```

== Format Strings

tmux has a powerful format string system for customizing output:

```bash
# List windows with custom format
tmux list-windows -F '#{window_index}: #{window_name} (#{window_panes} panes)'

# List panes with details
tmux list-panes -F '#{pane_index}: #{pane_current_command} [#{pane_width}x#{pane_height}]'

# Display information
tmux display -p '#{session_name}:#{window_index}.#{pane_index}'
```

// ═══════════════════════════════════════════════════════════════
// 10. WORKFLOWS
// ═══════════════════════════════════════════════════════════════

= Workflows

== Remote Development over SSH

```bash
# On the remote server:
tmux new -s work

# ... do your work ...
# Connection drops? No problem.

# Reconnect and reattach:
ssh server
tmux attach -t work
```

#warning[If you nest tmux inside tmux (local + remote), press the prefix *twice* to send commands to the inner tmux. For example, #key("Ctrl+a Ctrl+a c") creates a window in the inner session.]

== Pair Programming

```bash
# Developer A creates a shared session
tmux new -s pair

# Developer B attaches (same machine / SSH)
tmux attach -t pair

# For independent cursors, use grouped sessions:
tmux new -s pair-b -t pair   # shares windows but independent view
```

== IDE-Style Layout

Create a reproducible development environment:

```bash
#!/usr/bin/env bash
# ide.sh — IDE-like tmux layout
SESSION="ide"

tmux new-session -d -s $SESSION -n "code" -c ~/project
tmux send-keys -t $SESSION:code 'nvim .' Enter

tmux new-window -t $SESSION -n "term" -c ~/project
tmux split-window -v -t $SESSION:term -c ~/project -l '30%'
tmux send-keys -t $SESSION:term.1 'git status' Enter
tmux send-keys -t $SESSION:term.2 'npm run dev' Enter

tmux new-window -t $SESSION -n "db" -c ~/project
tmux send-keys -t $SESSION:db 'echo "Database console"' Enter

tmux select-window -t $SESSION:code
tmux attach -t $SESSION
```

// ═══════════════════════════════════════════════════════════════
// 11. TROUBLESHOOTING
// ═══════════════════════════════════════════════════════════════

= Troubleshooting

== Common Issues

=== Colors Look Wrong

```bash
# Verify your terminal supports 256 colors
echo $TERM
# Should show: xterm-256color or similar

# Inside tmux, verify:
tmux info | grep -i rgb
# Should show Tc or RGB capability
```

If colors are still wrong, ensure your terminal emulator (iTerm2, Alacritty, etc.) is set to report `xterm-256color`.

=== Escape Key Has a Delay

This is caused by tmux waiting to see if Escape is part of a multi-key sequence. Our config already fixes this:

```bash
set -sg escape-time 10
```

If you still experience delay, try setting it to `0`.

=== Copy/Paste Not Working

- *macOS:* Ensure `pbcopy` is available. Install `reattach-to-user-namespace` if on an older macOS.
- *Linux:* Install `xclip` or `xsel`, then update the copy command in `.tmux.conf`.

=== Session Not Found on Reattach

```bash
# List running sessions
tmux ls

# If the server died, sessions are lost (use tmux-resurrect to prevent this)
# Check if the server is running
pgrep -f "tmux: server"
```

=== "Terminal is not fully functional" Warnings

```bash
# Set TERM correctly before starting tmux
export TERM=xterm-256color
```

== Useful Debug Commands

```bash
# Show all tmux options and their values
tmux show-options -g         # global options
tmux show-options -w         # window options
tmux show-options -s         # server options

# Show all key bindings
tmux list-keys

# Show tmux info (terminal capabilities)
tmux info

# Show all tmux commands
tmux list-commands
```

// ═══════════════════════════════════════════════════════════════
// 12. QUICK REFERENCE
// ═══════════════════════════════════════════════════════════════

= Quick Reference Card

All bindings below assume the custom config with #key("Ctrl+a") as prefix.

== Sessions

#figure(
  table(
    columns: (1fr, 1fr),
    inset: 6pt,
    stroke: 0.5pt + luma(200),
    [*Key / Command*], [*Action*],
    [`tmux new -s name`], [New named session],
    [`tmux ls`], [List sessions],
    [`tmux attach -t name`], [Attach to session],
    [`tmux kill-session -t name`], [Kill session],
    [#key("prefix + d")], [Detach],
    [#key("prefix + s")], [Session switcher],
    [#key("prefix + $")], [Rename session],
  ),
)

== Windows

#figure(
  table(
    columns: (1fr, 1fr),
    inset: 6pt,
    stroke: 0.5pt + luma(200),
    [*Key*], [*Action*],
    [#key("prefix + c")], [New window],
    [#key("prefix + ,")], [Rename window],
    [#key("prefix + &")], [Close window],
    [#key("prefix + n / p")], [Next / previous],
    [#key("prefix + 0-9")], [Go to window N],
    [#key("prefix + w")], [Window tree],
    [#key("Shift+Left / Right")], [Prev / next (no prefix)],
  ),
)

== Panes

#figure(
  table(
    columns: (1fr, 1fr),
    inset: 6pt,
    stroke: 0.5pt + luma(200),
    [*Key*], [*Action*],
    [#key("prefix + |")], [Split horizontal],
    [#key("prefix + -")], [Split vertical],
    [#key("prefix + x")], [Close pane],
    [#key("prefix + z")], [Toggle zoom],
    [#key("prefix + h/j/k/l")], [Navigate (vim)],
    [#key("prefix + H/J/K/L")], [Resize],
    [#key("Alt+Arrow")], [Navigate (no prefix)],
    [#key("prefix + Space")], [Cycle layouts],
    [#key("prefix + q")], [Show pane numbers],
    [#key("prefix + !")], [Pane to window],
  ),
)

== Copy Mode

#figure(
  table(
    columns: (1fr, 1fr),
    inset: 6pt,
    stroke: 0.5pt + luma(200),
    [*Key*], [*Action*],
    [#key("prefix + v")], [Enter copy mode],
    [#key("v")], [Start selection],
    [#key("y")], [Copy selection],
    [#key("Ctrl+v")], [Rectangle select],
    [#key("/ or ?")], [Search fwd / back],
    [#key("q")], [Exit copy mode],
    [#key("prefix + ]")], [Paste],
  ),
)

// ═══════════════════════════════════════════════════════════════
// 13. SCRIPTS REFERENCE
// ═══════════════════════════════════════════════════════════════

= Included Scripts Reference

#figure(
  table(
    columns: (auto, 1fr),
    inset: 8pt,
    stroke: 0.5pt + luma(200),
    fill: (col, _) => if col == 0 { luma(240) },
    [*Script*], [*Purpose*],
    [`install-tmux.sh`], [Install tmux on macOS (Homebrew) or Linux (apt/dnf/pacman)],
    [`setup-tmux-config.sh`], [Generate a documented `~/.tmux.conf` with sensible defaults],
    [`setup-tpm.sh`], [Install Tmux Plugin Manager and enable plugins],
    [`tmux-sessionizer.sh`], [Fast project-based session creation with fzf],
    [`tmux-layout-dev.sh`], [Create a 3-window development layout],
    [`tmux-cheatsheet.sh`], [Display a quick-reference cheatsheet in the terminal],
  ),
  caption: [Script inventory],
)

All scripts are in the `scripts/` directory. Make them executable with:

```bash
chmod +x scripts/*.sh
```

Optionally, copy frequently-used scripts to your PATH:

```bash
cp scripts/tmux-sessionizer.sh ~/.local/bin/tmux-sessionizer
cp scripts/tmux-cheatsheet.sh ~/.local/bin/tmux-cheatsheet
```
