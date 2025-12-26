# ------------------------------------------------------------------------------
# Key Bindings
# ------------------------------------------------------------------------------

# Reset keymap and set vim mode
bindkey -d
bindkey -v

# More comfortable keybindings
bindkey -M viins '^A'  beginning-of-line
bindkey -M viins '^E'  end-of-line
bindkey -M viins '^F'  forward-char
bindkey -M viins '^B'  backward-char
bindkey -M viins '^U'  backward-kill-line
bindkey -M viins '^W'  backward-kill-word

# History search
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end  history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end 

# Incremental search (zsh >= 4.3.10)
if is-at-least 4.3.10; then
    # bindkey '^R' history-incremental-pattern-search-backward  # Commented out to avoid conflict with fzf-history-widget
    bindkey '^S' history-incremental-pattern-search-forward
fi

# Ctrl-Z vim toggle
fancy-ctrl-z() {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line
    else
        zle push-input
        zle clear-screen
    fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# History keybindings
ZSH_HISTORY_KEYBIND_GET="^B"
ZSH_HISTORY_FILTER_OPTIONS="--filter-branch --filter-dir"
ZSH_HISTORY_KEYBIND_ARROW_UP="^p"
ZSH_HISTORY_KEYBIND_ARROW_DOWN="^n"