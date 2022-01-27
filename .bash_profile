source ~/git-completion.bash

export BASH_SILENCE_DEPRECATION_WARNING=1
export LSCOLORS=GxBxCxDxFxegedabagaced

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

case "$TERM" in
  xterm-color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
  else
    color_prompt=
  fi
fi

export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[01;34m\]\w$(parse_git_branch)\[\033[00m\]\$ '

HISTSIZE=5000
HISTFILESIZE=10000
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
HISTCONTROL=ignorespace:ignoredups

alias ls='ls -GFhla'

# heroku autocomplete setup
HEROKU_AC_BASH_SETUP_PATH=/Users/tesshead/Library/Caches/heroku/autocomplete/bash_setup && test -f $HEROKU_AC_BASH_SETUP_PATH && source $HEROKU_AC_BASH_SETUP_PATH;
