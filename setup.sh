#!/usr/bin/env zsh

set -euo pipefail

repo_root=$(cd "$(dirname "$0")" && pwd)

function ensure_homebrew() {
    if [[ ! $+commands[brew] ]]; then
        echo "Homebrew が見つかりません。https://brew.sh/ を参照してインストールしてください" >&2
        exit 1
    fi
}

function install_brew_bundle() {
    if [[ ! -f "${repo_root}/Brewfile" ]]; then
        echo "Brewfile が見つかりません: ${repo_root}/Brewfile" >&2
        exit 1
    fi
    brew bundle --file="${repo_root}/Brewfile"
}

function setup_dotfiles() {
    local src dst
    for src in "${repo_root}"/.*; do
        case "${src##*/}" in
            .|..|.git|.DS_Store|.gitignore|.gitconfigbk|setup.sh|Brewfile|Brewfile.lock.json)
                continue
                ;;
        esac
        dst="${HOME}/${src##*/}"
        if [[ -L "${dst}" ]]; then
            if [[ "$(readlink "${dst}")" == "${src}" ]]; then
                continue
            fi
            rm -f "${dst}"
        elif [[ -e "${dst}" ]]; then
            local backup="${dst}.backup.$(date +%Y%m%d%H%M%S)"
            echo "既存の ${dst} を ${backup} に退避します" >&2
            mv "${dst}" "${backup}"
        fi
        ln -s "${src}" "${dst}"
    done

    if [[ -f "${repo_root}/.gitconfigbk" ]]; then
        if [[ -e "${HOME}/.gitconfig" ]]; then
            echo "${HOME}/.gitconfig が存在するため .gitconfigbk のコピーをスキップしました" >&2
        else
            cp "${repo_root}/.gitconfigbk" "${HOME}/.gitconfig"
        fi
    fi
}

function main() {
    ensure_homebrew
    install_brew_bundle
    setup_dotfiles
    echo "dotfiles 設定が完了しました。新しいシェルを開いて動作を確認してください。"
}

main "$@"
