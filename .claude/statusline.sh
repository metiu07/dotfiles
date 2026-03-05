#!/bin/bash
# https://code.claude.com/docs/en/statusline
#
# ~/.claude/settings.json
# {
#   "statusLine": {
#     "type": "command",
#     "command": "~/.claude/statusline.sh",
#     "padding": 2
#   }
# }
#
# Read JSON input from stdin
input=$(cat)

# Extract values using jq
MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd')

printf "[$MODEL_DISPLAY] 📁 ${CURRENT_DIR##*/} | 💰 \$%.2f\n" "$COST"
