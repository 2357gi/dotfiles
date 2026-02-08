# ------------------------------------------------------------------------------
# Basic Settings
# ------------------------------------------------------------------------------

# Locale and encoding
export LANG=ja_JP.UTF-8

# Editor and pager settings
export EDITOR=nvim
export PAGER=less
export LV="-c -Outf8"

# Load zsh modules
autoload -U is-at-least
autoload -Uz add-zsh-hook

# Platform detection functions
is_osx() { [[ $OSTYPE == darwin* ]]; }
is_ubuntu() { [[ $OSTYPE == linux-gnu* ]]; }

# Helper functions
function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONNECTION" ]; }

# GHQ settings (cached to avoid subprocess on every startup)
if type ghq &> /dev/null; then
    _ghq_cache="${XDG_CACHE_HOME:-$HOME/.cache}/ghq_root"
    if [[ ! -f "$_ghq_cache" ]] || [[ $(date +'%j') != $(stat -f '%Sm' -t '%j' "$_ghq_cache" 2>/dev/null || echo 0) ]]; then
        ghq root > "$_ghq_cache"
    fi
    export ghq_root=$(<"$_ghq_cache")
    export GITHUB_DIR=$ghq_root/github.com
    unset _ghq_cache
fi

# GitHub token
if [[ -x $HOME/dotfiles/github_token ]]; then
    source $HOME/dotfiles/github_token
fi

# Docker settings
export DOCKER_BUILDKIT=1