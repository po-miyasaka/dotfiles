# 環境関連の初期化
setopt EXTENDED_GLOB

# XDG準拠の保存先を共有
typeset -gx DOTFILES_CACHE_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh"
typeset -gx DOTFILES_STATE_DIR="${XDG_STATE_HOME:-${HOME}/.local/state}/zsh"
mkdir -p "${DOTFILES_CACHE_DIR}" "${DOTFILES_STATE_DIR}"

# PATHとFPATHをユニークに保ちつつ整える
typeset -gU path PATH fpath FPATH

typeset brew_prefix
if command -v brew >/dev/null 2>&1; then
  brew_prefix=$(brew --prefix 2>/dev/null)
elif [[ -d /opt/homebrew ]]; then
  brew_prefix=/opt/homebrew
elif [[ -d /usr/local ]]; then
  brew_prefix=/usr/local
fi

if [[ -n ${brew_prefix:-} ]]; then
  typeset -gx DOTFILES_BREW_PREFIX="${brew_prefix}"
  [[ -d "${brew_prefix}/bin" ]] && path=("${brew_prefix}/bin" ${path})
  [[ -d "${brew_prefix}/sbin" ]] && path=("${brew_prefix}/sbin" ${path})
  [[ -d "${brew_prefix}/share/zsh/site-functions" ]] && fpath=("${brew_prefix}/share/zsh/site-functions" ${fpath})
  [[ -d "${brew_prefix}/share/zsh/functions" ]] && fpath=("${brew_prefix}/share/zsh/functions" ${fpath})
fi
unset brew_prefix
[[ -n ${DOTFILES_BREW_PREFIX:-} ]] || unset DOTFILES_BREW_PREFIX

[[ -d "${HOME}/.pyenv/bin" ]] && path=("${HOME}/.pyenv/bin" ${path})

# rbenv / nodenv は存在確認のうえ一度だけ初期化
if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - zsh)" 2>/dev/null
fi

if command -v nodenv >/dev/null 2>&1; then
  eval "$(nodenv init - zsh)" 2>/dev/null
fi

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init - zsh)" 2>/dev/null
fi

# ssh-agent に鍵を追加（mac依存を排除）
if command -v ssh-add >/dev/null 2>&1; then
  function __dotfiles_add_default_ssh_key() {
    [[ -S "${SSH_AUTH_SOCK:-}" ]] || return
    local key_path="${HOME}/.ssh/pepabo"
    [[ -f "${key_path}" ]] || return
    case "${OSTYPE}" in
      darwin*)
        ssh-add --apple-use-keychain "${key_path}" 2>/dev/null || ssh-add -K "${key_path}" 2>/dev/null
        ;;
      *)
        ssh-add "${key_path}" 2>/dev/null
        ;;
    esac
  }
  __dotfiles_add_default_ssh_key
  unset -f __dotfiles_add_default_ssh_key
fi

# powered_cd 用のログファイルを安全に用意
typeset -gx POWERED_CD_LOG="${DOTFILES_STATE_DIR}/powered_cd.log"
mkdir -p "${POWERED_CD_LOG:h}"
[[ -f "${POWERED_CD_LOG}" ]] || : > "${POWERED_CD_LOG}"
chmod 600 "${POWERED_CD_LOG}" 2>/dev/null

export PATH="$PATH:$HOME/.lmstudio/bin"