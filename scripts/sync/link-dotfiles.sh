#!/bin/bash
# ============================================================
# link-dotfiles.sh - Symlink dotfiles from repo to home
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOMEBASE_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$SCRIPT_DIR/../utils/logger.sh"

log_info "Linking dotfiles from $HOMEBASE_DIR/dotfiles..."

# Create .config directories if they don't exist
mkdir -p "$HOME/.config/lazygit"

# Link .zshrc
if [[ -L "$HOME/.zshrc" ]] || [[ ! -f "$HOME/.zshrc" ]]; then
  ln -sf "$HOMEBASE_DIR/dotfiles/.zshrc.shared" "$HOME/.zshrc"
  log_success "Linked .zshrc"
else
  log_warning ".zshrc exists and is not a symlink, skipping (backup first)"
fi

# Link .tmux.conf
if [[ -L "$HOME/.tmux.conf" ]] || [[ ! -f "$HOME/.tmux.conf" ]]; then
  ln -sf "$HOMEBASE_DIR/dotfiles/.tmux.conf" "$HOME/.tmux.conf"
  log_success "Linked .tmux.conf"
else
  log_warning ".tmux.conf exists and is not a symlink, skipping"
fi

# Link .gitconfig
if [[ -L "$HOME/.gitconfig" ]] || [[ ! -f "$HOME/.gitconfig" ]]; then
  ln -sf "$HOMEBASE_DIR/dotfiles/.gitconfig" "$HOME/.gitconfig"
  log_success "Linked .gitconfig"
else
  log_warning ".gitconfig exists and is not a symlink, skipping"
fi

# Link starship.toml
if [[ -L "$HOME/.config/starship.toml" ]] || [[ ! -f "$HOME/.config/starship.toml" ]]; then
  ln -sf "$HOMEBASE_DIR/dotfiles/starship.toml" "$HOME/.config/starship.toml"
  log_success "Linked starship.toml"
else
  log_warning "starship.toml exists and is not a symlink, skipping"
fi

# Link lazygit config
if [[ -L "$HOME/.config/lazygit/config.yml" ]] || [[ ! -f "$HOME/.config/lazygit/config.yml" ]]; then
  ln -sf "$HOMEBASE_DIR/dotfiles/lazygit-config.yml" "$HOME/.config/lazygit/config.yml"
  log_success "Linked lazygit config"
else
  log_warning "lazygit config exists and is not a symlink, skipping"
fi

# Setup secrets file if it doesn't exist
if [[ ! -f "$HOME/.zshrc.secrets" ]]; then
  log_info "Creating .zshrc.secrets from template..."
  cp "$HOMEBASE_DIR/dotfiles/.zshrc.secrets.template" "$HOME/.zshrc.secrets"
  log_warning "Edit ~/.zshrc.secrets and add your API keys!"
fi

log_success "Dotfiles linked successfully"
