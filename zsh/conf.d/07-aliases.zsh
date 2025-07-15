# ------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------

# Global aliases
alias -g @f="| fzf"
alias -g @g="| rg -n"
alias -g @l="|less -R"
alias -g @x="| xargs"
alias -g @p="| pbcopy"
alias -g @tf="&& echo True || echo False"
alias -g @X11='-e DISPLAY=localhost:0 -v ~/.Xauthority:/root/.Xauthority'

# Load external aliases
if [ -f ~/.aliases.sh ]; then
    . ~/.aliases.sh
fi