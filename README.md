# Homebase - Personal Dotfiles & Dev Environment

> Complete development environment setup with optimizations for speed and productivity

One command to feel at home on any server.

## Quick Start

### Fresh Installation

```bash
git clone https://github.com/otterolie/homebase.git ~/homebase
cd ~/homebase
./bootstrap.sh
```

### Server Hardening (Optional)

After bootstrap, apply production server optimizations:

```bash
sudo ./scripts/optimize-server.sh
```

This configures swap, hardens SSH, optimizes network settings, and more.

## What's Included

### Dotfiles
- `.zshrc` - Enhanced Zsh with lazy-loading, modern aliases
- `.tmux.conf` - Tmux with Catppuccin theme & vim bindings (Ctrl+a prefix)
- `.gitconfig` - Git aliases & delta integration
- `starship.toml` - Fast prompt
- `lazygit/config.yml` - Lazygit with Catppuccin theme

### Tools

**System Packages:**
git, zsh, tmux, neovim, mosh, ripgrep, fd-find, build-essential

**Modern CLI:**
eza (ls), bat (cat), zoxide (cd), fzf (fuzzy find), delta (git diff)

**Development:**
lazygit, btop, direnv, dust

**Runtimes:**
Rust, Go 1.27.1, Node 26.8.1 (via nvm), pnpm, bun

**Shell:**
Oh-My-Zsh + syntax-highlighting + autosuggestions

## Platform Support

- macOS (Homebrew)
- Debian 12
- Ubuntu 22.04+

## Optimizations

### Shell Startup (~150ms)
- Lazy-loaded nvm, direnv
- Deferred plugin loading
- Async initialization

### Installation (15-20 min)
- Parallel downloads
- Pre-built binaries preferred over compilation
- Optimized dependency order

## Manual Sync

```bash
cd ~/homebase
git add dotfiles/
git commit -m "Update dotfiles from $(hostname)"
git push
```

## Security

- API keys stored in `~/.zshrc.secrets` (not tracked)
- SSH config uses templates
- Pre-commit hooks prevent secret leaks

## Configuration

### Setting up Secrets

```bash
cp dotfiles/.zshrc.secrets.template ~/.zshrc.secrets
# Edit ~/.zshrc.secrets with your API keys
```

### Customization

All configs use symlinks, so edit in place:
```bash
vim ~/.zshrc  # Actually edits ~/homebase/dotfiles/.zshrc.shared
```

Changes are automatically tracked in the git repo.

## Documentation

- [Installation Guide](docs/INSTALL.md)
- [Optimizations](docs/OPTIMIZATIONS.md)
- [Tool Audit](docs/TOOL-AUDIT.md)

## License

MIT
