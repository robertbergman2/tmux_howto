#Requires -Version 5.1
<#
.SYNOPSIS
    Install tmux on Windows via WSL or report available options.
.DESCRIPTION
    tmux does not run natively on Windows. This script installs it inside WSL
    (Windows Subsystem for Linux) or guides the user toward alternatives.
#>
[CmdletBinding()]
param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

function Test-WslAvailable {
    try {
        $null = Get-Command wsl -ErrorAction Stop
        $distros = wsl --list --quiet 2>$null
        return ($null -ne $distros -and $distros.Length -gt 0)
    } catch {
        return $false
    }
}

function Install-TmuxViaWsl {
    Write-Host 'Detecting WSL package manager...'

    # Check if tmux is already installed
    $existing = wsl -- which tmux 2>$null
    if ($existing -and -not $Force) {
        $version = wsl -- tmux -V 2>$null
        Write-Host "tmux is already installed in WSL: $version"
        $answer = Read-Host 'Reinstall? [y/N]'
        if ($answer -notmatch '^[Yy]$') { return }
    }

    # Detect package manager and install
    $hasApt = wsl -- sh -c 'command -v apt-get' 2>$null
    $hasDnf = wsl -- sh -c 'command -v dnf' 2>$null

    if ($hasApt) {
        Write-Host 'Installing tmux via apt...'
        wsl -- sudo apt-get update
        wsl -- sudo apt-get install -y tmux
    } elseif ($hasDnf) {
        Write-Host 'Installing tmux via dnf...'
        wsl -- sudo dnf install -y tmux
    } else {
        Write-Error 'No supported package manager found in WSL (apt, dnf).'
    }

    $version = wsl -- tmux -V 2>$null
    Write-Host "Installed: $version"
}

# --- Main ---

if (-not (Test-WslAvailable)) {
    Write-Host @'
tmux does not run natively on Windows. Options:

  1. Install WSL (recommended):
       wsl --install
     Then re-run this script.

  2. Use Git Bash with tmux (limited):
       pacman -S tmux   (inside Git Bash / MSYS2)

  3. Use Windows Terminal + WSL for a full tmux experience.
'@
    exit 1
}

Install-TmuxViaWsl
