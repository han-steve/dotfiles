# Steve Han's Dotfiles

Cross-platform dev environment for macOS and Ubuntu/Debian servers.

## What's Included

| Tool | Purpose | Replaces |
|------|---------|----------|
| [starship](https://starship.rs) | Fast, customizable prompt | oh-my-zsh + spaceship |
| [zinit](https://github.com/zdharber/zinit) | Lightweight zsh plugin manager | oh-my-zsh |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Neovim plugin manager | vim-plug |
| [catppuccin](https://github.com/catppuccin) | Color scheme (mocha) | base16 |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder | fzf.vim |
| [eza](https://github.com/eza-community/eza) | Modern `ls` | ls |
| [bat](https://github.com/sharkdp/bat) | Better `cat` | cat |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast `grep` | grep |
| [fd](https://github.com/sharkdp/fd) | Better `find` | find |
| tmux + TPM | Terminal multiplexer | — |
| [ghostty](https://ghostty.org) | Terminal emulator | iterm2 |

Optional: `kubectl`, `k9s`, `helm` (with `--k8s` flag).

## Install

```bash
git clone https://github.com/han-steve/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh          # standard install
bash install.sh --k8s    # include k8s tools
```

Then open a new terminal. Neovim plugins auto-install on first launch.

## Homelab Nodes

Ubuntu k3s worker nodes use a separate terminal-only entrypoint so the homelab
Ansible bootstrap can install the Linux zsh/Starship experience without
touching the desktop bootstrap:

```bash
homelab-node/bootstrap.sh --link
```

For tmux plugins: open tmux and press `prefix + I` (Ctrl-A then I).

## Structure

```
install.sh              # One-script installer (macOS + Ubuntu)
zsh/.zshrc              # Unified zsh config (vi-mode, aliases, lazy nvm)
starship/starship.toml  # Starship prompt config
nvim/init.lua           # Neovim entry point
nvim/lua/options.lua    # Editor options
nvim/lua/keymaps.lua    # Key bindings
nvim/lua/plugins.lua    # lazy.nvim plugin specs
tmux/.tmux.conf         # Tmux config (Ctrl-A prefix, vim nav)
ghostty/config           # Ghostty terminal config (padding, opacity, theme)
ghostty/ghostty.sh       # Standalone ghostty symlink script
git/.gitconfig          # Git aliases and defaults
```

## Key Bindings

### Zsh
- Vi mode enabled (press Esc for normal mode)
- `Ctrl+R` — reverse history search
- Aliases: `ll`, `k`, `kgp`, `vi`, etc.

### Neovim
- `Space` — leader key
- `Ctrl+P` — fuzzy file finder
- `Space+fg` — live grep
- `Space+e` — file tree
- `gcc` / `gc` — toggle comment
- `Space+w` — save, `Space+q` — quit

### Tmux
- `Ctrl+A` — prefix (not Ctrl+B)
- `prefix |` — vertical split
- `prefix -` — horizontal split
- `prefix r` — reload config
- `Ctrl+h/j/k/l` — navigate panes (works in nvim too, process-tree aware)
- `prefix h/j/k/l` — navigate panes (fallback without smart switching)
