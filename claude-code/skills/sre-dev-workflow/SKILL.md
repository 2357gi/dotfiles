---
name: sre-dev-workflow
description: "SREチームの標準開発フロー。Jiraチケット起票（タスク＋内部テスト）、worktreeでのfeatureブランチ開発、PR作成、CodeRabbitレビュー対応までを一気通貫で実行。以下の場合に使用: (1) Slackやissueを元に修正タスクを実施する場合、(2) SREボードにチケットを起票して開発する場合、(3) PRを作成してCodeRabbitレビューまで完了させる場合。"
tools: mcp__claude_ai_Atlassian__createJiraIssue, mcp__claude_ai_Atlassian__editJiraIssue, mcp__claude_ai_Atlassian__createIssueLink, mcp__claude_ai_Atlassian__getTransitionsForJiraIssue, mcp__claude_ai_Atlassian__transitionJiraIssue, mcp__claude_ai_Atlassian__lookupJiraAccountId, mcp__claude_ai_Atlassian__getVisibleJiraProjects, mcp__claude_ai_Atlassian__getIssueLinkTypes, mcp__claude_ai_Slack__slack_read_thread, mcp__claude_ai_Slack__slack_read_channel, Bash, Read, Write, Edit, Glob, Grep, Agent, EnterWorktree
---

# SRE Dev Workflow

SREチームの標準開発フローを一気通貫で実行するスキル。

## 概要

Slackでの議論やissueを起点に、以下のフローを自動実行する:

1. **Jiraチケット起票** (タスク + 内部テスト)
2. **worktreeでfeatureブランチ作成・開発**
3. **PR作成** (develop or master向け)
4. **CI確認・修正** (CIがすべてpassするまでが責務)
5. **CodeRabbitレビュー対応**
6. **Jiraチケットステータス遷移**

## 前提条件

### Atlassian MCP
- Slack MCP、Atlassian MCPが接続されていること

### Jira プロジェクト情報
| 項目 | 値 |
|------|-----|
| Cloud ID | `nealle.atlassian.net` |
| プロジェクト | SRE (key: `SRE`, id: `10050`) |
| タスク issue type | `タスク` (id: `10177`) |
| 内部テスト issue type | `内部テスト` (id: `10744`) |
| リンクタイプ | `関連タスク` (id: `10207`) |

### Jira ワークフロー遷移
#### タスクチケット
```
To Do → (id:2 タスク着手) → TEST DESIGN → (id:13 テスト設計完了) → 進行中 → (id:8 レビュー依頼) → レビュー中 → (id:7 受け入れ依頼) → 受け入れ確認 → (id:10 完了) → 完了
```
- `id:12 テストスキップで着手` で To Do → 進行中 に直接遷移も可能
- `id:6 対応不要` でどこからでも対応不要に遷移可能

#### 内部テストチケット
```
To Do → (id:2 テスト着手) → 進行中 → (id:8 レビュー依頼) → レビュー待ち
```

### ブランチ命名規則
- `feature/SRE-XXXX` (XXXXはJiraチケット番号)

## ワークフロー

### Phase 1: 情報収集

ユーザーから以下を確認（またはSlack/issueから取得）:
- **修正内容**: 何をどう変更するか
- **背景/経緯**: なぜこの変更が必要か
- **担当者**: Jiraチケットの担当者（デフォルト: ユーザー自身）
- **PRのベースブランチ**: `develop` or `master`（デフォルト: `develop`）

Slackスレッドが提供された場合:
1. `slack_read_thread` でスレッド内容を取得
2. 議論内容から修正要件を抽出

### Phase 2: Jiraチケット起票

#### 2-1. 担当者のアカウントID取得
```
lookupJiraAccountId(cloudId: "nealle.atlassian.net", searchString: "担当者名")
```

#### 2-2. タスクチケット作成
```
createJiraIssue(
  cloudId: "nealle.atlassian.net",
  projectKey: "SRE",
  issueTypeName: "タスク",
  summary: "修正内容の要約",
  assignee_account_id: "取得したaccountId",
  description: "## 背景\n...\n## 作業内容\n...",
  contentFormat: "markdown"
)
```

#### 2-3. 内部テストチケット作成
テスト項目は以下の構成で記載:

```markdown
## 関連タスク
SRE-XXXX: タスクの概要

## PR
(後で更新)

---

## テストケース

| 項目 | 確認 | 証跡 |
|------|------|------|
| テスト項目1 | - | - |
| テスト項目2 | - | - |

---

## 本番動作検証

| 項目 | 確認 | 証跡 |
|------|------|------|
| merge後の検証項目1 | - | - |
| merge後の検証項目2 | - | - |
```

**重要**: 
- 「テストケース」にはmerge前にローカルやCIで確認できる項目を記載。証跡には実際のログ出力を貼り付ける。
- 「本番動作検証」にはmerge後やインフラ設定変更など、本番環境での確認が必要な項目を記載。

#### 2-4. チケット間リンク作成
```
createIssueLink(
  cloudId: "nealle.atlassian.net",
  inwardIssue: "SRE-XXXX",  // タスクチケット
  outwardIssue: "SRE-YYYY",  // テストチケット
  type: "関連タスク"
)
```

### Phase 3: worktreeでfeatureブランチ開発

#### 3-1. worktree作成
```
EnterWorktree(name: "feature/SRE-XXXX")
```

#### 3-2. featureブランチ作成
```bash
git checkout -b feature/SRE-XXXX origin/{base_branch}
```

#### 3-3. 実装・テスト
- コード変更を実施
- ローカルで動作確認（テストケースに沿って正常系・異常系を検証）
- テスト結果のログを記録

#### 3-4. コミット
```bash
git add {変更ファイル}
git commit -m "$(cat <<'EOF'
SRE-XXXX 変更の要約

変更の詳細説明。

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
EOF
)"
```

### Phase 4: PR作成

#### 4-1. push & PR作成
```bash
git push -u origin feature/SRE-XXXX
gh pr create --base {base_branch} --title "SRE-XXXX 変更の要約" --body "..."
```

PR bodyのテンプレート:
```markdown
## Summary
- 変更点1
- 変更点2

## 背景
変更の背景と経緯。

## Jira
- タスク: https://nealle.atlassian.net/browse/SRE-XXXX
- 内部テスト: https://nealle.atlassian.net/browse/SRE-YYYY

## Test plan
- [x] 完了したテスト
- [ ] 未完了のテスト

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

**重要**: Jiraセクションには必ずタスクチケットと内部テストチケットの**両方のURL**を記載すること。片方だけでは不可。

#### 4-2. テストチケット更新
PR URLと実際のテスト結果ログを内部テストチケットに反映。

### Phase 5: CI確認・修正

PR作成後、CIが通ることを確認する。**CIが通るまでが責務**。

#### 5-1. CIステータス確認
```bash
gh pr checks {PR番号}
```

CIが実行中の場合は `run_in_background: true` でポーリング:
```bash
for i in $(seq 1 20); do
  sleep 30
  RESULT=$(gh pr checks {PR番号} 2>&1)
  echo "=== Attempt $i $(date +%H:%M:%S) ==="
  echo "$RESULT"
  if ! echo "$RESULT" | grep -q "pending\|queued\|in_progress"; then
    echo "CI FINISHED"
    break
  fi
done
```

#### 5-2. CI失敗時の対応
失敗したジョブのログを確認:
```bash
# 失敗したrunのIDを取得
gh pr checks {PR番号}

# ログからエラー箇所を特定
gh run view {run_id} --log 2>/dev/null | grep -i -E "(error|Error|ERROR)" | head -30

# 詳細なエラーコンテキストを取得
gh run view {run_id} --log 2>/dev/null | grep -A 15 "Error:" | head -50
```

エラーを修正し、追加コミット → push → 再度CIを確認。CIがすべてpassするまで繰り返す。

### Phase 6: CodeRabbitレビュー

#### 6-1. ラベル追加 & レビュートリガー
```bash
gh pr edit {PR番号} --add-label "review:CodeRabbit"
```

レビューが自動開始されない場合:
```bash
gh pr comment {PR番号} --body "@coderabbitai review"
```

#### 6-2. レビュー完了待ち
CodeRabbitの最初のサマリコメント（`summarize by coderabbit.ai` を含むコメント）のIDを特定し、ポーリングする:

```bash
# サマリコメントIDの特定
gh pr view {PR番号} --json comments --jq '.comments[] | select(.author.login == "coderabbitai") | select(.body | test("summarize by coderabbit.ai")) | .id' | head -1

# ポーリング（15秒間隔、最大3分）
COMMENT_ID={取得したID}
for i in $(seq 1 12); do
  sleep 15
  STATUS=$(gh api repos/{owner}/{repo}/issues/comments/${COMMENT_ID} --jq '.body' | head -5)
  echo "=== $(date +%H:%M:%S) ==="
  echo "$STATUS"
  if ! echo "$STATUS" | grep -q "Currently processing"; then
    echo "REVIEW COMPLETE"
    break
  fi
done
```

**注意**: ポーリングは `run_in_background: true` で実行すること。

#### 6-3. レビューコメント確認
```bash
# レビュー本文（サマリ + 指摘）
gh api repos/{owner}/{repo}/pulls/{PR番号}/reviews --jq '.[] | select(.user.login == "coderabbitai[bot]") | .body'

# インラインコメント
gh api repos/{owner}/{repo}/pulls/{PR番号}/comments --jq '.[] | "Path: \(.path)\nLine: \(.line)\n\(.body)\n---"'
```

#### 6-4. 指摘対応
- 妥当な指摘: コードを修正し、追加コミット → push
- 不要な指摘: PRコメントで理由を説明

対応後、**各インラインコメントに個別に返信する**（PRコメントではなく、各コメントのスレッドに返信）:
```bash
# インラインコメントのIDを取得
gh api repos/{owner}/{repo}/pulls/{PR番号}/comments --jq '.[] | select(.user.login == "coderabbitai[bot]") | {id: .id, path: .path, line: .line, body: (.body | split("\n") | first)}'

# 各コメントに対して返信（comment_idは上で取得したID）
gh api repos/{owner}/{repo}/pulls/{PR番号}/comments/{comment_id}/replies -f body="対応しました ({commit_hash})。修正内容の説明。"
```

**重要**: `gh pr comment` はPR全体へのコメント。インラインコメントへの返信は `gh api .../comments/{id}/replies` を使うこと。対応内容を具体的に書くことで、レビュアーが再確認しやすくなる。

### Phase 7: Jiraチケットステータス遷移

開発フローの進行に合わせてステータスを遷移:

| タイミング | タスクチケット | テストチケット |
|-----------|--------------|--------------|
| チケット起票時 | To Do | To Do |
| テスト設計完了時 | To Do → TEST DESIGN → 進行中 | To Do → 進行中 |
| PR作成・レビュー依頼時 | 進行中 → レビュー中 | 進行中 → レビュー待ち |

遷移には `getTransitionsForJiraIssue` で利用可能な遷移IDを確認してから `transitionJiraIssue` を実行する。

## park-direct-backend 固有の情報

### リポジトリ
- GitHub: `nealle/park-direct-backend`
- メインブランチ: `develop` (PRのデフォルトベース)
- リリースブランチ: `master`

### CodeRabbitの設定
- `review:CodeRabbit` ラベルでレビュー対象に含まれる
- `wip`, `do-not-review` ラベルでレビュー除外
- 設定ファイル: `.coderabbit.yaml`

### CI (GitHub Actions)
- PRワークフロー: `pull-request-for-develop.yaml`, `pull-request-for-master.yaml`, `pull-request-for-staging.yaml`
- DB/S3向き先チェック: `check-db-and-s3-direction.yaml`

### テスト実行
```bash
python manage.py test apps.{target} --settings='parking.no_db_settings' --parallel 4
```
