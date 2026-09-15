# Installation Guide

## Quick Start

```bash
git clone https://github.com/otterolie/homebase.git ~/homebase
cd ~/homebase
./bootstrap.sh
```

## What Bootstrap Does

1. **Backs up** existing dotfiles to `~/.dotfiles_backup_TIMESTAMP`
2. **Installs** system packages (git, zsh, tmux, vim, mosh, ripgrep, fd)
3. **Installs** runtimes (Rust, Go, Node.js via nvm, pnpm, bun)
4. **Installs** Rust tools (bat, zoxide, starship)
5. **Downloads** pre-built binaries (eza, delta, lazygit, btop, fzf, direnv)
6. **Sets up** Oh-My-Zsh with plugins
7. **Links** dotfiles to your home directory

## Post-Install

### 1. Configure Secrets

```bash
vim ~/.zshrc.secrets
# Add your API keys
```

### 2. Restart Shell

```bash
exec zsh
```

### 3. Verify Installation

```bash
starship --version
eza --version
bat --version
zoxide --version
node --version
```

## Platform Support

- ✅ macOS (Homebrew)
- ✅ Debian 12+
- ✅ Ubuntu 22.04+

## Troubleshooting

### Shell Startup Slow

Benchmark it:
```bash
time zsh -i -c exit
```

Should be <200ms. If slower, run:
```bash
cd ~/homebase
git pull
./bootstrap.sh  # Re-apply optimizations
```

### Tools Not Found

Make sure `~/.local/bin` is in your PATH:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Lazy-loading Not Working

Verify nvm stub functions exist:
```bash
type nvm
# Should show: nvm is a shell function
```

## Manual Installation

If you prefer to install step-by-step:

```bash
cd ~/homebase

# 1. System packages
bash scripts/install/10-system-packages.sh

# 2. Runtimes
bash scripts/install/40-runtimes.sh

# 3. Rust tools
bash scripts/install/20-rust-tools.sh

# 4. Binary downloads
bash scripts/install/30-binary-downloads.sh

# 5. Shell setup
bash scripts/install/50-shell-setup.sh

# 6. Link dotfiles
bash scripts/sync/link-dotfiles.sh
```
