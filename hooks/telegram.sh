#!/bin/sh
# Telegram helper — sourced by tg-notify hooks
# Loads TG_TOKEN and TG_CHAT_ID from ~/.claude/.env

[ -f "$HOME/.claude/.env" ] && . "$HOME/.claude/.env"

_escape_html() {
    printf '%s' "$1" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'
}

send_tg() {
    [ -z "$TG_TOKEN" ] || [ -z "$TG_CHAT_ID" ] && return 0
    command -v curl > /dev/null 2>&1 || return 0
    curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
        --max-time 10 --connect-timeout 5 \
        -d "chat_id=${TG_CHAT_ID}" \
        -d "parse_mode=HTML" \
        --data-urlencode "text=$1" \
        > /dev/null 2>&1 &
}
