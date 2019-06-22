

alias ls='ls -GF'

alias rm='rm -i'
alias ..='cd ..'

alias mv='mv -i'
alias cp='cp -i'

alias ll='ls -alG'

alias gx="ghux"

alias c_='cd $_'

alias v='vim'
alias vi='vim'
alias vif='vim $(fzf)'

alias g='git'
compdef g=git
alias gs='git status --short --branch'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'

alias .z='source ~/.zshrc'

alias d='docker'
compdef d=docker
alias fig='docker-compose'
compdef fig=docker-compose
alias k='kubectl'
compdef k=kubectl

alias :q='exit'

alias c='pbcopy'

alias jn='jupyter notebook'

alias p='pwd'

alias df='df -h'

alias noti='terminal-notifier -message "コマンド完了"'

# global alias( zsh only)
alias -g A='| awk'
alias -g C='| pbcopy' # copy
alias -g C='| wc -l' # count
alias -g H='| head'
alias -g T='| tail'

dic() {
  w3m "http://ejje.weblio.jp/content/$1" | grep -E "主な|用例"
}
