# 履歴ビューのデフォルト（fzfが無い場合のフォールバック）
function his() {
  fc -rln 1
}

# fzf / ghq を使ったウィジェット類
if command -v fzf >/dev/null 2>&1; then
  function his() {
    fc -rln 1 | fzf "$@"
  }

  function __dotfiles_widget_history() {
    local selected
    selected=$(fc -rln 1 | awk '!seen[$0]++' | fzf --no-sort --query "$LBUFFER") || return
    BUFFER=${selected}
    CURSOR=${#BUFFER}
    zle redisplay
  }
  zle -N hisfunc __dotfiles_widget_history
  bindkey "^H" hisfunc

  if command -v ghq >/dev/null 2>&1; then
    function __dotfiles_widget_ghq_cd() {
      local repo
      repo=$(ghq list -p | fzf --query "$LBUFFER") || return
      BUFFER="cd ${(q)repo}"
      CURSOR=${#BUFFER}
      zle redisplay
    }
    zle -N gp __dotfiles_widget_ghq_cd
    bindkey "^G" gp
  fi

  function __dotfiles_widget_trash() {
    local target safe_target
    target=$(command ls -A1 | fzf --query "$LBUFFER") || return
    safe_target=${target}
    [[ ${safe_target} == -* ]] && safe_target=./${safe_target}
    BUFFER="mv -f ${(q)safe_target} ~/.Trash"
    CURSOR=${#BUFFER}
    zle redisplay
  }
  zle -N trash __dotfiles_widget_trash
  bindkey "^T" trash

  function __dotfiles_widget_lscd() {
    local selection
    local -a candidates unique
    local -A seen

    candidates=()
    unique=()
    seen=()

    while IFS= read -r dir; do
      candidates+=("${dir#./}")
    done < <(command find . -maxdepth 1 -mindepth 1 -type d 2>/dev/null)

    if [[ -r "${POWERED_CD_LOG:-}" ]]; then
      while IFS= read -r line; do
        candidates+=("${line}")
      done < "${POWERED_CD_LOG}"
    fi

    for entry in "${candidates[@]}"; do
      [[ -n ${entry} ]] || continue
      [[ -n ${seen["${entry}"]} ]] && continue
      seen["${entry}"]=1
      unique+=("${entry}")
    done

    [[ ${#unique[@]} -gt 0 ]] || return

    selection=$(printf '%s\n' "${unique[@]}" | fzf --query "$LBUFFER") || return
    BUFFER="cd ${(q)selection}"
    CURSOR=${#BUFFER}
    zle redisplay
  }
  zle -N lscd __dotfiles_widget_lscd
  bindkey "^L" lscd
fi

# powered_cd の履歴管理
function chpwd() {
  [[ -n "${POWERED_CD_LOG:-}" && -w "${POWERED_CD_LOG}" ]] || return
  grep -Fxq -- "${PWD}" "${POWERED_CD_LOG}" 2>/dev/null && return
  print -r -- "${PWD}" >> "${POWERED_CD_LOG}"
}
