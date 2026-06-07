# Homelab Node Dotfiles

This entrypoint configures the per-user terminal experience for Ubuntu k3s
worker nodes. It is separate from the macOS bootstrap and the older Ubuntu
desktop bootstrap.

Ansible should call:

```bash
homelab-node/bootstrap.sh --link
```

The script installs:

- `~/.zshrc` from `homelab-node/zshrc`
- `~/.config/starship.toml` from `homelab-node/starship.toml`
- zinit under `~/.local/share/zinit/zinit.git`

Privileged package installs, Starship binary installation, and login-shell
changes belong in the homelab Ansible role.
