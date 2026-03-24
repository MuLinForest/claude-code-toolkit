#!/bin/sh
# Claude Code hook: Append session summary to daily draft
# Event: Stop
# Accumulates session summaries in ~/.claude/daily-draft.md throughout the day.
# Run daily-log-publish.sh via cron to consolidate and store the log.

command -v jq > /dev/null 2>&1 || exit 0

_input=$(cat)

_active=$(printf '%s' "$_input" | jq -r '.stop_hook_active // false')
[ "$_active" = "true" ] && exit 0

_draft="$HOME/.claude/daily-draft.md"
_now=$(date '+%H:%M')

_summary=$(printf '%s' "$_input" | jq -r '.last_assistant_message // ""' | cut -c1-300)
[ -z "$_summary" ] && exit 0

printf '\n## Session @ %s\n%s\n' "$_now" "$_summary" >> "$_draft"

exit 0
