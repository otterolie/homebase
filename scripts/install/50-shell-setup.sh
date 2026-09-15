#!/bin/bash
# ============================================================
# 50-shell-setup.sh - Setup Oh-My-Zsh and plugins
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/logger.sh"

# Oh-My-Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log_info "Installing Oh-My-Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  log_success "Oh-My-Zsh installed"
else
  log_info "Oh-My-Zsh already installed, skipping"
fi

# zsh-syntax-highlighting
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
  log_info "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
  log_success "zsh-syntax-highlighting installed"
else
  log_info "zsh-syntax-highlighting already installed, skipping"
fi

# zsh-autosuggestions
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
  log_info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  log_success "zsh-autosuggestions installed"
else
  log_info "zsh-autosuggestions already installed, skipping"
fi

log_success "Shell setup complete"
