PWD="$PWD"

for f in  `echo .*`;
do

    if [[ $f = "." ]]; then continue ;fi
    if [[ $f = ".." ]]; then continue; fi
    if [[ $f = ".DS_Store" ]]; then continue; fi 
    if [[ $f = ".gitignore" ]]; then continue; fi 
    if [[ $f = "setup.sh" ]]; then continue; fi 
    if [[ $f = ".git" ]]; then continue; fi 
    if [[ $f = ".gitconfigbk" ]]; then
        mv "$HOME/dotfiles/$f" "$HOME/.gitconfig"
    fi 

    ln -sf "$HOME/dotfiles/$f" "$HOME/$f"
done

 
