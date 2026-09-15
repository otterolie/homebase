#!/bin/bash
# ============================================================
# backup-dotfiles.sh - Backup existing dotfiles before linking
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/logger.sh"

BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

DOTFILES=(
  "$HOME/.zshrc"
  "$HOME/.tmux.conf"
  "$HOME/.gitconfig"
  "$HOME/.config/starship.toml"
  "$HOME/.config/lazygit/config.yml"
)

log_info "Backing up existing dotfiles to $BACKUP_DIR..."

mkdir -p "$BACKUP_DIR"

backed_up=0
for file in "${DOTFILES[@]}"; do
  if [[ -f "$file" ]] || [[ -L "$file" ]]; then
    cp -P "$file" "$BACKUP_DIR/" 2>/dev/null && ((backed_up++))
  fi
done

if [[ $backed_up -gt 0 ]]; then
  log_success "Backed up $backed_up dotfiles to $BACKUP_DIR"
else
  log_info "No existing dotfiles to backup"
  rmdir "$BACKUP_DIR" 2>/dev/null
fi
