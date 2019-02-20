export PATH=$PATH:/usr/local/bin/
export PATH="/home/gi/anaconda3/bin:$PATH"

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi
color_prompt=yes

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
