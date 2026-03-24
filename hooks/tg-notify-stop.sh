#!/bin/sh
# Claude Code hook: Telegram notification on session stop
# Event: Stop
# Sends ✅ with a brief summary of what Claude just did

. "$HOME/.claude/hooks/telegram.sh"

command -v jq > /dev/null 2>&1 || exit 0

_input=$(cat)

_active=$(printf '%s' "$_input" | jq -r '.stop_hook_active // false')
[ "$_active" = "true" ] && exit 0

_summary=$(printf '%s' "$_input" | jq -r '.last_assistant_message // ""' | cut -c1-300)
[ -z "$_summary" ] && exit 0

_summary_escaped=$(_escape_html "$_summary")

send_tg "✅ <b>Claude finished</b>

${_summary_escaped}"

exit 0
