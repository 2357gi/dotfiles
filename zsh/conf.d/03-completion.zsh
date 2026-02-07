# ------------------------------------------------------------------------------
# Completion Settings
# ------------------------------------------------------------------------------

# Load fzf-tab before compinit
if [[ -f ~/.fzf-tab/fzf-tab.plugin.zsh ]]; then
    source ~/.fzf-tab/fzf-tab.plugin.zsh
fi

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

# fzf-tab configuration
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:*' fzf-flags --height=40% --border --reverse
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath 2>/dev/null || ls -1 $realpath'
zstyle ':fzf-tab:complete:git-*:*' fzf-preview 'git show --color=always $word 2>/dev/null || echo $word'
zstyle ':fzf-tab:*' fzf-min-height 20

# Docker completion with fzf
if [[ -n "$GITHUB_DIR" && -f "$GITHUB_DIR/kwhrtsk/docker-fzf-completion/docker-fzf.zsh" ]]; then
    source "$GITHUB_DIR/kwhrtsk/docker-fzf-completion/docker-fzf.zsh"
fi

# Kubernetes completion
if command -v kubectl &> /dev/null; then
    source <(kubectl completion zsh)
fi

# aws cli completion
if command -v aws &> /dev/null; then
    complete -C '/usr/local/bin/aws_completer' aws
fi

# AWS profile completion with fzf
_aws_profile_fzf() {
  local selected
  selected=$(grep '^\[profile ' ~/.aws/config 2>/dev/null | \
    sed 's/^\[profile \(.*\)\]/\1/' | \
    grep -v -e '-sso$' -e '-no-session$' | \
    fzf --prompt="AWS Profile > " --height=40% --border)

  if [[ -n "$selected" ]]; then
    LBUFFER="${LBUFFER}${selected}"
  fi
  zle reset-prompt
}

zle -N _aws_profile_fzf

# Completion definitions for aliases (must be after compinit)
# Only set compdef if the completion function exists
compdef g=git 2>/dev/null || true
if command -v docker &> /dev/null; then
    compdef d=docker 2>/dev/null || true
    compdef fig=docker-compose 2>/dev/null || true
fi
if command -v kubectl &> /dev/null; then
    compdef k=kubectl 2>/dev/null || true
fi
