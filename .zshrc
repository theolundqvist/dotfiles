# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
zmodload zsh/zprof

# Fig pre block. Keep at the top of this file.
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Users/theo/.cargo/bin:$PATH"
export DYLD_LIBRARY_PATH="/opt/homebrew/lib:$DYLD_LIBRARY_PATH"

export PATH="/usr/local/opt/python@3.11/bin:$PATH"
CONF="$HOME/dotfiles"

renv() {
  local env_file=${1:-".env"}
  if [[ -f "$env_file" ]]; then
    set -a # automatically export all variables
    source "$env_file"
    echo "Environment variables from $env_file have been loaded and exported."
    set +a # disable auto-export
  else
    echo "Error: $env_file not found."
  fi
}

# Source and export environment variables from .env file
if [ -f "$CONF/.env" ]; then
  set -a # automatically export all variables
  source "$CONF/.env"
  set +a # disable auto-export
fi

export XDG_CONFIG_HOME="$HOME/.config"

export EDITOR="nvim"
export HOMEBREW_NO_AUTO_UPDATE=1

alias please="sudo"

FDM_MONO="$HOME/Documents/fdm/TownSquare"
dev_ingest() { ( cd $FDM_MONO/fdm_scrap_chef && ENVIRONMENT=dev POSTGRES_HOST=localhost POSTGRES_PORT=5433 uv run python -m scrap_chef_ingest $1 all ) }
dev_upgrade() { ( cd $FDM_MONO/fdm_scrap_chef/backend/tenant_db && POSTGRES_HOST=localhost POSTGRES_PORT=5433 uv run alembic -x tenant=$1 upgrade head ) }
dev_downgrade() { ( cd $FDM_MONO/fdm_scrap_chef/backend/tenant_db && POSTGRES_HOST=localhost POSTGRES_PORT=5433 uv run alembic -x tenant=$1 downgrade $2 ) }


# imports
source $CONF/zsh/bw.zsh

# load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# zinit plugins
source /opt/homebrew/opt/zinit/zinit.zsh
# zsh-fzf-history-search
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search

# history
setopt BANG_HIST        # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY # Write the history file in the ':start:elapsed;command' format.
# setopt SHARE_HISTORY          # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion.

# PLUGINS

#DOTNET
export DOTNET_ROOT="/opt/homebrew/opt/dotnet@6/libexec"
export PATH="/opt/homebrew/opt/dotnet@6/bin:$PATH"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# VI MODE
#source $CONF/zsh/zsh-vim.zsh
setInitialKeyRepeat() {
  defaults write -g InitialKeyRepeat -int $1 # normal minimum is 15 (225 ms)
}
setKeyRepeat() {
  defaults write -g KeyRepeat -int $1 # normal minimum is 2 (30 ms)
}

# RELOAD ALL SYMLINKS
setopt extendedglob
alias reload_sym="find $HOME -maxdepth 1 -type l -delete; ln -s $CONF/.* $HOME"

# TMUX
function tn() {
  if [ -z "$1" ]; then
    tmux new -s $(basename $PWD)
  else
    tmux new -d -s $1
    tmux switch-client -t $1
  fi
}
alias ta='tmux attach'
alias td='tmux detach'
function w {
  cd "$(walk "$@")"
}
# ~/.tmux/plugins
export PATH=$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
# ~/.config/tmux/plugins
export PATH=$CONF/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
export FZF_TMUX_OPTS="-p 55%,60%"

# OPEN TERMINAL BUFFER IN VIM
function vt() {
  file="$HOME/.tmux.temp.sh"
  rm -f $file
  tmux capture-pane -pS -1000 >$file
  tmux new-window -n:edit "nvim '+ normal gg } k $' $file"
}

function nb() {
  # Ensure the scratch directory exists
  if [ ! -d "scratch" ]; then
    mkdir "scratch"
  fi

  # Create or update a symbolic link in the scratch directory
  ln -sf "$CONF/zsh/new-notebook.py" "scratch/new-notebook.py"

  # Run the symlinked Python script
  python3 "scratch/new-notebook.py"
}

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
alias vtmux="nvim $CONF/tmux/tmux.conf"
alias vconf="nvim $CONF/Makefile"
alias vinstall="nvim $CONF/Makefile"
alias confi="(cd $CONF && make install)"
alias valacritty="nvim $CONF/alacritty/alacritty.toml"
alias conf="cd $CONF"
alias reload="source $CONF/.zshrc && echo 'zsh profile reloaded correctly' || echo 'Error, could not import the file'"
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

function mkcd() {
  mkdir -p "$1" && cd "$1"
}
function count() {
  ls -l "$@" | wc -l
}
function mkinit() {
  dir="${1:-$PWD}"
  echo
  echo "🔨 Creating __init__.py in $dir"
  echo
  uvx mkinit "${dir}" || return
  echo 
  response=""
  read "response?Do you want to write this file to ${dir}? [Y/n] "
  echo
  if [[ "$response" =~ ^[Yy]$ || -z "$response" ]]; then
    uvx mkinit "${dir}" -w || (echo "Failed to write __init__.py" && return 1)
    echo "✅ Wrote $dir/__init__.py"
  fi
}

# ABBREVIATIONS
alias v="nvim"
alias c="clear"
alias sa="sail artisan"
alias e="exit"

# TOOLS
alias idea='open -na "IntelliJ IDEA.app" --args "$@"'
alias zip.="zip -r Archive.zip . -x '**/.DS_Store' -x '__MACOSX'"
alias pip3="python3 -m pip"
#alias python="/opt/homebrew/bin/python3"
alias tree="tree -I node_modules -C"
alias update="brew update && brew upgrade && mas upgrade"
alias week="date +%V"

# GIT
alias g="git"
alias gweb="gh repo view --web"
alias gpull="git pull"
alias gpl="git pull"
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
alias gremoveuntracked='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -d'

alias gcommitall="git commit -am"
alias gcommit="git commit -m"
alias gc="gcommit"
alias genz="~/dotfiles/zsh/genz-commit.sh"
alias gca="gcommitall"

alias ga="git add"
alias ga.="git add . && git status"
alias grh="git reset --hard && git status"
alias gr="git root"

# CD

## a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

alias ls.="ls -d .*"
# alias ls="ls -G"
if type lsd >/dev/null; then
  alias lsd='lsd --icon never'
  alias ls='lsd'
  alias la='lsd -la'
  #TODO fix this alias
  alias lt='lsd -glT'
  alias ll='lsd -l'
  alias l='ll'
fi

# grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='diff --color=auto'

# ngrok
alias port_forward='ngrok http --domain=evidently-working-gobbler.ngrok-free.app'

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
    if [ "$(command git rev-parse --is-inside-git-dir 2>/dev/null)" = true ]; then
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
      ROOT="$(command git rev-parse --show-superproject-working-tree 2>/dev/null)"
      if [ -z "$ROOT" ]; then
        ROOT="$(command git rev-parse --show-toplevel 2>/dev/null)"
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
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
else
  echo "zoxide could not be found"
fi

# autoload -Uz compinit
# for dump in ~/.zcompdump(N.mh+24); do
#   compinit
# done
# compinit -C
# zstyle ':completion:\*' matcher-list 'm:{a-z}={A-Za-z}'

# forces zsh to realize new commands
zstyle ':completion:*' completer _oldlist _expand _complete _match _ignored _approximate

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# rehash if command not found (possibly recently installed)
zstyle ':completion:*' rehash true

# menu if nb items > 2
zstyle ':completion:*' menu select=2

# Fig post block. Keep at the bottom of this file.
# ##  POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
# eval "$(starship init zsh)"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

function load-conda() {
  echo "sourcing anaconda"
  # export PATH="/opt/homebrew/anaconda3/bin:$PATH"  # commented out by conda initialize
  source "$CONF/zsh/conda-setup.sh"
}

# ruby env
# eval "$(rbenv init - zsh)"

# go
export GOPATH="$HOME/go"
PATH="$GOPATH/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/theo/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH="$HOME/.composer/vendor/bin:$PATH"

# pnpm endexport PATH="/opt/homebrew/opt/node@18/bin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'

### GENERAL FUNCTIONS

# mnemonic: [K]ill [P]rocess
kp() {
  local pid=$(ps -ef | sed 1d | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:process]'" | awk '{print $2}')

  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
    kp
  fi
}

# mnemonic: [K]ill [S]erver
ks() {
  local pid=$(lsof -Pwni | sed 1d | grep -e LISTEN -e '\*:' | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:tcp]'" | awk '{print $2}')

  if [ "x$pid" != "x" ]; then
    echo $pid | xargs kill -${1:-9}
    ks
  fi
}

#export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
#export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export PATH=$PATH:$HOME/.maestro/bin

# better ls colors
LS_COLORS='*.7z=38;5;40:*.WARC=38;5;40:*.a=38;5;40:*.arj=38;5;40:*.bz2=38;5;40:*.cpio=38;5;40:*.gz=38;5;40:*.lrz=38;5;40:*.lz=38;5;40:*.lzma=38;5;40:*.lzo=38;5;40:*.rar=38;5;40:*.s7z=38;5;40:*.sz=38;5;40:*.tar=38;5;40:*.tbz=38;5;40:*.tgz=38;5;40:*.warc=38;5;40:*.xz=38;5;40:*.z=38;5;40:*.zip=38;5;40:*.zipx=38;5;40:*.zoo=38;5;40:*.zpaq=38;5;40:*.zst=38;5;40:*.zstd=38;5;40:*.zz=38;5;40:*@.service=38;5;45:*AUTHORS=38;5;220;1:*CHANGES=38;5;220;1:*CONTRIBUTORS=38;5;220;1:*COPYING=38;5;220;1:*COPYRIGHT=38;5;220;1:*CodeResources=38;5;239:*Dockerfile=38;5;155:*HISTORY=38;5;220;1:*INSTALL=38;5;220;1:*LICENSE=38;5;220;1:*LS_COLORS=48;5;89;38;5;197;1;3;4;7:*MANIFEST=38;5;243:*Makefile=38;5;155:*NOTICE=38;5;220;1:*PATENTS=38;5;220;1:*PkgInfo=38;5;239:*README=38;5;220;1:*README.md=38;5;220;1:*README.rst=38;5;220;1:*VERSION=38;5;220;1:*authorized_keys=1:*cfg=1:*conf=1:*config=1:*core=38;5;241:*id_dsa=38;5;192;3:*id_ecdsa=38;5;192;3:*id_ed25519=38;5;192;3:*id_rsa=38;5;192;3:*known_hosts=1:*lock=38;5;248:*lockfile=38;5;248:*pm_to_blib=38;5;240:*rc=1:*.1p=38;5;7:*.32x=38;5;213:*.3g2=38;5;115:*.3ga=38;5;137;1:*.3gp=38;5;115:*.3p=38;5;7:*.82p=38;5;121:*.83p=38;5;121:*.8eu=38;5;121:*.8xe=38;5;121:*.8xp=38;5;121:*.A64=38;5;213:*.BAT=38;5;172:*.BUP=38;5;241:*.C=38;5;81:*.CFUserTextEncoding=38;5;239:*.DS_Store=38;5;239:*.F=38;5;81:*.F03=38;5;81:*.F08=38;5;81:*.F90=38;5;81:*.F95=38;5;81:*.H=38;5;110:*.IFO=38;5;114:*.JPG=38;5;97:*.M=38;5;110:*.MOV=38;5;114:*.PDF=38;5;141:*.PFA=38;5;66:*.PL=38;5;160:*.R=38;5;49:*.RData=38;5;178:*.Rproj=38;5;11:*.S=38;5;110:*.S3M=38;5;137;1:*.SKIP=38;5;244:*.TIFF=38;5;97:*.VOB=38;5;115;1:*.a00=38;5;213:*.a52=38;5;213:*.a64=38;5;213:*.a78=38;5;213:*.aac=38;5;137;1:*.accdb=38;5;60:*.accde=38;5;60:*.accdr=38;5;60:*.accdt=38;5;60:*.adf=38;5;213:*.adoc=38;5;184:*.afm=38;5;66:*.agda=38;5;81:*.agdai=38;5;110:*.ahk=38;5;41:*.ai=38;5;99:*.aiff=38;5;136;1:*.alac=38;5;136;1:*.allow=38;5;112:*.am=38;5;242:*.amr=38;5;137;1:*.ape=38;5;136;1:*.apk=38;5;215:*.application=38;5;116:*.aria2=38;5;241:*.asc=38;5;192;3:*.asciidoc=38;5;184:*.asf=38;5;115:*.asm=38;5;81:*.ass=38;5;117:*.atr=38;5;213:*.au=38;5;137;1:*.automount=38;5;45:*.avi=38;5;114:*.awk=38;5;172:*.bak=38;5;241:*.bash=38;5;172:*.bash_login=1:*.bash_logout=1:*.bash_profile=1:*.bat=38;5;172:*.bfe=38;5;192;3:*.bib=38;5;178:*.bin=38;5;124:*.bmp=38;5;97:*.bsp=38;5;215:*.c=38;5;81:*.c++=38;5;81:*.cab=38;5;215:*.caf=38;5;137;1:*.cap=38;5;29:*.car=38;5;57:*.cbr=38;5;141:*.cbz=38;5;141:*.cc=38;5;81:*.cda=38;5;136;1:*.cdi=38;5;213:*.cdr=38;5;97:*.chm=38;5;141:*.cl=38;5;81:*.clj=38;5;41:*.cljc=38;5;41:*.cljs=38;5;41:*.cljw=38;5;41:*.cnc=38;5;7:*.coffee=38;5;074;1:*.cp=38;5;81:*.cpp=38;5;81:*.cr=38;5;81:*.crx=38;5;215:*.cs=38;5;81:*.css=38;5;125;1:*.csv=38;5;78:*.ctp=38;5;81:*.cue=38;5;116:*.cxx=38;5;81:*.dart=38;5;51:*.dat=38;5;137;1:*.db=38;5;60:*.deb=38;5;215:*.def=38;5;7:*.deny=38;5;196:*.description=38;5;116:*.device=38;5;45:*.dhall=38;5;178:*.dicom=38;5;97:*.diff=48;5;197;38;5;232:*.directory=38;5;116:*.divx=38;5;114:*.djvu=38;5;141:*.dll=38;5;241:*.dmg=38;5;215:*.dmp=38;5;29:*.doc=38;5;111:*.dockerignore=38;5;240:*.docm=38;5;111;4:*.docx=38;5;111:*.drw=38;5;99:*.dtd=38;5;178:*.dts=38;5;137;1:*.dump=38;5;241:*.dwg=38;5;216:*.dylib=38;5;241:*.ear=38;5;215:*.el=38;5;81:*.elc=38;5;241:*.eln=38;5;241:*.eml=38;5;125;1:*.enc=38;5;192;3:*.entitlements=1:*.epf=1:*.eps=38;5;99:*.epsf=38;5;99:*.epub=38;5;141:*.err=38;5;160;1:*.error=38;5;160;1:*.etx=38;5;184:*.ex=38;5;7:*.example=38;5;7:*.f=38;5;81:*.f03=38;5;81:*.f08=38;5;81:*.f4v=38;5;115:*.f90=38;5;81:*.f95=38;5;81:*.fcm=38;5;137;1:*.feature=38;5;7:*.flac=38;5;136;1:*.flif=38;5;97:*.flv=38;5;115:*.fm2=38;5;213:*.fmp12=38;5;60:*.fnt=38;5;66:*.fon=38;5;66:*.for=38;5;81:*.fp7=38;5;60:*.ftn=38;5;81:*.fvd=38;5;124:*.fxml=38;5;178:*.gb=38;5;213:*.gba=38;5;213:*.gbc=38;5;213:*.gbr=38;5;7:*.gel=38;5;213:*.gemspec=38;5;41:*.ger=38;5;7:*.gg=38;5;213:*.ggl=38;5;213:*.gif=38;5;97:*.git=38;5;197:*.gitattributes=38;5;240:*.gitignore=38;5;240:*.gitmodules=38;5;240:*.go=38;5;81:*.gp3=38;5;115:*.gp4=38;5;115:*.gpg=38;5;192;3:*.gs=38;5;81:*.h=38;5;110:*.h++=38;5;110:*.hi=38;5;110:*.hidden-color-scheme=1:*.hidden-tmTheme=1:*.hin=38;5;242:*.hpp=38;5;110:*.hs=38;5;81:*.htm=38;5;125;1:*.html=38;5;125;1:*.hxx=38;5;110:*.icns=38;5;97:*.ico=38;5;97:*.ics=38;5;7:*.ii=38;5;110:*.img=38;5;124:*.iml=38;5;166:*.in=38;5;242:*.info=38;5;184:*.ini=1:*.ipa=38;5;215:*.ipk=38;5;213:*.ipynb=38;5;41:*.iso=38;5;124:*.j64=38;5;213:*.jad=38;5;215:*.jar=38;5;215:*.java=38;5;074;1:*.jhtm=38;5;125;1:*.jpeg=38;5;97:*.jpg=38;5;97:*.js=38;5;074;1:*.jsm=38;5;074;1:*.json=38;5;178:*.jsonl=38;5;178:*.jsonnet=38;5;178:*.jsp=38;5;074;1:*.kak=38;5;172:*.key=38;5;166:*.lagda=38;5;81:*.lagda.md=38;5;81:*.lagda.rst=38;5;81:*.lagda.tex=38;5;81:*.last-run=1:*.less=38;5;125;1:*.lhs=38;5;81:*.libsonnet=38;5;142:*.lisp=38;5;81:*.lnk=38;5;39:*.localized=38;5;239:*.localstorage=38;5;60:*.log=38;5;190:*.lua=38;5;81:*.m=38;5;110:*.m2v=38;5;114:*.m3u=38;5;116:*.m3u8=38;5;116:*.m4=38;5;242:*.m4a=38;5;137;1:*.m4v=38;5;114:*.map=38;5;7:*.markdown=38;5;184:*.md=38;5;184:*.md5=38;5;116:*.mdb=38;5;60:*.mde=38;5;60:*.mdump=38;5;241:*.merged-ca-bundle=1:*.mf=38;5;7:*.mfasl=38;5;7:*.mht=38;5;125;1:*.mi=38;5;7:*.mid=38;5;136;1:*.midi=38;5;136;1:*.mjs=38;5;074;1:*.mkd=38;5;184:*.mkv=38;5;114:*.mm=38;5;7:*.mobi=38;5;141:*.mod=38;5;137;1:*.moon=38;5;81:*.mount=38;5;45:*.mov=38;5;114:*.mp3=38;5;137;1:*.mp4=38;5;114:*.mp4a=38;5;137;1:*.mpeg=38;5;114:*.mpg=38;5;114:*.msg=38;5;178:*.msql=38;5;222:*.mtx=38;5;7:*.mustache=38;5;125;1:*.mysql=38;5;222:*.nc=38;5;60:*.ndjson=38;5;178:*.nds=38;5;213:*.nes=38;5;213:*.nfo=38;5;184:*.nib=38;5;57:*.nim=38;5;81:*.nimble=38;5;81:*.nix=38;5;155:*.nrg=38;5;124:*.nth=38;5;97:*.numbers=38;5;112:*.o=38;5;241:*.odb=38;5;111:*.odp=38;5;166:*.ods=38;5;112:*.odt=38;5;111:*.oga=38;5;137;1:*.ogg=38;5;137;1:*.ogm=38;5;114:*.ogv=38;5;115:*.old=38;5;242:*.opus=38;5;137;1:*.org=38;5;184:*.orig=38;5;241:*.otf=38;5;66:*.out=38;5;242:*.p12=38;5;192;3:*.p7s=38;5;192;3:*.pacnew=38;5;33:*.pages=38;5;111:*.pak=38;5;215:*.part=38;5;239:*.patch=48;5;197;38;5;232;1:*.path=38;5;45:*.pbxproj=1:*.pc=38;5;7:*.pcap=38;5;29:*.pcb=38;5;7:*.pcf=1:*.pcm=38;5;136;1:*.pdf=38;5;141:*.pem=38;5;192;3:*.pfa=38;5;66:*.pfb=38;5;66:*.pfm=38;5;66:*.pgn=38;5;178:*.pgp=38;5;192;3:*.pgsql=38;5;222:*.php=38;5;81:*.pi=38;5;7:*.pid=38;5;248:*.pk3=38;5;215:*.pl=38;5;208:*.plist=1:*.plt=38;5;7:*.ply=38;5;216:*.pm=38;5;203:*.png=38;5;97:*.pod=38;5;184:*.pot=38;5;7:*.pps=38;5;166:*.ppt=38;5;166:*.ppts=38;5;166:*.pptsm=38;5;166;4:*.pptx=38;5;166:*.pptxm=38;5;166;4:*.profile=1:*.properties=38;5;116:*.ps=38;5;99:*.psd=38;5;97:*.psf=1:*.pxd=38;5;97:*.pxm=38;5;97:*.py=38;5;41:*.pyc=38;5;240:*.qcow=38;5;124:*.r=38;5;49:*.r[0-9]{0,2}=38;5;239:*.rake=38;5;155:*.rb=38;5;41:*.rdata=38;5;178:*.rdf=38;5;7:*.rkt=38;5;81:*.rlib=38;5;241:*.rmvb=38;5;114:*.rnc=38;5;178:*.rng=38;5;178:*.rom=38;5;213:*.rpm=38;5;215:*.rs=38;5;81:*.rss=38;5;178:*.rst=38;5;184:*.rstheme=1:*.rtf=38;5;111:*.ru=38;5;7:*.s=38;5;110:*.s3m=38;5;137;1:*.sample=38;5;114:*.sass=38;5;125;1:*.sassc=38;5;244:*.sav=38;5;213:*.sc=38;5;41:*.scala=38;5;41:*.scan=38;5;242:*.sch=38;5;7:*.scm=38;5;7:*.scpt=38;5;219:*.scss=38;5;125;1:*.sed=38;5;172:*.service=38;5;45:*.sfv=38;5;116:*.sgml=38;5;178:*.sh=38;5;172:*.sid=38;5;137;1:*.sig=38;5;192;3:*.signature=38;5;192;3:*.sis=38;5;7:*.sms=38;5;213:*.snapshot=38;5;45:*.socket=38;5;45:*.sparseimage=38;5;124:*.spl=38;5;7:*.sql=38;5;222:*.sqlite=38;5;60:*.srt=38;5;117:*.ssa=38;5;117:*.st=38;5;213:*.stackdump=38;5;241:*.state=38;5;248:*.stderr=38;5;160;1:*.stl=38;5;216:*.storyboard=38;5;196:*.strings=1:*.sty=38;5;7:*.sub=38;5;117:*.sublime-build=1:*.sublime-commands=1:*.sublime-keymap=1:*.sublime-project=1:*.sublime-settings=1:*.sublime-snippet=1:*.sublime-workspace=1:*.sug=38;5;7:*.sup=38;5;117:*.svg=38;5;99:*.swap=38;5;45:*.swift=38;5;219:*.swo=38;5;244:*.swp=38;5;244:*.sx=38;5;81:*.t=38;5;114:*.target=38;5;45:*.tcc=38;5;110:*.tcl=38;5;64;1:*.tdy=38;5;7:*.tex=38;5;184:*.textile=38;5;184:*.tf=38;5;168:*.tfm=38;5;7:*.tfnt=38;5;7:*.tfstate=38;5;168:*.tfvars=38;5;168:*.tg=38;5;7:*.theme=38;5;116:*.tif=38;5;97:*.tiff=38;5;97:*.timer=38;5;45:*.tmTheme=1:*.tmp=38;5;244:*.toast=38;5;124:*.toml=38;5;178:*.torrent=38;5;116:*.ts=38;5;115:*.tsv=38;5;78:*.ttf=38;5;66:*.twig=38;5;81:*.txt=38;5;253:*.typelib=38;5;60:*.un~=38;5;241:*.urlview=38;5;116:*.user-ca-bundle=1:*.v=38;5;81:*.vala=38;5;81:*.vapi=38;5;81:*.vb=38;5;81:*.vba=38;5;81:*.vbs=38;5;81:*.vcard=38;5;7:*.vcd=38;5;124:*.vcf=38;5;7:*.vdf=38;5;215:*.vdi=38;5;124:*.vfd=38;5;124:*.vhd=38;5;124:*.vhdx=38;5;124:*.vim=38;5;172:*.viminfo=1:*.vmdk=38;5;124:*.vob=38;5;115;1:*.vpk=38;5;215:*.vtt=38;5;117:*.war=38;5;215:*.wav=38;5;136;1:*.webloc=38;5;116:*.webm=38;5;115:*.webp=38;5;97:*.wma=38;5;137;1:*.wmv=38;5;114:*.woff=38;5;66:*.woff2=38;5;66:*.wrl=38;5;216:*.wv=38;5;136;1:*.wvc=38;5;136;1:*.xcconfig=1:*.xcf=38;5;7:*.xcsettings=1:*.xcuserstate=1:*.xcworkspacedata=1:*.xib=38;5;208:*.xla=38;5;76:*.xln=38;5;7:*.xls=38;5;112:*.xlsx=38;5;112:*.xlsxm=38;5;112;4:*.xltm=38;5;73;4:*.xltx=38;5;73:*.xml=38;5;178:*.xpi=38;5;215:*.xpm=38;5;97:*.xsd=38;5;178:*.xsh=38;5;41:*.yaml=38;5;178:*.yml=38;5;178:*.z[0-9]{0,2}=38;5;239:*.zcompdump=38;5;241:*.zig=38;5;81:*.zlogin=1:*.zlogout=1:*.zprofile=1:*.zsh=38;5;172:*.zshenv=1:*.zwc=38;5;241:*.zx[0-9]{0,2}=38;5;239:bd=38;5;68:ca=38;5;17:cd=38;5;113;1:di=38;5;30:do=38;5;127:ex=38;5;208;1:pi=38;5;126:fi=0:ln=target:mh=38;5;222;1:no=0:or=48;5;196;38;5;232;1:ow=38;5;220;1:sg=48;5;3;38;5;0:su=38;5;220;1;3;100;1:so=38;5;197:st=38;5;86;48;5;234:tw=48;5;235;38;5;139;3:'
export LS_COLORS

# bun completions
[ -s "/Users/theo/.bun/_bun" ] && source "/Users/theo/.bun/_bun"
export PATH="/opt/homebrew/opt/node@20/bin:$PATH"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/theo/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/theo/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/theo/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/theo/google-cloud-sdk/completion.zsh.inc'; fi

. "$HOME/.local/bin/env"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/theo/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/theo/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/theo/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/theo/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/Users/theo/miniforge3/bin/mamba';
export MAMBA_ROOT_PREFIX='/Users/theo/miniforge3';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/theo/.lmstudio/bin"
# End of LM Studio CLI section

