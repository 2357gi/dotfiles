# ------------------------------------------------------------------------------
# Custom Functions
# ------------------------------------------------------------------------------

# Git branch selector with fzf
fbr() {
    local branches branch
    branches=$(git branch -vv) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# Remote git branch selector with fzf
frbr() {
    local branches branch
    branches=$(git branch --all | grep -v HEAD) &&
    branch=$(echo "$branches" |
    fzf -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# Git commit browser
fshow() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# ghq repository unset function
ghq_unset() {
    local filter
    if [[ -z "$FILTER" ]]; then
        filter=$(git config --global aux.filter)
        filter=${filter:-fzf}
    else
        filter="$FILTER"
    fi

    local ask_yn() {
        local msg=$1
        local yn
        while read -r yn\?"$msg [yN] "; do
            case "$yn" in
                [Yy]*) return 0 ;;
                [Nn]*) return 1 ;;
                "")    return 1 ;;
            esac
        done
    }

    local test_repo_is_clean() {
        local msg
        msg=$(git -c status.color=always status --short)
        if [[ $? = 0 && -z "$msg" ]]; then
            return 0
        else
            printf "\e[31mThe repository is dirty:\e[0m\n"
            echo
            sed 's/^/    /' <<< "$msg"
            echo
            return 1
        fi
    }

    local test_no_unpushed_commits() {
        local msg
        msg=$(git log --branches --not --remotes --simplify-by-decoration --decorate --oneline --color=always)
        if [[ $? = 0 && -z "$msg" ]]; then
            return 0
        else
            printf "\e[31mThere are unpushed commits:\e[0m\n"
            echo
            sed 's/^/    /' <<< "$msg"
            echo
            return 1
        fi
    }

    local rm_each_repo() {
        local fd=$1
        local repo_path
        local ret
        while read -u "$fd" -r repo_path; do
            printf "\e[1;34m> %s\e[0m\n" "$repo_path"
            (
                cd "$repo_path"
                ret=0
                test_repo_is_clean
                ret=$(( ret + $? ))
                test_no_unpushed_commits
                ret=$(( ret + $? ))
                if ask_yn "Are you sure you want to remove it?"; then
                    rm -rf "$repo_path"
                fi
            )
        done
    }

    rm_each_repo 3 3< <( ghq list -p | "$filter" --preview="")
}