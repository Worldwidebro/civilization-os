#!/usr/bin/env bash
# pre-bash-secret-scan.sh
# Runs before every Bash tool use — blocks commits/pushes that contain secrets.
# Claude Code passes the tool input as JSON on stdin.

INPUT=$(cat)

# Only scan git commit/push commands
if echo "$INPUT" | grep -qE '"(git commit|git push)"'; then
  STAGED=$(git -C "${GIT_DIR:-.}" diff --cached 2>/dev/null || true)
  if echo "$STAGED" | grep -qiE "(SUPABASE_SERVICE_KEY|api[_-]?key|secret|password|token|private_key)" ; then
    echo '{"decision":"block","reason":"Secret detected in staged changes. Remove it and store in Bitwarden before committing."}'
    exit 0
  fi
fi

echo '{"decision":"allow"}'
