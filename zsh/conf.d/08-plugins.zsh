# ------------------------------------------------------------------------------
# External Plugins
# ------------------------------------------------------------------------------

# Hub alias
if command -v hub &> /dev/null; then
    eval "$(hub alias -s)"
fi

# FZF configuration
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
fi

export FZF_COMPLETION_TRIGGER=","
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS=' --height 40% --reverse'

# FZF key bindings
if [[ $- == *i* ]] && [ -f "$HOME/.fzf/shell/completion.zsh" ]; then
    source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null
fi

if [[ -x "$HOME/.fzf/shell/key-bindings.zsh" ]]; then
    source "$HOME/.fzf/shell/key-bindings.zsh"
fi

# Enhancd
if [ -f ~/enhancd/init.sh ]; then
    source ~/enhancd/init.sh
    export ENHANCD_FILTER=fzy:fzf:peco:percol:gof:picj:icepick:sentaku:selecta
fi

# Custom plugins
# Note: ghux plugin was removed as it's no longer available
# Note: ghq_unset function has been moved to 06-functions.zsh

# Security file
if [ -f '/Users/2357gi/.sec' ]; then 
    source ~/.sec
fi