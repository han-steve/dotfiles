# ── History ───────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=1000000000
SAVEHIST=1000000000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

# ── Options ──────────────────────────────────────────────────────
setopt AUTO_CD
setopt NO_BEEP
setopt INTERACTIVE_COMMENTS

# ── Completion ───────────────────────────────────────────────────
autoload -Uz compinit
compinit -C
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case-insensitive
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Vi mode ──────────────────────────────────────────────────────
bindkey -v
export KEYTIMEOUT=1
bindkey '^R' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '^[[A' history-substring-search-up 2>/dev/null
bindkey '^[[B' history-substring-search-down 2>/dev/null

# ── Plugins (zinit — lazy-loaded) ────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" 2>/dev/null
fi
source "$ZINIT_HOME/zinit.zsh" 2>/dev/null || true

if command -v zinit &>/dev/null; then
    zinit light zsh-users/zsh-autosuggestions
    zinit light zsh-users/zsh-syntax-highlighting
    zinit light zsh-users/zsh-history-substring-search
    zinit light zsh-users/zsh-completions
    zinit snippet OMZP::git               # git aliases (g, ga, gc, gp, etc.)
    zinit snippet OMZP::kubectl            # kubectl aliases (k, kgp, kgs, etc.)
fi

# ── Aliases ──────────────────────────────────────────────────────
alias vi="nvim"
alias vim="nvim"
alias viconfig="nvim ~/.config/nvim/init.lua"
alias zshconfig="nvim ~/.zshrc"
alias tmuxconfig="nvim ~/.tmux.conf"

# Modern replacements
command -v eza &>/dev/null && alias ls="eza --icons" && alias ll="eza -la --icons --git" && alias tree="eza --tree --icons"
command -v bat &>/dev/null && alias cat="bat --paging=never --style=plain"
command -v rg  &>/dev/null && alias grep="rg"
command -v fd  &>/dev/null && alias find="fd"

# Quick navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# k8s
alias k="kubectl"
alias kgp="kubectl get pods"
alias kga="kubectl get all"
alias kgn="kubectl get nodes"
alias kns="kubectl config set-context --current --namespace"
command -v k9s &>/dev/null && alias k9="k9s"

# ── Environment ──────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# macOS homebrew path
[[ -d "/opt/homebrew/bin" ]] && export PATH="/opt/homebrew/bin:$PATH"

# local bin
export PATH="$HOME/.local/bin:$PATH"

# Krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Go
export PATH="$HOME/go/bin:$PATH"

# ── fzf ──────────────────────────────────────────────────────────
if command -v fzf &>/dev/null; then
    # Use fd for fzf if available
    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
    # Load fzf keybindings
    [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
    [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
fi

# ── kubectl completion ──────────────────────────────────────────
command -v kubectl &>/dev/null && source <(kubectl completion zsh)

# ── Conda (if present) ──────────────────────────────────────────
if [[ "$(uname -m)" == "arm64" && -f ~/.start_miniforge3.sh ]]; then
    source ~/.start_miniforge3.sh
elif [[ "$(uname -m)" == "x86_64" && -f ~/.start_miniconda3.sh ]]; then
    source ~/.start_miniconda3.sh
fi

# ── VSCode shell integration ────────────────────────────────────
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# ── Starship prompt ─────────────────────────────────────────────
eval "$(starship init zsh 2>/dev/null)" || true

# ── NVM (lazy-loaded) ───────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
nvm() {
    unset -f nvm node npm npx
    [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"
    nvm "$@"
}
node()  { unset -f nvm node npm npx; [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"; node "$@"; }
npm()   { unset -f nvm node npm npx; [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"; npm "$@"; }
npx()   { unset -f nvm node npm npx; [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"; npx "$@"; }
