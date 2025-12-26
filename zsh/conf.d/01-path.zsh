# ------------------------------------------------------------------------------
# PATH Management
# ------------------------------------------------------------------------------

# Platform detection
is_osx() { [[ $OSTYPE == darwin* ]]; }
is_ubuntu() { [[ $OSTYPE == linux-gnu* ]]; }

# Basic PATH setup
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/tmux/bin:$PATH"
export PATH="$HOME/dotfiles/bin:$PATH"

# Platform-specific PATH
if is_osx; then
    export PATH="/usr/local/opt/gettext/bin:$PATH"
    export PATH="/usr/local/opt/avr-gcc@7/bin:$PATH"
fi

# Mise (formerly rtx) - replaces anyenv, pyenv, rbenv, goenv
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
fi

# Volta (Node.js version manager)
if [[ -s "$HOME/.volta/load.sh" ]]; then
    source "$HOME/.volta/load.sh"
fi

# Go-specific settings
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"
export GO111MODULE=on

# direnv
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# Homebrew completion paths (must be set before compinit)
if is_osx; then
    # Add Homebrew's completion directory to fpath
    if [[ -d "/opt/homebrew/share/zsh/site-functions" ]]; then
        fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
    fi
    if [[ -d "/usr/local/share/zsh/site-functions" ]]; then
        fpath=(/usr/local/share/zsh/site-functions $fpath)
    fi
fi

# Remove duplicates from PATH
typeset -U path cdpath fpath manpath