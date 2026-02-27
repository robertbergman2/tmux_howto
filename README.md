# The Complete tmux Guide

Terminal multiplexer setup, configuration, and usage for macOS, Linux, and Windows (WSL).

## What's Included

- **tmux-guide.pdf** — Full reference guide covering sessions, windows, panes, configuration, plugins, scripting, and more
- **tmux-guide.typ** — [Typst](https://typst.app/) source for the guide (`typst compile tmux-guide.typ`)

## Scripts

| Script | Description |
|--------|-------------|
| `scripts/install-tmux.sh` | Install tmux on macOS (Homebrew) or Linux (apt/dnf/pacman) |
| `scripts/install-tmux.ps1` | Install tmux on Windows via WSL |
| `scripts/setup-tmux-config.sh` | Generate a starter `~/.tmux.conf` |
| `scripts/setup-tpm.sh` | Install [TPM](https://github.com/tmux-plugins/tpm) (Tmux Plugin Manager) |
| `scripts/tmux-cheatsheet.sh` | Print a quick-reference cheatsheet to the terminal |
| `scripts/tmux-layout-dev.sh` | Launch a pre-configured development layout |
| `scripts/tmux-sessionizer.sh` | Fuzzy-find and switch between project sessions |

## Quick Start

```bash
# Install tmux
./scripts/install-tmux.sh

# Set up a config and plugin manager
./scripts/setup-tmux-config.sh
./scripts/setup-tpm.sh

# Launch a dev layout
./scripts/tmux-layout-dev.sh
```

### Windows (PowerShell)

```powershell
.\scripts\install-tmux.ps1
```

Requires [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) — tmux does not run natively on Windows.

## Building the Guide

Requires [Typst](https://github.com/typst/typst):

```bash
typst compile tmux-guide.typ
```

## License

MIT
