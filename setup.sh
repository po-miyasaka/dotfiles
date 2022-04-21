PWD="$PWD"
cd `dirname $0`
set -e

downloadTools () {
    if [[ ! $+commands[brew] ]]; then 
        echo brew入れてくれ
        exit 0
    fi
}

setupDotFiles () {
    for f in  `echo .*`;
    do
        if [[ $f = "." ]]; then continue; fi
        if [[ $f = ".." ]]; then continue; fi
        if [[ $f = ".DS_Store" ]]; then continue; fi 
        if [[ $f = ".gitignore" ]]; then continue; fi 
        if [[ $f = "setup.sh" ]]; then continue; fi 
        if [[ $f = ".git" ]]; then continue; fi 
        if [[ $f = ".gitconfigbk"  ]] ; then 
            cp "$HOME/dotfiles/$f" "$HOME/.gitconfig"
            continue
        fi 

        ln -sf "$HOME/dotfiles/$f" "$HOME/$f"
    done
}

downloadTools
setupDotFiles
