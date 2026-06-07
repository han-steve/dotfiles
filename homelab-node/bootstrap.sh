#!/usr/bin/env bash
# Homelab node terminal bootstrap.
#
# This entrypoint is intentionally separate from the macOS bootstrap and the
# older Ubuntu bootstrap. It only manages per-user shell config for k3s worker
# nodes; Ansible handles privileged package installs and shell changes.

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: homelab-node/bootstrap.sh [--copy|--link] [--no-warm]

Options:
  --copy     Copy zsh/starship config into the home directory.
  --link     Symlink zsh/starship config back to this dotfiles checkout.
  --no-warm  Skip the first zsh startup used to warm plugin caches.

Environment:
  DOTFILES_TARGET_HOME   Home directory to configure. Defaults to $HOME.
  DOTFILES_INSTALL_MODE  copy or link. Defaults to link.
  DOTFILES_WARM_ZSH_CACHE 0 disables cache warming.
EOF
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target_home="${DOTFILES_TARGET_HOME:-${HOME}}"
install_mode="${DOTFILES_INSTALL_MODE:-link}"
warm_zsh_cache="${DOTFILES_WARM_ZSH_CACHE:-1}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --copy)
      install_mode="copy"
      ;;
    --link)
      install_mode="link"
      ;;
    --no-warm)
      warm_zsh_cache="0"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

case "${install_mode}" in
  copy|link) ;;
  *)
    echo "ERROR: DOTFILES_INSTALL_MODE must be copy or link." >&2
    exit 1
    ;;
esac

install_config() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "${dest}")"
  if [[ "${install_mode}" == "copy" ]]; then
    cp "${src}" "${dest}"
  else
    ln -sfn "${src}" "${dest}"
  fi
}

mkdir -p \
  "${target_home}/.cache/zsh" \
  "${target_home}/.config" \
  "${target_home}/.local/share/zinit"

if command -v git >/dev/null 2>&1; then
  zinit_home="${target_home}/.local/share/zinit/zinit.git"
  if [[ -d "${zinit_home}/.git" ]]; then
    git -C "${zinit_home}" pull --ff-only >/dev/null
  else
    git clone https://github.com/zdharma-continuum/zinit.git "${zinit_home}"
  fi
fi

install_config "${script_dir}/zshrc" "${target_home}/.zshrc"
install_config "${script_dir}/starship.toml" "${target_home}/.config/starship.toml"

if [[ "${warm_zsh_cache}" != "0" ]] && command -v zsh >/dev/null 2>&1; then
  HOME="${target_home}" zsh -ic true >/dev/null 2>&1 || true
fi

echo "Homelab node dotfiles installed with ${install_mode} mode."
