

alias ls='ls -GF --color=auto'

alias rm='rm -i'
alias ..='cd ..'

alias mv='mv -i'
alias cp='cp -i'

alias ll='ls -alF'

alias up='cd ..; ls -lF'

alias vi='vim'
alias g='git'
alias p='pwd'

alias df='df -h'

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
