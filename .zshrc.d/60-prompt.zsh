setopt prompt_subst

function __dotfiles_prompt_git() {
  command git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

  local branch
  branch=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null)
  if [[ -z ${branch} ]]; then
    branch=$(command git rev-parse --short HEAD 2>/dev/null) || return
  fi

  local git_status
  git_status=$(command git status --porcelain --ignore-submodules=dirty 2>/dev/null)

  # クリーン（変更なし）→ 緑
  if [[ -z ${git_status} ]]; then
    printf '%%F{green}[%s]%%f' "${branch}"
    return
  fi

  # 差分がある（未ステージの変更、untracked）→ 赤
  if echo "${git_status}" | grep -q '^.\S' || echo "${git_status}" | grep -q '^??'; then
    printf '%%F{red}[%s]%%f' "${branch}"
  # コミットできる状態（ステージ済み変更のみ）→ 黄
  else
    printf '%%F{yellow}[%s]%%f' "${branch}"
  fi
}

RPROMPT='$(__dotfiles_prompt_git)'

PROMPT=$'%F{green}%~/%f\n▶ '
