#!/usr/bin/env bash

set -euo pipefail
export USER_NAME=${USER_NAME:-$USER}

# Extra commands after installing AUR packages

# Set user shell
sudo chsh -s "$(which zsh)" "$USER_NAME"

