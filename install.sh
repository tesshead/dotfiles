#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo
echo "✨ Preparing the cauldron..."
echo

# ---------- Homebrew ----------
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Homebrew isn't installed."
  echo "Install Homebrew first, then rerun this script:"
  echo
  echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  exit 1
fi

echo "🍺 Installing packages..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# ---------- Directories ----------
echo "🪄 Creating personal directories..."
mkdir -p \
  "$HOME/cauldron" \
  "$HOME/.local/bin" \
  "$HOME/.vim/colors" \
  "$HOME/.vim/autoload" \
  "$HOME/.vim/undodir"

# ---------- Dotfiles ----------
link_file() {
  local source="$1"
  local target="$2"

  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    echo "✓ $target already linked"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    local backup="${target}.backup"
    local n=1

    while [[ -e "$backup" || -L "$backup" ]]; do
      backup="${target}.backup.$n"
      ((n++))
    done

    echo "📦 Backing up existing $target → $backup"
    mv "$target" "$backup"
  fi

  ln -s "$source" "$target"
}

echo "🔮 Linking dotfiles..."
link_file "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"
link_file "$DOTFILES_DIR/vim/colors/vividchalk.vim" "$HOME/.vim/colors/vividchalk.vim"
link_file "$DOTFILES_DIR/bin/look-for" "$HOME/.local/bin/look-for"

# ---------- vim-plug ----------
echo "💜 Restoring Vim to its rightful glory..."
if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

vim +'PlugInstall --sync' +qa

# ---------- Git LFS ----------
git lfs install

# ---------- GitHub SSH ----------
if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
  echo
  echo "🔑 No personal SSH key found."
  read -r -p "Create one now? [Y/n] " response

  if [[ ! "$response" =~ ^[Nn]$ ]]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"

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
    echo "🔑 Public key copied to your clipboard."
    echo "   Add it to GitHub → Settings → SSH and GPG keys."
  fi
fi

echo
echo "✨ Your Mac has been sufficiently enchanted."
echo "🪄 Personal code lives in ~/cauldron."
echo
echo "Open a fresh terminal when you're ready."
