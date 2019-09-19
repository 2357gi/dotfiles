# bashrc

# If not runnning interactively, do not anyting
[ -z "$PS1" ] && return



export PATH=$PATH:/usr/local/bin/

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi
color_prompt=yes

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
