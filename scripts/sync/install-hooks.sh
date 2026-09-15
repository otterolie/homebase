#!/bin/bash
# ============================================================
# install-hooks.sh - Install git hooks
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOMEBASE_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$SCRIPT_DIR/../utils/logger.sh"

log_info "Installing git hooks..."

# Link pre-commit hook
if [[ -f "$HOMEBASE_DIR/hooks/pre-commit" ]]; then
  ln -sf "$HOMEBASE_DIR/hooks/pre-commit" "$HOMEBASE_DIR/.git/hooks/pre-commit"
  chmod +x "$HOMEBASE_DIR/hooks/pre-commit"
  log_success "Installed pre-commit hook"
fi

log_success "Git hooks installed"
