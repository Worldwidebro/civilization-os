#!/usr/bin/env bash
# post-bash-logger.sh
# Appends every Bash command to the session log after execution.

LOG_FILE="${HOME}/Documents/Civilization OS/logs/civilization-os-automation.log"
mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null || true

INPUT=$(cat)
CMD=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('command','')[:200])" 2>/dev/null || echo "(unknown)")

echo "[$(date '+%Y-%m-%d %H:%M:%S')] claude-code | $CMD" >> "$LOG_FILE"
