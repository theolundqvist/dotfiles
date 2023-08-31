# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
zmodload zsh/zprof

# Fig pre block. Keep at the top of this file.

export PATH="/usr/local/opt/python@3.11/bin:$PATH"
CONF="$HOME/dotfiles"

export EDITOR="nvim"



# PLUGINS 

# VI MODE
#source $CONF/zsh/zsh-vim.zsh
setInitialKeyRepeat ()
{ 
defaults write -g InitialKeyRepeat -int $1 # normal minimum is 15 (225 ms)
}
setKeyRepeat ()
{
defaults write -g KeyRepeat -int $1 # normal minimum is 2 (30 ms)
}

# RELOAD ALL SYMLINKS
setopt extendedglob
alias reload_sym="find $HOME -maxdepth 1 -type l -delete; ln -s $CONF/.* $HOME"

# TMUX
alias tn='tmux new -s `basename $PWD`'
alias ta='tmux attach'
alias td='tmux detach'
# ~/.tmux/plugins
export PATH=$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
# ~/.config/tmux/plugins
export PATH=$CONF/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
export FZF_TMUX_OPTS="-p 55%,60%"

# Use vim as the default editor
# But still use emacs-style zsh bindings
bindkey -e
# vi bindings in terminal
#source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# ALIASES

# COPY PASTE
alias cpc="pbcopy < "
alias pc="pbpaste > "
# PROFILE
alias vyabai="nvim $CONF/.yabairc"
alias vskhd="nvim $CONF/skhd/skhdrc"
# alias reload_wm="brew services restart yabai; brew services restart skhd"
alias vzsh="nvim $CONF/.zshrc"
alias vconf="nvim $CONF/Makefile"
alias confi="(cd $CONF && make install)"
alias valacritty="nvim $CONF/alacritty/alacritty.yml"
alias conf="cd $CONF"
alias reload="source $CONF/.zshrc && echo 'zsh profile reloaded correctly' || echo 'Syntax error, could not import the file'";
alias todo="v ~/Documents/TODO.md"

alias vkarabiner="nvim $CONF/karabiner/layers.edn"
alias karabiner_make="(cd $CONF/karabiner && make)"

# JAVA
# alias java8='export PATH="/usr/local/opt/openjdk@8/bin:$PATH" && java --version'

# alias java11='export PATH="/opt/homebrew/openjdk@11/bin:$PATH" && java --version && export CPPFLAGS="-I/opt/homebrew/opt/openjdk@11/include"'
# alias java17='export PATH="/opt/homebrew/openjdk@17/bin:$PATH" && java --version && export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"'
# OBS: May need to run  
# sudo ln -sfn /opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
# and
# sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
#
#
#
# alias java18='export PATH="/usr/local/opt/openjdk@18/bin:$PATH" && java --version'
alias javav='java --version'


# DIRECTORIES
#alias aws="cd ~/Documents/Bridgestars/aws && ls"
alias doc="cd ~/Documents && doc"
alias cs="cd ~/Documents/courses/current && ls"
alias bridge="cd ~/Documents/Bridgestars/lib"
alias projects="cd ~/Documents/projekt"
alias finder="open -a finder"


# ABBREVIATIONS
alias v="nvim"
alias c="clear"
alias e="exit"

# TOOLS
alias idea='open -na "IntelliJ IDEA.app" --args "$@"'
alias zip.="zip -r Archive.zip . -x '**/.DS_Store' -x '__MACOSX'"
alias pip3="python3 -m pip"

# UTIL
alias tree="tree -I node_modules"
alias update="brew update && brew upgrade && mas upgrade"
alias week="date +%V"

# GIT
alias gweb="gh repo view --web"
alias gpull="git pull"
alias gpush="git push"
alias gpushupstream="git push --set-upstream origin"
alias gfetch="git fetch"
alias gf="git fetch"
alias gs="git status"
alias gbranch="git branch"
alias gba="gbranch -a"
alias gb="gbranch"
alias gco="git checkout"
alias gm="git merge"
alias vig="v .gitignore"
alias m="make"

alias greloadgitignore="git rm -r --cached . && git add . && gs"

alias gcommitall="git commit -am"
alias gcommit="git commit -m"
alias gc="gcommit"
alias gca="gcommitall"

alias ga="git add"
alias ga.="git add . && git status"
alias grh="git reset --hard && git status"
alias gr="git root"



# CD

## a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'

alias ls.="ls -d .*"
alias ls="ls -G"

# grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# `git` wrapper:
#
#     - `git` with no arguments = `git status`; run `git help` to show what
#       vanilla `git` without arguments would normally show.
#     - `git root` = `cd` to repo root.
#    	
#     - `ROOT=$(git root)` = no args and stdout is not a tty; prints the root.
#     - `git root ARG...` = evals `ARG...` from the root (eg. `git root ls`).
#     - `git ARG...` = behaves just like normal `git` command.
#
function git() {
  if [ $# -eq 0 ]; then
    command git status
  elif [ "$1" = root ]; then
    shift
    local ROOT
    if [ "$(command git rev-parse --is-inside-git-dir 2> /dev/null)" = true ]; then
      if [ "$(command git rev-parse --is-bare-repository)" = true ]; then
        ROOT="$(command git rev-parse --absolute-git-dir)"
      else
        # Note: This is a good-enough, rough heuristic, which ignores
        # the possibility that GIT_DIR might be outside of the worktree;
        # see:
        # https://stackoverflow.com/a/38852055/2103996
        ROOT="$(command git rev-parse --git-dir)/.."
      fi
    else
      # Git 2.13.0 and above:
      ROOT="$(command git rev-parse --show-superproject-working-tree 2> /dev/null)"
      if [ -z "$ROOT" ]; then
        ROOT="$(command git rev-parse --show-toplevel 2> /dev/null)"
      fi
    fi
    if [ -z "$ROOT" ]; then
      ROOT="$PWD"
    fi
    if [ $# -eq 0 ]; then
      if [ -t 1 ]; then
        cd "$ROOT"
      else
        echo "$ROOT"
      fi
    else
      (cd "$ROOT" && eval "$@")
    fi
  else
    command git "$@"
  fi
}










# zoxide
if command -v zoxide &> /dev/null
then
  eval "$(zoxide init zsh)"
else
  echo "zoxide could not be found"
fi






autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C
zstyle ':completion:\*' matcher-list 'm:{a-z}={A-Za-z}'



# Fig post block. Keep at the bottom of this file.
# ##  POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
# eval "$(starship init zsh)"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

function conda-load()
{
  echo "sourcing anaconda"
  export PATH="/opt/homebrew/anaconda3/bin:$PATH"
  source "$CONF/zsh/conda-setup.sh"
}

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"

eval export PATH="/Users/theo/.jenv/shims:${PATH}"
export JENV_SHELL=zsh
export JENV_LOADED=1
unset JAVA_HOME
unset JDK_HOME
source '/opt/homebrew/Cellar/jenv/0.5.6/libexec/libexec/../completions/jenv.zsh'
jenv rehash 2>/dev/null
jenv refresh-plugins
jenv() {
  type typeset &> /dev/null && typeset command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  enable-plugin|rehash|shell|shell-options)
    eval `jenv "sh-$command" "$@"`;;
  *)
    command jenv "$command" "$@";;
  esac
}
