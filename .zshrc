# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# Fig pre block. Keep at the top of this file.
# 

export PATH="/usr/local/opt/python@3.11/bin:$PATH"
CONF="$HOME/.config"

# tmux source $CONF/tmux/tmux.conf




# PLUGINS 

# VI MODE
#source $CONF/zsh/zsh-vim.zsh


# RELOAD ALL SYMLINKS
setopt extendedglob
alias reload_sym="find $HOME -maxdepth 1 -type l -delete; ln -s $CONF/.* $HOME"




# ALIASES

# PROFILE
alias vyabai="nvim $CONF/.yabairc"
alias vskhd="nvim $CONF/skhd/skhdrc"
alias reload_wm="brew services restart yabai; brew services restart skhd"
alias vzsh="nvim $CONF/.zshrc"
alias valacritty="nvim $CONF/.config/alacritty/alacritty.yml"
alias conf="cd $CONF"
alias reload="source $CONF/.zshrc && echo 'zsh profile reloaded correctly' || echo 'Syntax error, could not import the file'";
alias todo="v ~/Documents/TODO.md"

alias vkarabiner="nvim $CONF/karabiner/layers.edn"
alias karabiner_make="(cd $CONF/karabiner && make)"

# JAVA
alias java8='export PATH="/usr/local/opt/openjdk@8/bin:$PATH" && java --version'
alias java11='export PATH="/usr/local/opt/openjdk@11/bin:$PATH" && java --version'
alias java17='export PATH="/usr/local/opt/openjdk@17/bin:$PATH" && java --version'
alias java18='export PATH="/usr/local/opt/openjdk@18/bin:$PATH" && java --version'
alias javav='java --version'


# DIRECTORIES
alias aws="cd ~/Documents/Bridgestars/aws && ls"
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
eval "$(zoxide init zsh)"








autoload -Uz compinit && compinit
zstyle ':completion:\*' matcher-list 'm:{a-z}={A-Za-z}'


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/theo/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/theo/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/theo/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/theo/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Fig post block. Keep at the bottom of this file.
# ##  POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
# eval "$(starship init zsh)"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
