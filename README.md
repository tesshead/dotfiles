# ✨ Tess's Mac Setup

Personal macOS setup and dotfiles.

Designed for a fresh Apple Silicon Mac using zsh + Homebrew.

## Fresh Mac Setup

### 1. Do the human stuff first

- Sign into Apple/iCloud
- Sign into 1Password
- Make sure AirDrop / Messages / iCloud are behaving

### 2. Download the bootstrap script

Open Terminal and run:

```bash
curl -fsSLO https://raw.githubusercontent.com/tesshead/dotfiles/main/bootstrap.sh
chmod +x bootstrap.sh
./bootstrap.sh
```

The bootstrap will:

- install Xcode Command Line Tools if needed
- install Homebrew if needed
- create a fresh Ed25519 SSH key
- copy the public key to the clipboard
- pause while you add the key to GitHub
- create `~/cauldron`
- clone this repo to `~/cauldron/dotfiles`
- run `install.sh`

If Xcode Command Line Tools need to install, rerun `./bootstrap.sh` after they finish.

## What gets installed

CLI tools:

- mise
- GitHub CLI
- fzf
- ripgrep
- git-delta
- figlet
- git-lfs
- Vim

Apps:

- iTerm2
- 1Password
- Sequel Ace

Dotfiles:

- zsh
- Git
- Vim + Vividchalk
- `look-for`

## Whimsy

Terminal prompt:

- `~/cauldron` → 🪄
- everywhere else → ✨

## After setup

Open a fresh terminal.

Authenticate GitHub CLI if needed:

```bash
gh auth login
```

Verify SSH:

```bash
ssh -T git@github.com
```

Check Vim plugins with `:PlugStatus`.

## Personal code

Personal projects live in `~/cauldron`.

Dotfiles live in `~/cauldron/dotfiles`.

## Re-running setup

```bash
cd ~/cauldron/dotfiles
./install.sh
```

Existing non-symlinked dotfiles are backed up rather than deleted.

---

✨ Your Mac has been sufficiently enchanted.
