export PATH=$PATH:/usr/local/bin/

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi
color_prompt=yes

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
