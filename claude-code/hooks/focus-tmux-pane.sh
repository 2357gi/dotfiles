#!/bin/bash

# Focus handler script for tmux pane notifications
# This script is executed when a user clicks on a Claude Code notification
# It activates Terminal.app and focuses the specific tmux session/pane

# Set PATH to ensure tmux is found
export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:$PATH"

SESSION_NAME="$1"
PANE_ID="$2"
TMUX_SOCKET="$3"
WINDOW_ID="$4"

# Debug logging (uncomment for troubleshooting)
# echo "$(date): Focusing SESSION_NAME=$SESSION_NAME, PANE_ID=$PANE_ID, TMUX_SOCKET=$TMUX_SOCKET" >> /tmp/claude-hook-debug.log
# echo "$(date): PATH=$PATH" >> /tmp/claude-hook-debug.log
# echo "$(date): tmux location: $(which tmux)" >> /tmp/claude-hook-debug.log

if [ -n "$SESSION_NAME" ] && [ -n "$PANE_ID" ] && [ -n "$TMUX_SOCKET" ]; then
    # Use the tmux socket to connect to the server
    # Get all tmux clients and switch each one
    clients=$(tmux -S "$TMUX_SOCKET" list-clients -F '#{client_tty}' 2>&1)

    if [ -n "$clients" ] && [ "$clients" != "error"* ]; then
        echo "$clients" | while read -r client_tty; do
            # Switch the client to the target session
            tmux -S "$TMUX_SOCKET" switch-client -t "$SESSION_NAME" -c "$client_tty" 2>/dev/null
            # Select the target window, then the target pane
            if [ -n "$WINDOW_ID" ]; then
                tmux -S "$TMUX_SOCKET" select-window -t "$WINDOW_ID" 2>/dev/null
            fi
            tmux -S "$TMUX_SOCKET" select-pane -t "$PANE_ID" 2>/dev/null
        done
    fi

    # Activate Terminal.app
    osascript -e 'tell application "Terminal" to activate' 2>/dev/null
else
    osascript -e 'tell application "Terminal" to activate' 2>/dev/null
fi

exit 0
