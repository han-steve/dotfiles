#!/usr/bin/env bash
set -euo pipefail

# Steve Han's dotfiles — cross-platform installer (macOS + Ubuntu/Debian)
# Usage: bash install.sh [--k8s] [--all]

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"

info()  { printf "\033[1;34m[info]\033[0m  %s\n" "$1"; }
ok()    { printf "\033[1;32m[ok]\033[0m    %s\n" "$1"; }
warn()  { printf "\033[1;33m[warn]\033[0m  %s\n" "$1"; }

# ── Package installation ────────────────────────────────────────
install_packages_ubuntu() {
    info "Installing packages (apt)..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq \
        zsh tmux neovim git curl wget unzip \
        ripgrep fd-find bat fzf jq htop \
        fontconfig build-essential
    # Ubuntu renames fd and bat
    [[ ! -L /usr/local/bin/fd ]]  && sudo ln -sf "$(which fdfind 2>/dev/null || echo /usr/bin/fdfind)" /usr/local/bin/fd 2>/dev/null || true
    [[ ! -L /usr/local/bin/bat ]] && sudo ln -sf "$(which batcat 2>/dev/null || echo /usr/bin/batcat)" /usr/local/bin/bat 2>/dev/null || true
    # eza (modern ls) — not in default repos, install from GitHub
    if ! command -v eza &>/dev/null; then
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg 2>/dev/null || true
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
        sudo apt-get update -qq && sudo apt-get install -y -qq eza 2>/dev/null || warn "eza install failed, using ls"
    fi
    ok "System packages installed"
}

install_packages_macos() {
    info "Installing packages (brew)..."
    if ! command -v brew &>/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install zsh tmux neovim git curl wget \
        ripgrep fd bat eza fzf jq htop
    ok "Homebrew packages installed"
}

# ── Starship prompt ─────────────────────────────────────────────
install_starship() {
    if command -v starship &>/dev/null; then
        ok "Starship already installed"
        return
    fi
    info "Installing starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    ok "Starship installed"
}

# ── Zsh setup ────────────────────────────────────────────────────
setup_zsh() {
    info "Setting up zsh..."
    ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    ok "Zsh configured (starship prompt)"
}

# ── Tmux ─────────────────────────────────────────────────────────
setup_tmux() {
    info "Setting up tmux..."
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
    ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
    ok "Tmux configured (run prefix+I to install plugins)"
}

# ── Neovim ───────────────────────────────────────────────────────
setup_nvim() {
    info "Setting up neovim..."
    mkdir -p "$HOME/.config/nvim/lua"
    ln -sf "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
    ln -sf "$DOTFILES_DIR/nvim/lua/plugins.lua" "$HOME/.config/nvim/lua/plugins.lua"
    ln -sf "$DOTFILES_DIR/nvim/lua/keymaps.lua" "$HOME/.config/nvim/lua/keymaps.lua"
    ln -sf "$DOTFILES_DIR/nvim/lua/options.lua" "$HOME/.config/nvim/lua/options.lua"
    ok "Neovim configured (lazy.nvim — run nvim to auto-bootstrap)"
}

# ── Ghostty ──────────────────────────────────────────────────────
setup_ghostty() {
    info "Setting up ghostty..."
    if [[ "$OS" == "Darwin" ]]; then
        command -v ghostty &>/dev/null || brew install --cask ghostty || warn "ghostty cask install failed"
        mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
        ln -sf "$DOTFILES_DIR/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
    else
        command -v ghostty &>/dev/null || warn "ghostty isn't packaged via apt — install from ghostty.org, config will still be linked"
        mkdir -p "$HOME/.config/ghostty"
        ln -sf "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
    fi
    ok "Ghostty config linked"
}

# ── Git ──────────────────────────────────────────────────────────
setup_git() {
    info "Setting up git..."
    ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
    ok "Git configured"
}

# ── Starship config ─────────────────────────────────────────────
setup_starship_config() {
    info "Setting up starship config..."
    mkdir -p "$HOME/.config"
    ln -sf "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
    ok "Starship prompt config linked"
}

# ── K8s tools ────────────────────────────────────────────────────
install_k8s_tools() {
    info "Installing k8s tools..."
    local arch
    arch="$(uname -m)"
    [[ "$arch" == "x86_64" ]] && arch="amd64"
    [[ "$arch" == "aarch64" || "$arch" == "arm64" ]] && arch="arm64"

    # kubectl
    if ! command -v kubectl &>/dev/null; then
        local stable
        stable="$(curl -sL https://dl.k8s.io/release/stable.txt)"
        curl -sLO "https://dl.k8s.io/release/${stable}/bin/${OS,,}/${arch}/kubectl"
        chmod +x kubectl && sudo mv kubectl /usr/local/bin/
    fi

    # k9s
    if ! command -v k9s &>/dev/null; then
        local k9s_ver os_name
        k9s_ver=$(curl -sL https://api.github.com/repos/derailed/k9s/releases/latest | jq -r .tag_name)
        [[ "$OS" == "Darwin" ]] && os_name="Darwin" || os_name="Linux"
        curl -sL "https://github.com/derailed/k9s/releases/download/${k9s_ver}/k9s_${os_name}_${arch}.tar.gz" | tar xz -C /tmp k9s
        sudo mv /tmp/k9s /usr/local/bin/
    fi

    # helm
    if ! command -v helm &>/dev/null; then
        curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    fi

    ok "K8s tools installed (kubectl, k9s, helm)"
}

# ── Default shell ────────────────────────────────────────────────
set_default_shell() {
    if [[ "$SHELL" != *"zsh"* ]]; then
        info "Changing default shell to zsh..."
        local zsh_path
        zsh_path="$(which zsh)"
        grep -qxF "$zsh_path" /etc/shells || echo "$zsh_path" | sudo tee -a /etc/shells
        sudo chsh -s "$zsh_path" "$(whoami)" 2>/dev/null || chsh -s "$zsh_path"
        ok "Default shell → zsh"
    else
        ok "Already using zsh"
    fi
}

# ── Main ─────────────────────────────────────────────────────────
main() {
    echo ""
    echo "  ╔═══════════════════════════════════╗"
    echo "  ║   Steve Han's Dotfiles Installer  ║"
    echo "  ╚═══════════════════════════════════╝"
    echo ""

    case "$OS" in
        Darwin) info "Detected macOS"; install_packages_macos ;;
        Linux)  info "Detected Linux";  install_packages_ubuntu ;;
        *)      echo "Unsupported OS: $OS"; exit 1 ;;
    esac

    install_starship
    setup_zsh
    setup_tmux
    setup_nvim
    setup_ghostty
    setup_git
    setup_starship_config

    if [[ "${1:-}" == "--k8s" ]] || [[ "${1:-}" == "--all" ]]; then
        install_k8s_tools
    else
        info "Skip k8s tools (use --k8s to include)"
    fi

    set_default_shell

    echo ""
    ok "Done! Open a new terminal or: exec zsh"
    echo ""
}

main "$@"
