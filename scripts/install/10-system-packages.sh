#!/bin/bash
# ============================================================
# 10-system-packages.sh - Install system packages
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/logger.sh"
source "$SCRIPT_DIR/00-detect-platform.sh"

detect_platform

if [[ "$PLATFORM" == "debian" || "$PLATFORM" == "ubuntu" ]]; then
  log_info "Installing Debian/Ubuntu packages..."

  sudo apt update -qq
  sudo apt install -y \
    build-essential \
    curl \
    wget \
    git \
    zsh \
    tmux \
    vim \
    neovim \
    mosh \
    ripgrep \
    fd-find \
    pkg-config \
    libssl-dev \
    python3 \
    python3-pip \
    unzip \
    || { log_error "Some apt packages failed"; exit 1; }

  # Create fd symlink (Debian packages it as fdfind)
  if [[ ! -f /usr/local/bin/fd ]] && command -v fdfind >/dev/null; then
    sudo ln -s $(which fdfind) /usr/local/bin/fd
    log_success "Created fd symlink"
  fi

  # Set zsh as default shell
  if [[ "$SHELL" != *"zsh"* ]]; then
    sudo chsh -s $(which zsh) $USER
    log_success "Set zsh as default shell"
  fi

elif [[ "$PLATFORM" == "macos" ]]; then
  log_info "Installing macOS packages via Homebrew..."

  if ! command -v brew &>/dev/null; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  brew install \
    git \
    zsh \
    tmux \
    neovim \
    ripgrep \
    fd \
    mosh \
    || { log_error "Some brew packages failed"; exit 1; }
fi

log_success "System packages installed"
