# ------------------------------------------------------------------------------
# History Settings
# ------------------------------------------------------------------------------

# History file configuration
HISTFILE=~/.zsh_history
HISTSIZE=100000000
SAVEHIST=100000000

# History options
setopt auto_pushd
setopt hist_expand
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt append_history
setopt inc_append_history
setopt hist_save_no_dups
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_expire_dups_first
setopt share_history
setopt hist_verify