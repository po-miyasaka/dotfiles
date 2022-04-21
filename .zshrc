eval "$(rbenv init -)"
eval "$(nodenv init -)"
ssh-add -AK ~/.ssh/pepabo > /dev/null 2>&1


# Completions
autoload -U compinit && compinit
setopt auto_list
setopt auto_menu
zstyle ':completion:*:default' menu select=1
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}


# history
export SAVEHIST=1000000
export HISTSIZE=1000000
export HISTFILE=~/.zsh_history
alias his='$(history -r -n 1 | peco)'
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_verify
setopt hist_save_no_dups
setopt hist_expand
setopt inc_append_history

function hisfunc () {
  BUFFER=$(history -r -n 1 | uniq | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N hisfunc
bindkey "^H" hisfunc

# git 
function gp () {
  local tmp
  tmp=$(ghq list -p | peco --query "$LBUFFER")
  if [[ -n "$tmp" ]] {
    BUFFER="cd ${tmp}"
    CURSOR=$#BUFFER
  }
  zle redisplay
}

zle -N gp
bindkey "^G" gp

export function rprompt-branch () {
  local branch_name branch_status st

  # if [ ! -e  ".git" ]; then
  #   return ""
  # fi

  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`

  if [[ -n `echo $st | grep "nothing to"` ]]; then
    branch_status="%F{green}"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    branch_status="%F{red}+"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    branch_status="%F{red}+"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    branch_status="%F{yellow}"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    branch_status="%F{red}conflict"
  else
    branch_status="%F{blue}"
  fi

  if [[ -n "$branch_name" ]] {
    echo "${branch_status}[${branch_name}]%f"
  } else {
    echo ""
  }
}


# trashcd
function trash () {
  local TMP
  TMP=$(ls -a -r | peco --query "$LBUFFER")
  BUFFER="mv $TMP ~/.Trash"
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N trash
bindkey "^T" trash

# cd 
function lscd () {
  local TMP
  TMP=$(ll | awk '/dr/ {print $8}')
  TMP="$TMP\n$(cat ~/.powered_cd.log)"
  TMP=$(echo -e "$TMP" | peco --query "$LBUFFER")
  cd "$TMP"
  BUFFER=''
  zle redisplay
}
zle -N lscd
bindkey "^L" lscd

chpwd () {
  if [[ -n "$(cat ~/.powered_cd.log | grep $PWD)" ]]; then
    return
  else
    echo "$PWD" >> ~/.powered_cd.log
  fi
}

[ -e ~/.powered_cd.log ] || touch ~/.powered_cd.log; chmod 777 ~/.powered_cd.log

setopt auto_cd

# ls
alias ls='ls -GFf'
alias ll='ls -GoFf'
# prompt
setopt prompt_subst
RPROMPT='`rprompt-branch`'

PROMPT="
%F{green}%~/%f 
▶ "
fpath=(/usr/local/share/zsh-completions $fpath)
