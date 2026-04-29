#!/bin/bash
# VSCode focus handler for Claude Code notifications
# Activates the specific VSCode workspace where Claude Code is running

export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:$PATH"

WORKSPACE_PATH="$1"

# Debug logging
if [ -n "$CLAUDE_DEBUG" ]; then
    echo "$(date): Focusing VSCode workspace: $WORKSPACE_PATH" >> /tmp/claude-hook-debug.log
fi

# If workspace path is provided, open it with code CLI
if [ -n "$WORKSPACE_PATH" ] && [ -d "$WORKSPACE_PATH" ]; then
    if command -v code >/dev/null 2>&1; then
        code "$WORKSPACE_PATH" 2>/dev/null
    fi
fi

# Always activate VSCode (fallback if code command fails)
osascript -e 'tell application "Visual Studio Code" to activate' 2>/dev/null

exit 0
