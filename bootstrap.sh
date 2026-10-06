#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/tesshead/dotfiles.git"
DEST="$HOME/cauldron/dotfiles"

echo
echo "✨ Welcome to the Mac enchanting ceremony."
echo

# ---------- Xcode Command Line Tools ----------
if ! xcode-select -p >/dev/null 2>&1; then
  echo "🛠 Installing Xcode Command Line Tools..."
  xcode-select --install
  echo
  echo "Finish that installation, then rerun this script."
  exit 0
fi

# ---------- Homebrew ----------
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# ---------- GitHub SSH ----------
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
  echo
  echo "🔑 Creating this Mac's GitHub SSH key..."
  read -r -p "Email for SSH key: " ssh_email

  ssh-keygen -t ed25519 -C "$ssh_email" -f "$HOME/.ssh/id_ed25519"
  ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519"

  cat >> "$HOME/.ssh/config" <<'SSHCONFIG'
Host github.com
  HostName github.com
  User git
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
SSHCONFIG

  chmod 600 "$HOME/.ssh/config"
  pbcopy < "$HOME/.ssh/id_ed25519.pub"

  echo
  echo "🔑 Your public key is on the clipboard."
  echo "Add it to GitHub → Settings → SSH and GPG keys."
  echo
  read -r -p "Press Enter once GitHub has the key..."
fi

ssh -T git@github.com 2>&1 || true

# ---------- Dotfiles ----------
mkdir -p "$HOME/cauldron"

if [[ ! -d "$DEST/.git" ]]; then
  echo
  echo "🪄 Summoning dotfiles..."
  git clone git@github.com:tesshead/dotfiles.git "$DEST"
else
  echo "🪄 Dotfiles already present."
fi

echo
echo "✨ Handing things over to the installer..."
exec "$DEST/install.sh"
