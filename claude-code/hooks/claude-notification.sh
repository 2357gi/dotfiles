#!/bin/bash

# Claude Code hook script for rich macOS notifications
# This script receives notification events from Claude Code via stdin (JSON format)
# and sends rich macOS notifications with custom icons and context

# Read JSON input from stdin
input=$(cat)

# Parse notification details
notification_type=$(echo "$input" | jq -r '.notification_type // "unknown"')
message=$(echo "$input" | jq -r '.message // "Claude Code needs your input"')
cwd=$(echo "$input" | jq -r '.cwd // ""')

# Extract directory name for display
dir_name=$(basename "$cwd")

# Build rich notification message with context
case "$notification_type" in
    "permission_prompt")
        subtitle="⚠️ 許可が必要です"
        rich_message=$'ツールの実行許可を求めています\n📁 '"$dir_name"
        ;;
    "tool_permission_prompt")
        subtitle="🔧 ツール実行許可"
        rich_message=$'ツールの実行を待っています\n📁 '"$dir_name"
        ;;
    "user_question_prompt")
        subtitle="❓ 質問があります"
        rich_message=$'あなたの回答を待っています\n📁 '"$dir_name"
        ;;
    "idle_prompt")
        subtitle="⏸️ 入力待ち"
        rich_message=$'次の指示を待っています\n📁 '"$dir_name"
        ;;
    *)
        subtitle="[$notification_type]"
        rich_message=$''"$message"$'\n📁 '"$dir_name"
        ;;
esac

# Claude Code icon path
ICON_PATH="$HOME/.claude/icons/claude-ai-icon.png"

# Get tmux environment information
PANE_ID="${TMUX_PANE}"
SESSION_NAME=$(tmux display-message -p '#{session_name}' 2>/dev/null || echo "")
WINDOW_ID=$(tmux display-message -p -t "${TMUX_PANE}" '#{window_id}' 2>/dev/null || echo "")
# Extract tmux socket path from $TMUX variable (format: /path/to/socket,pid,session_id)
TMUX_SOCKET=$(echo "$TMUX" | cut -d',' -f1)

# Detect execution environment
ENVIRONMENT="unknown"

if [ "$CLAUDE_CODE_ENTRYPOINT" = "claude-vscode" ]; then
    ENVIRONMENT="vscode"
    WORKSPACE_PATH="${VSCODE_CWD:-$PWD}"
elif [ -n "$VSCODE_CLI" ]; then
    ENVIRONMENT="vscode"
    WORKSPACE_PATH="${VSCODE_CWD:-$PWD}"
elif [ -n "$PANE_ID" ] && [ -n "$SESSION_NAME" ] && [ -n "$TMUX_SOCKET" ]; then
    ENVIRONMENT="tmux"
else
    ENVIRONMENT="generic"
fi

# Debug logging
if [ -n "$CLAUDE_DEBUG" ]; then
    echo "$(date): environment=$ENVIRONMENT, notification_type=$notification_type, message=$message, workspace=$WORKSPACE_PATH, PANE_ID=$PANE_ID, WINDOW_ID=$WINDOW_ID" >> /tmp/claude-hook-debug.log
fi

# VSCode environment notification
if [ "$ENVIRONMENT" = "vscode" ]; then
    if command -v terminal-notifier >/dev/null 2>&1; then
        terminal-notifier \
            -title "Claude Code" \
            -message "$rich_message" \
            -subtitle "$subtitle" \
            -group "claude-code-vscode" \
            -contentImage "$ICON_PATH" \
            -activate "com.microsoft.VSCode" \
            -execute "$HOME/.claude/hooks/focus-vscode.sh '$WORKSPACE_PATH'"
    else
        osascript -e "display notification \"$rich_message\" with title \"Claude Code\" subtitle \"$subtitle\""
        osascript -e 'tell application "Visual Studio Code" to activate' 2>/dev/null
    fi
    exit 0
fi

# tmux environment notification
if [ "$ENVIRONMENT" = "tmux" ]; then
    terminal-notifier \
        -title "Claude Code" \
        -message "$rich_message" \
        -subtitle "$subtitle" \
        -group "claude-code-$SESSION_NAME-$PANE_ID" \
        -contentImage "$ICON_PATH" \
        -activate "com.apple.Terminal" \
        -execute "$HOME/.claude/hooks/focus-tmux-pane.sh '$SESSION_NAME' '$PANE_ID' '$TMUX_SOCKET' '$WINDOW_ID'"
    exit 0
fi

# Generic fallback - standard macOS notification
if command -v terminal-notifier >/dev/null 2>&1; then
    terminal-notifier \
        -title "Claude Code" \
        -message "$rich_message" \
        -subtitle "$subtitle" \
        -contentImage "$ICON_PATH"
else
    osascript -e "display notification \"$rich_message\" with title \"Claude Code\" subtitle \"$subtitle\""
fi
exit 0
