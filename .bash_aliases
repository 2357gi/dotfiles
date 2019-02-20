

alias ls='ls -GF'

alias rm='rm -i'
alias ..='cd ..'

alias mv='mv -i'
alias cp='cp -i'

alias ll='ls -alG'

alias up='cd ..; ls -lF'

alias fjvenv='. ~/develop/fujihalab_system/fjvenv/bin/activate'
alias zmvenv='. ~/Sandbox/zemi/zmvenv/bin/activate'

alias vi='vim'
alias vif='vim $(fzf)'

alias g='git'
alias ga='git add'
alias gs='git status --short --branch'
alias gcm='git commit -m'

alias cdg='cd ~/github.com/ && cd '

alias jn='jupyter notebook'

alias p='pwd'

alias df='df -h'

alias noti='terminal-notifier -message "コマンド完了"'

dic() {
  w3m "http://ejje.weblio.jp/content/$1" | grep "用例"
}

jj () {
  if [ $! ]; then
    JUMPDIR=$(find . -type d -maxdepth 1 | grep $1 | tail -1)
    if [[ -d $JUMPDIR && -n $JUMPDIR ]]; then
      cd $JUMPDIR
    else
      echo "directory not found :("
    fi
  fi
 }
