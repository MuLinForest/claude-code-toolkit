#!/bin/sh
# Claude Code hook: Telegram notification on Bash tool use
# Event: PreToolUse (Bash)
# Sends ⚙️ for normal commands, ⚠️ for high-risk operations

. "$HOME/.claude/hooks/telegram.sh"

command -v jq > /dev/null 2>&1 || exit 0

_input=$(cat)

_tool=$(printf '%s' "$_input" | jq -r '.tool_name // ""')
[ "$_tool" != "Bash" ] && exit 0

_cmd=$(printf '%s' "$_input" | jq -r '.tool_input.command // ""' | cut -c1-200)
[ -z "$_cmd" ] && exit 0

_cmd_escaped=$(_escape_html "$_cmd")

_HIGH_RISK='(^|[[:space:]])(rm|ssh|docker|mkfs|dd)[[:space:]]|reboot|shutdown|DROP TABLE|DROP DATABASE'

if printf '%s' "$_cmd" | grep -qE "$_HIGH_RISK"; then
    send_tg "⚠️ <b>High-risk command</b> — check your terminal

<code>${_cmd_escaped}</code>"
else
    send_tg "⚙️ <b>Claude is running a command</b>

<code>${_cmd_escaped}</code>"
fi

exit 0
