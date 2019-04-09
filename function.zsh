function ggrep() {
    if [[ -z $1 ]]; then
        echo "too few argument" >&2
        return 1
    fi

    res=$(
    git grep --color "$1" \
        | fzf --height 40 --reverse --multi --ansi \
        | awk -F: '{print $1}'
    )

    if [[ -z $res ]]; then
        return 0
    fi
    vim -p $res
}
