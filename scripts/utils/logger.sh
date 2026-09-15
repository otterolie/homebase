#!/bin/bash
# ============================================================
# logger.sh - Colored logging utilities
# ============================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log_header() {
  echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${PURPLE}  $1${NC}"
  echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

log_section() {
  echo -e "\n${CYAN}▶ $1${NC}"
}

log_info() {
  echo -e "  ${BLUE}ℹ${NC} $1"
}

log_success() {
  echo -e "  ${GREEN}✓${NC} $1"
}

log_warning() {
  echo -e "  ${YELLOW}⚠${NC} $1"
}

log_error() {
  echo -e "  ${RED}✗${NC} $1"
}

log_step() {
  echo -e "${CYAN}  [$1/$2]${NC} $3"
}
