# fzf の補完とキーバインド
if command -v fzf >/dev/null 2>&1; then
  typeset fzf_base="${DOTFILES_BREW_PREFIX:-}"
  if [[ -n ${fzf_base:-} && -d "${fzf_base}/opt/fzf" ]]; then
    fzf_base="${fzf_base}/opt/fzf"
  elif command -v brew >/dev/null 2>&1; then
    fzf_base="$(brew --prefix fzf 2>/dev/null)"
  else
    fzf_base="${HOME}/.fzf"
  fi

  if [[ -d "${fzf_base}/shell" ]]; then
    [[ -f "${fzf_base}/shell/completion.zsh" ]] && source "${fzf_base}/shell/completion.zsh"
    [[ -f "${fzf_base}/shell/key-bindings.zsh" ]] && source "${fzf_base}/shell/key-bindings.zsh"
  fi
  unset fzf_base
fi
