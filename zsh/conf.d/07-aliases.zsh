# ------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------

# Global aliases
alias -g @f="| fzf"
alias -g @g="| rg -n"
alias -g @l="|less -R"
alias -g @x="| xargs"
alias -g @tf="&& echo True || echo False"
alias -g @X11='-e DISPLAY=localhost:0 -v ~/.Xauthority:/root/.Xauthority'

# Platform-specific global aliases
if is_osx; then
    alias -g @p="| pbcopy"
    alias -g C="| pbcopy"
elif is_ubuntu; then
    alias -g @p="| xclip -selection clipboard"
    alias -g C="| xclip -selection clipboard"
fi

# Additional global aliases
alias -g A='| awk'
alias -g CC='| wc -l'  # count lines (renamed from C to avoid conflict)
alias -g H='| head'
alias -g T='| tail'

# Common aliases
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias ..='cd ..'
alias vi='vim'
alias vif='vim $(fzf)'
alias :q='exit'
alias p='pwd'
alias df='df -h'
alias c_='cd $_'
alias .z='source ~/.zshrc && clear'

# Platform-specific file listing
if is_osx; then
    alias ls='ls -GF'
    alias ll='ls -alG'
elif is_ubuntu; then
    alias ls='ls --color=auto -F'
    alias ll='ls -al --color=auto'
fi

# Platform-specific copy command
if is_osx; then
    alias c='pbcopy'
    alias rm='gomi'
elif is_ubuntu; then
    alias c='xclip -selection clipboard'
fi

# Git aliases
alias g='git'
alias gs='git status --short --branch'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'

# Docker aliases
alias d='docker'
alias drn="docker run -it --rm"
alias db="DOCKER_BUILDKIT=1 docker build"
alias dps="docker ps --format \"table {{.Names}} {{.ID}} {{.Status}}\""
alias dpsa="docker ps -a --format \"table {{.Names}} {{.ID}} {{.Status}}\""
alias fig='docker-compose'

# Kubernetes aliases
alias k='kubectl'

# Other aliases
alias dtf="tmux switch-client -t dotfiles"

# Platform-specific notification
if is_osx; then
    alias noti='terminal-notifier -message "コマンド完了"'
elif is_ubuntu; then
    alias noti='notify-send "コマンド完了"'
fi

avl(){ open -na "Google Chrome" --args --incognito --user-data-dir=$HOME/Library/Application\ Support/Google/Chrome/aws-vault/$@ $(aws-vault login $@ --stdout) }

alias jb='jira_branch'
alias ace='aws_cost_explorer'
