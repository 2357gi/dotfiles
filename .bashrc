# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.pre.bash"

# bashrc

# If not runnning interactively, do not anyting
[ -z "$PS1" ] && return



export PATH=$PATH:/usr/local/bin/

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi
color_prompt=yes

# fzf
if [ -d "/opt/homebrew/opt/fzf/bin" ]; then
    export PATH="/opt/homebrew/opt/fzf/bin:$PATH"
elif [ -d "/usr/local/opt/fzf/bin" ]; then
    export PATH="/usr/local/opt/fzf/bin:$PATH"
elif [ -d "$HOME/.fzf/bin" ]; then
    export PATH="$HOME/.fzf/bin:$PATH"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export PATH="$HOME/bin:$PATH"


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.post.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.post.bash"
