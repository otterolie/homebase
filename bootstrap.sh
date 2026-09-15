#!/bin/bash
# ============================================================
# bootstrap.sh - Homebase Environment Setup
# One command to feel at home on any server
# ============================================================

set -e

HOMEBASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HOMEBASE_DIR"

source scripts/utils/logger.sh

log_header "Homebase Bootstrap - Dev Environment Setup"

# Detect platform
source scripts/install/00-detect-platform.sh
detect_platform

log_info "Platform: $PLATFORM ($ARCH)"
log_info "Package Manager: $PKG_MANAGER"
echo ""

# Step 1: Backup existing dotfiles
log_step 1 7 "Backing up existing dotfiles"
bash scripts/sync/backup-dotfiles.sh

# Step 2: Install system packages
log_step 2 7 "Installing system packages"
bash scripts/install/10-system-packages.sh || log_warning "Some system packages failed"

# Step 3: Install runtimes (needed for tools)
log_step 3 7 "Installing runtimes (Rust, Go, Node)"
bash scripts/install/40-runtimes.sh || log_warning "Some runtimes failed"

# Step 4: Install Rust tools (can run in parallel with binaries)
log_step 4 7 "Installing Rust tools (bat, zoxide, starship)"
bash scripts/install/20-rust-tools.sh || log_warning "Some Rust tools failed"

# Step 5: Download pre-built binaries
log_step 5 7 "Downloading pre-built binaries (eza, delta, lazygit, etc.)"
bash scripts/install/30-binary-downloads.sh || log_warning "Some binary downloads failed"

# Step 6: Setup shell
log_step 6 7 "Setting up Oh-My-Zsh and plugins"
bash scripts/install/50-shell-setup.sh

# Step 7: Link dotfiles
log_step 7 7 "Linking dotfiles"
bash scripts/sync/link-dotfiles.sh

# Install git hooks
log_section "Installing git hooks"
bash scripts/sync/install-hooks.sh

echo ""
log_header "Bootstrap Complete!"

log_success "Your homebase environment is ready"
echo ""
log_info "Next steps:"
echo "  1. Edit ~/.zshrc.secrets and add your API keys"
echo "  2. Restart your shell: exec zsh"
echo "  3. Test with: starship --version && eza --version"
echo ""
log_info "To sync dotfiles:"
echo "  cd ~/homebase && git add dotfiles/ && git commit -m \"Update\" && git push"
echo ""
