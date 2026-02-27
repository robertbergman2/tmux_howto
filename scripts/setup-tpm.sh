#!/usr/bin/env bash
# setup-tpm.sh — Install Tmux Plugin Manager and enable plugins
set -euo pipefail

TPM_DIR="${HOME}/.tmux/plugins/tpm"
CONF="${HOME}/.tmux.conf"

if [[ -d "$TPM_DIR" ]]; then
    echo "TPM already installed at ${TPM_DIR}"
    echo "Updating..."
    git -C "$TPM_DIR" pull
else
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Enable plugin lines in .tmux.conf if they're commented out
if [[ -f "$CONF" ]]; then
    sed -i.bak 's/^# *\(set -g @plugin\)/\1/' "$CONF"
    sed -i.bak "s|^# *\(run '~/.tmux/plugins/tpm/tpm'\)|\1|" "$CONF"
    rm -f "${CONF}.bak"
    echo "Enabled plugin lines in ${CONF}"
fi

echo ""
echo "TPM installed. To install plugins:"
echo "  1. Start tmux"
echo "  2. Press prefix + I (capital I) to install plugins"
echo ""
echo "Included plugins:"
echo "  - tmux-sensible    : Universal sensible defaults"
echo "  - tmux-resurrect   : Save/restore sessions across restarts"
echo "  - tmux-continuum   : Automatic session saving"
echo "  - tmux-yank        : Clipboard integration"
