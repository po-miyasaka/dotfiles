[[ -o interactive ]] || return

typeset -g DOTFILES_ZSH_DIR="${HOME}/.zshrc.d"
[[ -d "${DOTFILES_ZSH_DIR}" ]] || mkdir -p "${DOTFILES_ZSH_DIR}"

for dotfiles_module in "${DOTFILES_ZSH_DIR}"/[0-9][0-9]-*.zsh; do
  [[ -r "${dotfiles_module}" ]] || continue
  source "${dotfiles_module}"
done

unset dotfiles_module


