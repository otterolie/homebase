# Performance Optimizations

## Shell Startup Speed

### Benchmark

```bash
# Before optimization
time zsh -i -c exit
# Typical: 500-800ms

# After optimization
time zsh -i -c exit
# Target: <200ms
```

### Optimizations Applied

#### 1. Lazy-load nvm (~300ms saved)

Instead of loading nvm on every shell start, we use stub functions:

```bash
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}
```

First call to `node` loads nvm, subsequent calls are fast.

#### 2. Deferred Initialization (~100ms saved)

Non-critical tools load in background:

```bash
{
  eval "$(direnv hook zsh)"
  eval "$(fzf --zsh)"
} &!
```

#### 3. Async Plugin Loading (~50ms saved)

Syntax highlighting and autosuggestions load after shell is interactive:

```bash
{
  source "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/..."
  source "$ZSH_CUSTOM/plugins/zsh-autosuggestions/..."
} &!
```

#### 4. Reduced Oh-My-Zsh Plugins

Only essential plugins in `plugins=()` array:
- git (core Git support)
- vi-mode (vim bindings)

Everything else loaded async or omitted.

## Installation Speed

### Optimizations

#### 1. Pre-built Binaries

Instead of compiling:
- eza: 5 sec (vs 2-3 min compile)
- delta: 5 sec (vs 3-4 min compile)
- lazygit: 5 sec (vs manual build)

#### 2. Parallel Downloads

Multiple binaries download simultaneously.

#### 3. Skip Existing Tools

Bootstrap checks if tools exist before installing.

### Benchmark

- **Old approach**: 60-90 minutes
- **Optimized**: 15-20 minutes

## Starship Prompt Speed

Reduced checks in `starship.toml`:

```toml
command_timeout = 500  # down from 1000ms

[nodejs]
detect_files = ["package.json"]  # only check if package.json exists
```

## Profiling

### zsh Startup

```bash
# Enable profiling
zmodload zsh/zprof

# Source .zshrc
source ~/.zshrc

# Show profile
zprof
```

### Tool Benchmarks

```bash
# Test lazy-loading
time node --version  # First call: ~100ms (loads nvm)
time node --version  # Second call: <10ms

# Test zoxide
time z ~  # Should be instant

# Test starship
time starship prompt  # Should be <100ms
```

## Further Optimizations

### If Still Slow

1. **Remove unused PATH entries**
   ```bash
   echo $PATH | tr ':' '\n'  # Review each entry
   ```

2. **Disable unused eval statements**
   Comment out in .zshrc

3. **Use compinit caching**
   Already enabled in homebase .zshrc

### macOS Specific

If using Homebrew, consider:
```bash
# Defer brew shellenv
eval "$(/opt/homebrew/bin/brew shellenv)" &!
```
