[[ -o interactive ]] || return

typeset -g DOTFILES_ZSH_DIR="${HOME}/.zshrc.d"
[[ -d "${DOTFILES_ZSH_DIR}" ]] || mkdir -p "${DOTFILES_ZSH_DIR}"

for dotfiles_module in "${DOTFILES_ZSH_DIR}"/[0-9][0-9]-*.zsh; do
  [[ -r "${dotfiles_module}" ]] || continue
  source "${dotfiles_module}"
done

unset dotfiles_module

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/miyasaka_kazutoshi/.lmstudio/bin"
# End of LM Studio CLI section

export NETLIFY_PERSONAL_ACCESS_TOKEN=$(security find-generic-password -a netlify -s NETLIFY_PERSONAL_ACCESS_TOKEN -w 2>/dev/null)
export MATCH_PASSWORD=$(security find-generic-password -a match -s MATCH_PASSWORD -w 2>/dev/null)
