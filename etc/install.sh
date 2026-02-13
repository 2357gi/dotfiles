#!/bin/bash

set -euo pipefail

# ------------------------------------------------------------------------------
# Constants and Configuration
# ------------------------------------------------------------------------------
readonly SPACER="================================================="
readonly DOTFILES_PATH="$HOME/dotfiles"
readonly GITHUB_REPO="https://github.com/2357gi/dotfiles.git"

# ------------------------------------------------------------------------------
# Platform Detection
# ------------------------------------------------------------------------------
is_macos() {
    [[ "$OSTYPE" == darwin* ]]
}

is_ubuntu() {
    [[ "$OSTYPE" == linux-gnu* ]] && command -v apt-get >/dev/null 2>&1
}

is_wsl() {
    [[ -n "${WSL_DISTRO_NAME:-}" ]] || [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]
}

# ------------------------------------------------------------------------------
# Utility Functions
# ------------------------------------------------------------------------------
log_info() {
    echo "ℹ️  $1"
}

log_success() {
    echo "✅ $1"
}

log_error() {
    echo "❌ $1" >&2
}

log_warning() {
    echo "⚠️  $1"
}

print_separator() {
    echo "$SPACER"
}

ask_user() {
    local prompt="$1"
    local default="${2:-Y}"
    local answer
    
    read -r -p "$prompt [${default}/n] " answer
    case "${answer:-$default}" in
        [Yy]*) return 0 ;;
        *) return 1 ;;
    esac
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# ------------------------------------------------------------------------------
# Main Functions
# ------------------------------------------------------------------------------
show_welcome() {
    cat << END
$SPACER
🚀 DOTFILES SETUP START!
$SPACER
Platform: $(uname -s) $(uname -r)
Target: $DOTFILES_PATH
$SPACER
END
}

clone_dotfiles() {
    if [[ -d "$DOTFILES_PATH" ]]; then
        log_warning "Dotfiles directory already exists: $DOTFILES_PATH"
        if ask_user "Update existing dotfiles repository?"; then
            log_info "Updating dotfiles repository..."
            cd "$DOTFILES_PATH"
            git pull origin master || {
                log_error "Failed to update dotfiles repository"
                return 1
            }
            log_success "Dotfiles repository updated"

            # Update submodules
            log_info "Updating git submodules..."
            if git submodule update --init --recursive; then
                log_success "Git submodules updated"
            else
                log_warning "Failed to update git submodules"
            fi
        fi
        return 0
    fi

    if ask_user "Clone dotfiles repository?"; then
        log_info "Cloning dotfiles repository..."
        if git clone --depth=1 "$GITHUB_REPO" "$DOTFILES_PATH"; then
            log_success "Dotfiles repository cloned"

            # Initialize and update submodules
            log_info "Initializing git submodules..."
            cd "$DOTFILES_PATH"
            if git submodule update --init --recursive; then
                log_success "Git submodules initialized"
            else
                log_warning "Failed to initialize git submodules"
            fi
        else
            log_error "Failed to clone dotfiles repository"
            return 1
        fi
    else
        log_info "Skipping dotfiles cloning"
    fi
}

generate_ssh_key() {
    if ask_user "Generate a new SSH key?"; then
        log_info "Generating SSH key..."
        if ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)" -f "$HOME/.ssh/id_ed25519"; then
            log_success "SSH key generated"
            log_info "Public key location: $HOME/.ssh/id_ed25519.pub"
        else
            log_error "Failed to generate SSH key"
            return 1
        fi
    else
        log_info "Skipping SSH key generation"
    fi
}

install_homebrew() {
    if command_exists brew; then
        log_info "Homebrew is already installed"
        return 0
    fi

    if ask_user "Install Homebrew?"; then
        log_info "Installing Homebrew..."
        if is_macos; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        elif is_ubuntu || is_wsl; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # Add Homebrew to PATH for Linux
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.bashrc"
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
        
        if command_exists brew; then
            log_success "Homebrew installed successfully"
        else
            log_error "Failed to install Homebrew"
            return 1
        fi
    else
        log_info "Skipping Homebrew installation"
    fi
}

create_symlinks() {
    print_separator
    log_info "Creating symbolic links..."
    print_separator
    
    if [[ ! -d "$DOTFILES_PATH" ]]; then
        log_error "Dotfiles directory not found: $DOTFILES_PATH"
        return 1
    fi

    cd "$DOTFILES_PATH"
    
    # Files to exclude from symlinking
    local exclude_files=(
        ".git"
        ".gitconfig.local.template"
        ".gitignore"
        ".commit_template"
        ".tmux"
        ".zsh"  # Old .zsh directory is now integrated
    )
    
    local linked_count=0
    
    for file in .??*; do
        [[ -f "$file" ]] || continue
        
        # Check if file should be excluded
        local should_exclude=false
        for exclude in "${exclude_files[@]}"; do
            if [[ "$file" == "$exclude" ]]; then
                should_exclude=true
                break
            fi
        done
        
        if [[ "$should_exclude" == true ]]; then
            continue
        fi
        
        if ln -snfv "$DOTFILES_PATH/$file" "$HOME/"; then
            ((linked_count++))
        else
            log_warning "Failed to link $file"
        fi
    done
    
    log_success "Created $linked_count symbolic links"
}

setup_config_directory() {
    print_separator
    log_info "Setting up .config directory..."
    print_separator

    if [[ ! -d "$DOTFILES_PATH/.config" ]]; then
        log_warning ".config directory not found in dotfiles: $DOTFILES_PATH/.config"
        return 0
    fi

    # Create .config directory if it doesn't exist
    mkdir -p "$HOME/.config"

    # Link each subdirectory in .config
    local linked_count=0
    for config_dir in "$DOTFILES_PATH/.config"/*; do
        if [[ -d "$config_dir" ]]; then
            local dir_name=$(basename "$config_dir")
            if ln -snfv "$config_dir" "$HOME/.config/$dir_name"; then
                ((linked_count++))
                log_info "Linked .config/$dir_name"
            else
                log_warning "Failed to link .config/$dir_name"
            fi
        fi
    done

    if [[ $linked_count -gt 0 ]]; then
        log_success "Created $linked_count .config directory links"
    else
        log_info "No .config directories to link"
    fi
}

install_packages() {
    if ! command_exists brew; then
        log_warning "Homebrew not found, skipping package installation"
        return 0
    fi

    print_separator
    log_info "Installing packages with Homebrew..."
    print_separator
    
    if [[ -f "$HOME/.Brewfile" ]]; then
        if brew bundle --global; then
            log_success "Packages installed successfully"
        else
            log_error "Failed to install some packages"
            return 1
        fi
    else
        log_warning "Brewfile not found at $HOME/.Brewfile"
    fi
}

setup_bin_directory() {
    print_separator
    log_info "Setting up bin directory..."
    print_separator
    
    if [[ -d "$DOTFILES_PATH/bin" ]]; then
        if ln -snfv "$DOTFILES_PATH/bin" "$HOME/bin"; then
            log_success "Bin directory linked"
        else
            log_error "Failed to link bin directory"
            return 1
        fi
    else
        log_warning "Bin directory not found: $DOTFILES_PATH/bin"
    fi
}

configure_git() {
    log_info "Configuring Git..."
    
    # Handle gitconfig.local template
    if [[ -f "$DOTFILES_PATH/.gitconfig.local.template" ]] && [[ ! -f "$HOME/.gitconfig.local" ]]; then
        log_info "Creating .gitconfig.local from template..."
        cp "$DOTFILES_PATH/.gitconfig.local.template" "$HOME/.gitconfig.local"
        log_info "Please edit $HOME/.gitconfig.local with your information"
    fi
    
    # Set global Git configuration
    if [[ -f "$DOTFILES_PATH/.commit_template" ]]; then
        git config --global commit.template "$DOTFILES_PATH/.commit_template"
        log_success "Git commit template configured"
    fi
    
    if [[ -f "$DOTFILES_PATH/.gitignore_global" ]]; then
        git config --global core.excludesfile "$DOTFILES_PATH/.gitignore_global"
        log_success "Global gitignore configured"
    fi
}

setup_platform_specific() {
    if is_macos; then
        setup_macos_specific
    elif is_ubuntu || is_wsl; then
        setup_ubuntu_specific
    fi
}

setup_macos_specific() {
    log_info "Setting up macOS-specific configurations..."
    
    # Run macOS defaults if script exists
    if [[ -f "$DOTFILES_PATH/etc/scripts/macos.sh" ]]; then
        if ask_user "Apply macOS system defaults?"; then
            log_info "Applying macOS system defaults..."
            if bash "$DOTFILES_PATH/etc/scripts/macos.sh"; then
                log_success "macOS defaults applied"
            else
                log_error "Failed to apply macOS defaults"
            fi
        fi
    fi
    
    # Docker completion setup (macOS only)
    if [[ -d "/Applications/Docker.app/Contents/Resources/etc" ]]; then
        log_info "Setting up Docker completion for macOS..."
        mkdir -p "$HOME/.zsh/completions"
        ln -sf "/Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion" "$HOME/.zsh/completions/_docker"
        ln -sf "/Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion" "$HOME/.zsh/completions/_docker-compose"
        log_success "Docker completion configured"
    fi
}

setup_ubuntu_specific() {
    log_info "Setting up Ubuntu-specific configurations..."
    
    # Install additional packages that might be needed
    if command_exists apt-get; then
        log_info "Installing additional Ubuntu packages..."
        # Add any Ubuntu-specific package installations here
    fi
}

install_tmux_plugins() {
    print_separator
    log_info "Installing tmux plugins..."
    print_separator
    
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    
    # Check if tmux is installed
    if ! command_exists tmux; then
        log_warning "tmux is not installed, skipping plugin installation"
        return 0
    fi
    
    # Check if TPM already exists
    if [[ -d "$tpm_dir" ]]; then
        log_info "TPM already exists, updating..."
        if cd "$tpm_dir" && git pull origin master; then
            log_success "TPM updated successfully"
        else
            log_error "Failed to update TPM"
            return 1
        fi
    else
        # Install TPM
        if ask_user "Install Tmux Plugin Manager (TPM)?"; then
            log_info "Installing TPM..."
            if git clone https://github.com/tmux-plugins/tpm "$tpm_dir"; then
                log_success "TPM installed successfully"
            else
                log_error "Failed to install TPM"
                return 1
            fi
        else
            log_info "Skipping TPM installation"
            return 0
        fi
    fi
    
    # Install plugins automatically if TPM is available
    if [[ -f "$tpm_dir/bin/install_plugins" ]]; then
        log_info "Installing tmux plugins..."
        if "$tpm_dir/bin/install_plugins"; then
            log_success "Tmux plugins installed successfully"
            
            # Build tmux-fingers binary to avoid runtime compilation
            local fingers_dir="$HOME/.tmux/plugins/tmux-fingers"
            if [[ -d "$fingers_dir" ]]; then
                log_info "Building tmux-fingers binary..."
                if cd "$fingers_dir" && ./scripts/build.sh; then
                    log_success "tmux-fingers binary built successfully"
                else
                    log_warning "Failed to build tmux-fingers binary, it will be built on first use"
                fi
            fi
        else
            log_warning "Some tmux plugins may not have been installed correctly"
        fi
    fi
    
    # Display information about plugin usage
    cat << EOF

📋 Tmux Plugin Manager (TPM) Usage:
   - prefix + I : Install plugins
   - prefix + U : Update plugins
   - prefix + alt + u : Uninstall plugins
   - Default prefix: Ctrl+Space (as configured in .tmux.conf)

💡 Note: tmux-fingers バイナリは事前ビルドされているため、初回起動時のコンパイルは不要です

EOF
}

verify_required_binaries() {
    print_separator
    log_info "Verifying required binaries..."
    print_separator

    if command_exists ghux; then
        log_success "ghux binary found: $(command -v ghux)"
    else
        log_warning "ghux binary not found in PATH"
        cat << EOF

ghux is now expected as a standalone binary.
Install it first, then ensure the install path is included in PATH.

EOF
    fi
}

show_completion() {
    cat << END

$SPACER
🎉 DOTFILES SETUP FINISHED!
$SPACER

Next steps:
1. Restart your terminal or run: source ~/.zshrc
2. Edit ~/.gitconfig.local if you haven't already
3. Review and customize your dotfiles as needed

$SPACER

END
}

# ------------------------------------------------------------------------------
# Main Script
# ------------------------------------------------------------------------------
main() {
    # Change to home directory
    cd "$HOME"
    
    # Show welcome message
    show_welcome
    
    # Execute setup steps
    clone_dotfiles || exit 1
    generate_ssh_key || exit 1
    install_homebrew || exit 1
    create_symlinks || exit 1
    setup_config_directory || exit 1
    install_packages || exit 1
    setup_bin_directory || exit 1
    verify_required_binaries || exit 1
    configure_git || exit 1
    install_tmux_plugins || exit 1
    setup_platform_specific || exit 1
    
    # Show completion message
    show_completion
    
    log_success "Setup completed successfully!"
}

# Run main function
main "$@"
