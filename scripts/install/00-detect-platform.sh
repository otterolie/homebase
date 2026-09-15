#!/bin/bash
# ============================================================
# 00-detect-platform.sh - Detect OS and architecture
# ============================================================

detect_platform() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    export PLATFORM="macos"
    export ARCH=$(uname -m)
    export PKG_MANAGER="brew"
  elif [[ -f /etc/os-release ]]; then
    . /etc/os-release
    export PLATFORM="${ID,,}"  # debian, ubuntu, etc.
    export ARCH=$(uname -m)
    export PKG_MANAGER="apt"
  else
    export PLATFORM="unknown"
    export ARCH=$(uname -m)
    export PKG_MANAGER="unknown"
  fi

  [[ -n "${HOMEBASE_QUIET:-}" ]] || log_info "Detected platform: $PLATFORM ($ARCH)"
}

# Auto-detect if sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  detect_platform
fi
