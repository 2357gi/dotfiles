#!/bin/zsh

if [[ -z "$FILTER" ]]; then
    FILTER=$(git config --global aux.filter)
    FILTER=${FILTER:-fzf}
fi

ask_yn() {
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
test_repo_is_clean() {
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

test_no_unpushed_commits() {
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

rm_each_repo() {
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

ghq_unset() {
    rm_each_repo 3 3< <( ghq list -p | "$FILTER" )
}

