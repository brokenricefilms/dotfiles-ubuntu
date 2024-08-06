if command -v tmux &>/dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux attach || tmux new-session && exit
fi

HISTCONTROL=ignoreboth
HISTSIZE=
HISTFILESIZE=
shopt -s histappend
shopt -s checkwinsize
HISTSIZE=9999999999999
HISTFILESIZE=9999999999999

bind "set completion-ignore-case on"

set -o vi
stty time 0

export PATH=$PATH:/home/master/go/bin

alias d="aria2c -x 16 -s 16 --seed-time=0 $args"
alias dow="cd ~/Downloads"
alias reload="source ~/.bashrc;tmux source ~/.tmux.conf"
alias fd="fdfind"
alias q="exit"
alias ls="eza -al --icons=auto"
alias l="eza -al --icons=auto"
alias la="eza -a --icons=auto"
alias batcat="bat"
alias ..="cd .."
alias doc="cd ~/Documents"
alias ins="sudo apt install"
alias re="sudo apt remove"
alias p="git push"
alias s="git status --short --branch"
alias v="nvim ."
alias neofetch="\fastfetch -c archey"
alias fastfetch="fastfetch -c archey"
alias clear="clear -x"
alias h="cat ~/.bash_history | fzf | bash"

function update() {
    cp ~/.bashrc ~/repos/brokenricefilms/dotfiles-ubuntu/
    cp ~/.tmux.conf ~/repos/brokenricefilms/dotfiles-ubuntu/
    cp ~/.gitconfig ~/repos/brokenricefilms/dotfiles-ubuntu/
    cp -r ~/.config/nvim/ ~/repos/brokenricefilms/dotfiles-ubuntu/
    cd ~/repos/brokenricefilms/dotfiles-ubuntu/
    git add -A
    git commit -m "auto commit"
    git push
    cd -
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt autoremove -y
}

function gitAutoCommit() {
  git add -A
  git commit -m 'auto commit'
  git push
}
alias aa="gitAutoCommit"

function gitAddAll() {
    git add -A
    git commit
    git push
}
alias a="gitAddAll"

function fzfEditFile() {
  if [ -z "$1" ]; then
    FILE=$(fd --hidden --type file . | fzf --preview 'bat --theme=GitHub --color=always --style=numbers --line-range=:501 {}' &)

    if [ -n "$FILE" ]; then
      nvim "$FILE"
    fi
  else
    nvim "$1"
  fi
}
alias e="fzfEditFile"
alias e.="nvim ."
alias ee="cd $HOME; fzfEditFile"

function fzfChangeDirectory() {
  DIR=$1

  fzfDir() {
    DIR=$(fd --hidden --type directory . | fzf --preview $'echo {} | tr -d \'()\' | awk \'{printf "%s ",  $2} {print  $1}\' | xargs -r exa --long --all --icons --color=never' &)
    cd "$DIR"
    ls
  }

  if [ -z "$1" ]; then
    if [[ -n $DIR ]]; then
      cd $DIR &>/dev/null
      ERROR=$?

      if [[ ERROR -eq 1 ]]; then
        echo "\"$1\" directory does not exist"
        fzfDir
      fi
    else
      fzfDir
    fi
  else
    mkdir -p "$1"
    cd "$1"
  fi
}
alias c="fzfChangeDirectory"
alias cc="cd $HOME; fzfChangeDirectory"

function tmuxKillAllUnnameSession() {
  tmux ls | awk '{print $1}' | grep -o '[0-9]\+' >/tmp/killAllUnnameTmuxSessionOutput.sh
  sed -i 's/^/tmux kill-session -t /' /tmp/killAllUnnameTmuxSessionOutput.sh
  chmod +x /tmp/killAllUnnameTmuxSessionOutput.sh
  /tmp/killAllUnnameTmuxSessionOutput.sh
}

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PNPM_HOME="/home/master/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

eval "$(starship init bash)"
