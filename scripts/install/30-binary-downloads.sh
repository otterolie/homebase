#!/bin/bash
# ============================================================
# 30-binary-downloads.sh - Download pre-built binaries
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/logger.sh"
source "$SCRIPT_DIR/00-detect-platform.sh"

detect_platform

INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# Add to PATH if not already there
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
  export PATH="$INSTALL_DIR:$PATH"
fi

log_info "Installing pre-built binaries to $INSTALL_DIR..."

# eza
if ! command -v eza &>/dev/null; then
  log_info "Installing eza..."
  if [[ "$PLATFORM" == "macos" ]]; then
    curl -sL "https://github.com/eza-community/eza/releases/download/v0.20.18/eza_x86_64-apple-darwin.tar.gz" | tar xz -C "$INSTALL_DIR"
  else
    curl -sL "https://github.com/eza-community/eza/releases/download/v0.20.18/eza_x86_64-unknown-linux-gnu.tar.gz" | tar xz -C "$INSTALL_DIR"
  fi
  log_success "eza installed"
fi

# delta
if ! command -v delta &>/dev/null; then
  log_info "Installing delta..."
  if [[ "$PLATFORM" == "macos" ]]; then
    curl -sL "https://github.com/dandavison/delta/releases/download/0.18.2/delta-0.18.2-x86_64-apple-darwin.tar.gz" | tar xz --strip-components=1 -C "$INSTALL_DIR"
  else
    curl -sL "https://github.com/dandavison/delta/releases/download/0.18.2/delta-0.18.2-x86_64-unknown-linux-gnu.tar.gz" | tar xz --strip-components=1 -C "$INSTALL_DIR"
  fi
  log_success "delta installed"
fi

# lazygit
if ! command -v lazygit &>/dev/null; then
  log_info "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*' || echo "0.65.1")

  if [[ "$PLATFORM" == "macos" ]]; then
    curl -sL "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Darwin_x86_64.tar.gz" | tar xz -C "$INSTALL_DIR"
  else
    curl -sL "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" | tar xz -C "$INSTALL_DIR"
  fi
  log_success "lazygit installed"
fi

# fzf
if ! command -v fzf &>/dev/null; then
  log_info "Installing fzf..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --bin --no-update-rc --no-bash --no-fish
  ln -sf ~/.fzf/bin/fzf "$INSTALL_DIR/fzf"
  log_success "fzf installed"
fi

# btop
if ! command -v btop &>/dev/null; then
  log_info "Installing btop..."
  if [[ "$PLATFORM" == "macos" ]]; then
    brew install btop 2>/dev/null || log_warning "btop install failed"
  else
    BTOP_VERSION="1.4.0"
    curl -sL "https://github.com/aristocratos/btop/releases/download/v${BTOP_VERSION}/btop-x86_64-linux-musl.tbz" | tar xj -C /tmp
    cp /tmp/btop/bin/btop "$INSTALL_DIR/"
    rm -rf /tmp/btop
  fi
  [[ -f "$INSTALL_DIR/btop" ]] && log_success "btop installed"
fi

# direnv
if ! command -v direnv &>/dev/null; then
  log_info "Installing direnv..."
  curl -sfL https://direnv.net/install.sh | bash
  log_success "direnv installed"
fi

log_success "Binary downloads complete"
