# ------------------------------------------------------------------------------
# Prompt Settings
# ------------------------------------------------------------------------------

# Git status display function (unified)
update_git_info() {
    if [ ! -z $TMUX ]; then
        tmux refresh-client -S
    else
        dir="%F{cyan} %~ %f"
        if git_status=$(git status 2>/dev/null ); then
            git_branch="$(echo $git_status| awk 'NR==1 {print $3}')"
            case $git_status in
                *Changes\ not\ staged* ) state=$'%{\e[30;48;5;013m%}%F{black} ± %f%k' ;;
                *Changes\ to\ be\ committed* ) state="%K{blue}%F{black} + %k%f" ;;
                * ) state="%K{green}%F{black} ✔ %f%k" ;;
            esac
            if [[ $git_branch = "master" ]]; then
                git_info="%F{blue} ${git_branch}%f ${state}"
            else
                git_info=" ${git_branch}%f ${state}"
            fi
        else
            git_info=""
        fi
    fi
}

# Hook functions
precmd() {
    [ $(whoami) = "root" ] && root="%F{yellow} %f|" || root=""
    update_git_info
}

chpwd() {
    update_git_info
}

# VCS info configuration
autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '!'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:*' formats ' %c%u(%s:%b)'
zstyle ':vcs_info:*' actionformats ' %c%u(%s:%b|%a)'

precmd_prompt() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd precmd_prompt

# Color function
set_color() {
    if [[ $? -eq 0 ]]; then
        echo green
    else
        echo red
    fi
}

# Prompt configuration
if [ -z $TMUX ]; then
    PROMPT=$'%(?,,%F{red} ✘%f %f|)${root}${dir} ${git_info}
%F{cyan} > %f'
else
    PROMPT=$'%(?,,%F{red}%K{black} ✘%f %f|%k)${root}${dir}%K{black}%F{cyan} > %f%k'
fi

PROMPT2='%F{cyan}» %f'
RPROMPT="%*"
SPROMPT='zsh: correct? %F{red}%R%f -> %F{green}%r%f [y/n]:'
