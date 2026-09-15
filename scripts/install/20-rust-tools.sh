#!/bin/bash
# ============================================================
# 20-rust-tools.sh - Install Rust and Rust-based tools
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/logger.sh"

# Install Rust if not present
if ! command -v cargo &>/dev/null; then
  log_info "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
  log_success "Rust installed"
else
  log_info "Rust already installed, skipping"
fi

# Tools to install via cargo (only if not already available)
CARGO_TOOLS=(
  "bat"
  "zoxide"
  "starship"
)

log_info "Installing Rust-based tools..."

for tool in "${CARGO_TOOLS[@]}"; do
  if ! command -v "$tool" &>/dev/null; then
    log_info "Installing $tool..."
    cargo install "$tool" --quiet || log_warning "Failed to install $tool"
  else
    log_info "$tool already installed, skipping"
  fi
done

log_success "Rust tools installed"
