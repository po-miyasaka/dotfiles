# ヒストリ設定
export SAVEHIST=1000000
export HISTSIZE=1000000

if [[ -z ${HISTFILE:-} ]]; then
  typeset -gx HISTFILE="${DOTFILES_STATE_DIR}/zsh_history"
fi
mkdir -p "${HISTFILE:h}"
[[ -f "${HISTFILE}" ]] || : > "${HISTFILE}"
chmod 600 "${HISTFILE}" 2>/dev/null

setopt append_history share_history
setopt hist_ignore_all_dups hist_ignore_dups hist_reduce_blanks hist_save_no_dups
setopt hist_ignore_space hist_verify inc_append_history
