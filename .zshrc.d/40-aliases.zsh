# alias 系
setopt auto_cd

alias ls='ls -GFf'
alias ll='ls -GoFf'

# multi-agent-shogun
typeset -g SHOGUN_DIR="${HOME}/ghq/github.com/yohey-w/multi-agent-shogun"
alias csst='cd "${SHOGUN_DIR}" && ./shutsujin_departure.sh'
alias css='tmux attach-session -t shogun'
alias csm='tmux attach-session -t multiagent'
alias csk='cd "${SHOGUN_DIR}" && ./shutsujin_departure.sh -c'
alias csttyd='${SHOGUN_DIR}/scripts/start_ttyd.sh'
