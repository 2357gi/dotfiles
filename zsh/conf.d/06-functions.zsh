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


# Jiraチケット用ブランチ作成関数
jira_branch() {
  # クリップボードからURLを取得
  local url=$(pbpaste)

  # URLが空の場合はエラー
  if [[ -z "$url" ]]; then
    echo "Error: クリップボードが空です"
    return 1
  fi

  # URLからチケットIDを抽出（/browse/の後の部分）
  local ticket_id=$(echo "$url" | grep -oE '[A-Z]+-[0-9]+')

  # チケットIDが取得できない場合はエラー
  if [[ -z "$ticket_id" ]]; then
    echo "Error: 有効なJiraチケットURLではありません: $url"
    return 1
  fi

  # ブランチ名を生成
  local branch_name="feature/$ticket_id"

  echo "チケットID: $ticket_id"
  echo "ブランチ作成: $branch_name"

  # ブランチを作成して移動
  git checkout -b "$branch_name"
}

# AWS Cost Explorer を専用のChromeプロファイルで開く関数
aws_cost_explorer() {
  local profile="${1:-nealle-sso}"
  local cost_explorer_url="https://us-east-1.console.aws.amazon.com/costmanagement/home#/cost-explorer?chartStyle=STACK&costAggregate=unBlendedCost&endDate=2025-12-24&excludeForecasting=false&filter=%5B%7B%22dimension%22:%7B%22id%22:%22Service%22,%22displayValue%22:%22%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9%22%7D,%22operator%22:%22EXCLUDES%22,%22values%22:%5B%7B%22value%22:%22Tax%22,%22displayValue%22:%22Tax%22%7D,%7B%22value%22:%22AWS%20Support%20(Business)%22,%22displayValue%22:%22Support%20(Business)%22%7D,%7B%22value%22:%22Amazon%20Connect%22,%22displayValue%22:%22Connect%22%7D,%7B%22value%22:%22Contact%20Center%20Telecommunications%20(service%20sold%20by%20AMCS,%20LLC)%22,%22displayValue%22:%22Contact%20Center%20Telecommunications%20(service%20sold%20by%20AMCS,%20LLC)%22%7D,%7B%22value%22:%22Contact%20Center%20Telecommunications%20(service%20sold%20by%20AMCS,%20LLC)%20%22,%22displayValue%22:%22Contact%20Center%20Telecommunications%20(service%20sold%20by%20AMCS,%20LLC)%22%7D%5D%7D,%7B%22dimension%22:%7B%22id%22:%22PurchaseType%22,%22displayValue%22:%22%E8%B3%BC%E5%85%A5%E3%82%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3%22%7D,%22operator%22:%22EXCLUDES%22,%22values%22:%5B%7B%22value%22:%22Standard%20Reserved%20Instances%22,%22displayValue%22:%22Reserved%22%7D,%7B%22value%22:%22Savings%20Plans%22,%22displayValue%22:%22Savings%20Plans%22%7D%5D%7D%5D&futureRelativeRange=CUSTOM&granularity=Daily&groupBy=%5B%22Service%22%5D&historicalRelativeRange=MONTH_TO_DATE&isDefault=false&reportArn=arn:aws:ce::006080634847:ce-saved-report%2F0c00dbcf-c987-43ec-9fc2-702b7babbc94&reportId=0c00dbcf-c987-43ec-9fc2-702b7babbc94&reportMode=STANDARD&reportName=Daily&showOnlyUncategorized=false&showOnlyUntagged=false&startDate=2025-12-01&usageAggregate=undefined&useNormalizedUnits=false"

  echo "AWS SSOプロファイル: $profile"
  echo "ログインURLを取得中..."

  # AWS SSOログインURLを取得
  local login_url=$(aws sso login --profile "$profile" --no-browser 2>&1 | grep -oE 'https://[^ ]+')

  if [[ -z "$login_url" ]]; then
    echo "Error: ログインURLの取得に失敗しました"
    return 1
  fi

  echo "専用のChromeプロファイルで開いています..."

  # まずログインURLを開き、その後Cost ExplorerのURLを開く
  open -na "Google Chrome" --args --user-data-dir=$HOME/Library/Application\ Support/Google/Chrome/aws-cost-explorer/$profile "$login_url" "$cost_explorer_url"
}

# AWS Vault Login with fzf profile selector
aws_login() {
  # ~/.aws/configから*-sso, *-no-sessionを除外してプロファイル名を抽出
  local profile=$(grep '^\[profile ' ~/.aws/config | \
    sed 's/^\[profile \(.*\)\]/\1/' | \
    grep -v -e '-sso$' -e '-no-session$' | \
    fzf --prompt="AWS Profile > " \
        --height=40% \
        --border \
        --preview="echo 'Profile: {}' && grep -A5 '^\[profile {}\]' ~/.aws/config | tail -n +2")

  # プロファイルが選択されなかった場合は終了
  if [[ -z "$profile" ]]; then
    echo "No profile selected."
    return 1
  fi

  echo "Selected profile: $profile"
  echo "Opening browser for aws-vault login..."

  # aws-vault loginを実行
  aws-vault login "$profile"
}
