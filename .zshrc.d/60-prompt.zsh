# プロンプト
setopt prompt_subst

function __dotfiles_prompt_git() {
  command git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

  local branch
  branch=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null)
  if [[ -z ${branch} ]]; then
    branch=$(command git rev-parse --short HEAD 2>/dev/null) || return
  fi

  local status
  status=$(command git status --porcelain --ignore-submodules=dirty 2>/dev/null)

  if [[ -z ${status} ]]; then
    printf '%%F{green}[%s]%%f' "${branch}"
    return
  fi

  if printf '%s\n' "${status}" | grep -q '^??'; then
    printf '%%F{red}[%s]%%f' "${branch}"
  else
    printf '%%F{yellow}[%s]%%f' "${branch}"
  fi
}

RPROMPT='$(__dotfiles_prompt_git)'

PROMPT=$'%F{green}%~/%f\n▶ '
