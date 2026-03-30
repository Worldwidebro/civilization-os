#!/usr/bin/env bash
# session-summary.sh
# Fires when Claude Code stops — prints a brief summary of what happened.

LOG_FILE="${HOME}/Documents/Civilization OS/logs/civilization-os-automation.log"

echo ""
echo "══════════════════════════════════════════"
echo " Civilization OS — Session Ended $(date '+%H:%M:%S')"
echo "══════════════════════════════════════════"

if [[ -f "$LOG_FILE" ]]; then
  echo "Last 5 commands logged:"
  tail -5 "$LOG_FILE" | sed 's/^/  /'
fi

echo ""
echo "Reminder: mark tasks complete in aoc_tasks if not already done:"
echo "  UPDATE aoc_tasks SET status='success', completed_at=now() WHERE id='...';"
echo "══════════════════════════════════════════"
