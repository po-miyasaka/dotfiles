# 補完設定
autoload -Uz compinit
zmodload zsh/complist 2>/dev/null

typeset -g DOTFILES_COMPDUMP="${DOTFILES_CACHE_DIR}/compdump"
mkdir -p "${DOTFILES_COMPDUMP:h}"

compinit -C -d "${DOTFILES_COMPDUMP}"

setopt auto_list auto_menu
zstyle ':completion:*:default' menu select=1

[[ -z ${LS_COLORS:-} ]] && export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
