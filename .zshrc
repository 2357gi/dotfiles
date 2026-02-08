# ------------------------------------------------------------------------------
# Modern .zshrc with rtx/volta support
# ------------------------------------------------------------------------------

# Load all configuration modules in order
DOTFILES_DIR="$HOME/dotfiles"
ZSH_CONFIG_DIR="$DOTFILES_DIR/zsh/conf.d"

# Check if config directory exists
if [[ ! -d "$ZSH_CONFIG_DIR" ]]; then
    echo "Warning: ZSH config directory not found at $ZSH_CONFIG_DIR"
    return 1
fi

# Load configuration files in order
for config_file in "$ZSH_CONFIG_DIR"/*.zsh; do
    if [[ -r "$config_file" ]]; then
        source "$config_file"
    fi
done

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kentoogi/sandbox/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kentoogi/sandbox/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kentoogi/sandbox/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kentoogi/sandbox/google-cloud-sdk/completion.zsh.inc'; fi
