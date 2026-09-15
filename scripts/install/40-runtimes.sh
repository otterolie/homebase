#!/bin/bash
# ============================================================
# 40-runtimes.sh - Install language runtimes
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/logger.sh"
source "$SCRIPT_DIR/00-detect-platform.sh"

detect_platform

# Go
if ! command -v go &>/dev/null; then
  log_info "Installing Go 1.27.1..."
  if [[ "$PLATFORM" == "macos" ]]; then
    curl -sL "https://go.dev/dl/go1.27.1.darwin-${ARCH}.tar.gz" | sudo tar -C /usr/local -xz
  else
    curl -sL "https://go.dev/dl/go1.27.1.linux-amd64.tar.gz" | sudo tar -C /usr/local -xz
  fi
  export PATH="/usr/local/go/bin:$PATH"
  log_success "Go installed"
else
  log_info "Go already installed, skipping"
fi

# nvm (setup only, actual loading is lazy in .zshrc)
if [[ ! -d "$HOME/.nvm" ]]; then
  log_info "Installing nvm..."
  curl -so- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  log_success "nvm installed"
else
  log_info "nvm already installed, skipping"
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Node.js 26.8.1
if ! command -v node &>/dev/null; then
  log_info "Installing Node.js 26.8.1..."
  nvm install 26.8.1
  nvm use 26.8.1
  nvm alias default 26.8.1
  log_success "Node.js installed"
else
  log_info "Node.js already installed, skipping"
fi

# pnpm
if ! command -v pnpm &>/dev/null; then
  log_info "Installing pnpm..."
  npm install -g pnpm
  log_success "pnpm installed"
else
  log_info "pnpm already installed, skipping"
fi

# bun
if ! command -v bun &>/dev/null; then
  log_info "Installing bun..."
  curl -fsSL https://bun.sh/install | bash
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  log_success "bun installed"
else
  log_info "bun already installed, skipping"
fi

log_success "Runtimes installed"
