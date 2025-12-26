# ------------------------------------------------------------------------------
# External Plugins
# ------------------------------------------------------------------------------

# Hub alias
if command -v hub &> /dev/null; then
    eval "$(hub alias -s)"
fi

export FZF_COMPLETION_TRIGGER=","
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS=' --height 40% --reverse'

# FZF key bindings - support multiple installation methods
FZF_LOCATIONS=(
    "/opt/homebrew/opt/fzf"
    "/usr/local/opt/fzf"
    "$HOME/.fzf"
)

FZF_FOUND=0
for fzf_base in "${FZF_LOCATIONS[@]}"; do
    if [[ -d "$fzf_base" ]]; then
        # Source completion
        if [[ $- == *i* ]] && [[ -f "$fzf_base/shell/completion.zsh" ]]; then
            source "$fzf_base/shell/completion.zsh" 2> /dev/null
        fi
        # Source key bindings
        if [[ -f "$fzf_base/shell/key-bindings.zsh" ]]; then
            source "$fzf_base/shell/key-bindings.zsh"
            FZF_FOUND=1
        fi
        break
    fi
done

# Fallback to standard zsh history search if fzf is not available
if [[ $FZF_FOUND -eq 0 ]]; then
    # Ctrl+R for history search
    bindkey '^R' history-incremental-search-backward
    # Ctrl+S for forward search
    bindkey '^S' history-incremental-search-forward
fi

unset fzf_base FZF_LOCATIONS FZF_FOUND

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

# ghux
if [ -f '/Users/2357gi/src/github.com/2357gi/ghux' ]; then
    source /Users/2357gi/src/github.com/2357gi/ghux/ghux.plugin.zsh
fi
