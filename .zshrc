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

# Remove duplicates from PATH
typeset -U path cdpath fpath manpath

# Load Oh My Zsh plugins (if available)
plugins=(
    git
)

# Final cleanup and verification
if command -v zsh &> /dev/null; then
    echo "✓ ZSH configuration loaded successfully"
    echo "✓ RTX: $(command -v rtx &> /dev/null && echo "available" || echo "not found")"
    echo "✓ Volta: $(command -v volta &> /dev/null && echo "available" || echo "not found")"
fi