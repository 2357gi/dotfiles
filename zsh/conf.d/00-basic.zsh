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

# GHQ settings
if type ghq &> /dev/null; then
    export ghq_root=$(ghq root)
    export GITHUB_DIR=$ghq_root/github.com
fi

# GitHub token
if [[ -x $HOME/dotfiles/github_token ]]; then
    source $HOME/dotfiles/github_token
fi

# Docker settings
export DOCKER_BUILDKIT=1