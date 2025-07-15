# ------------------------------------------------------------------------------
# Completion Settings
# ------------------------------------------------------------------------------

# Load completion system
autoload -U compinit; compinit -u
autoload -U bashcompinit; bashcompinit -u

# Basic completion options
setopt auto_cd
setopt correct
setopt list_packed
setopt nolistbeep
setopt list_types
setopt auto_param_keys
setopt auto_param_slash
setopt auto_remove_slash
setopt complete_aliases
setopt noautoremoveslash
setopt auto_pushd
setopt pushd_ignore_dups
setopt magic_equal_subst
setopt auto_menu
setopt auto_list
setopt complete_in_word
setopt glob_complete
setopt numeric_glob_sort
setopt mark_dirs

# Completion styling
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Docker completion with fzf
if [[ -n "$GITHUB_DIR" && -f "$GITHUB_DIR/kwhrtsk/docker-fzf-completion/docker-fzf.zsh" ]]; then
    source "$GITHUB_DIR/kwhrtsk/docker-fzf-completion/docker-fzf.zsh"
fi

# Kubernetes completion
if command -v kubectl &> /dev/null; then
    source <(kubectl completion zsh)
fi