#!/usr/bin/env bash
# check-connections.sh
# Civilization OS — Validate all critical connections before agent operations
# Usage: bash scripts/check-connections.sh
# Requires: SUPABASE_SERVICE_KEY, GITHUB_TOKEN (or gh CLI auth)

set -euo pipefail

SUPABASE_PROJECT="cyhzilqldouzgynacqpe"
SUPABASE_URL="https://${SUPABASE_PROJECT}.supabase.co"
VENTURE_HUB_URL="https://venture-hub-pi.vercel.app"
OPENCLAW_PORT=3333
OPENCLAW_HOST="${OPENCLAW_HOST:-localhost}"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

pass() { echo -e "${GREEN}[PASS]${NC} $1"; }
fail() { echo -e "${RED}[FAIL]${NC} $1"; FAILURES=$((FAILURES + 1)); }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

FAILURES=0

echo "=============================================="
echo " Civilization OS — Connection Health Check"
echo " $(date '+%Y-%m-%d %H:%M:%S')"
echo "=============================================="
echo ""

# ──────────────────────────────────────────────
# 1. ENV VARS
# ──────────────────────────────────────────────
echo "[ 1/4 ] Checking environment variables..."

if [[ -z "${SUPABASE_SERVICE_KEY:-}" ]]; then
  fail "SUPABASE_SERVICE_KEY is not set — load from Bitwarden before running agents"
else
  pass "SUPABASE_SERVICE_KEY is set"
fi

if command -v gh &>/dev/null && gh auth status &>/dev/null 2>&1; then
  pass "GitHub CLI (gh) authenticated"
elif [[ -n "${GITHUB_TOKEN:-}" ]]; then
  pass "GITHUB_TOKEN is set"
else
  fail "GitHub: neither 'gh' CLI authenticated nor GITHUB_TOKEN set"
fi

echo ""

# ──────────────────────────────────────────────
# 2. SUPABASE
# ──────────────────────────────────────────────
echo "[ 2/4 ] Checking Supabase connection..."

if [[ -z "${SUPABASE_SERVICE_KEY:-}" ]]; then
  warn "Skipping Supabase query — SUPABASE_SERVICE_KEY not set"
else
  HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    "${SUPABASE_URL}/rest/v1/business_ventures?select=count&limit=1" \
    -H "apikey: ${SUPABASE_SERVICE_KEY}" \
    -H "Authorization: Bearer ${SUPABASE_SERVICE_KEY}" \
    --max-time 10 2>/dev/null || echo "000")

  if [[ "$HTTP_STATUS" == "200" ]]; then
    pass "Supabase REST API reachable (${SUPABASE_URL})"

    # Verify venture count
    VENTURE_COUNT=$(curl -s \
      "${SUPABASE_URL}/rest/v1/business_ventures?select=count" \
      -H "apikey: ${SUPABASE_SERVICE_KEY}" \
      -H "Authorization: Bearer ${SUPABASE_SERVICE_KEY}" \
      -H "Prefer: count=exact" \
      -I --max-time 10 2>/dev/null \
      | grep -i "content-range" | grep -oE '[0-9]+$' || echo "unknown")
    pass "business_ventures row count: ${VENTURE_COUNT}"

    # Verify aoc_tasks queue
    TASK_STATUS=$(curl -s \
      "${SUPABASE_URL}/rest/v1/aoc_tasks?select=status&status=eq.pending&limit=1" \
      -H "apikey: ${SUPABASE_SERVICE_KEY}" \
      -H "Authorization: Bearer ${SUPABASE_SERVICE_KEY}" \
      --max-time 10 2>/dev/null | head -c 50)
    if echo "$TASK_STATUS" | grep -q "pending"; then
      pass "aoc_tasks queue has pending tasks (agent work available)"
    else
      warn "aoc_tasks: no pending tasks found (queue may be empty or exhausted)"
    fi
  elif [[ "$HTTP_STATUS" == "000" ]]; then
    fail "Supabase unreachable — check network/VPN"
  elif [[ "$HTTP_STATUS" == "401" ]]; then
    fail "Supabase auth failed (HTTP 401) — SUPABASE_SERVICE_KEY may be wrong"
  else
    fail "Supabase returned unexpected HTTP ${HTTP_STATUS}"
  fi
fi

echo ""

# ──────────────────────────────────────────────
# 3. GITHUB
# ──────────────────────────────────────────────
echo "[ 3/4 ] Checking GitHub connection..."

if command -v gh &>/dev/null && gh auth status &>/dev/null 2>&1; then
  GITHUB_USER=$(gh api user --jq '.login' 2>/dev/null || echo "unknown")
  pass "GitHub authenticated as: ${GITHUB_USER}"

  REPO_COUNT=$(gh repo list Worldwidebro --limit 1 --json name 2>/dev/null | grep -c "name" || echo "0")
  if [[ "$REPO_COUNT" -gt 0 ]]; then
    pass "GitHub org Worldwidebro repos accessible"
  else
    warn "Could not list Worldwidebro repos — check org permissions"
  fi
elif [[ -n "${GITHUB_TOKEN:-}" ]]; then
  HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    "https://api.github.com/user" \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    --max-time 10 2>/dev/null || echo "000")
  if [[ "$HTTP_STATUS" == "200" ]]; then
    pass "GitHub API reachable via GITHUB_TOKEN"
  else
    fail "GitHub API returned HTTP ${HTTP_STATUS} — token may be invalid or expired"
  fi
else
  warn "Skipping GitHub API check — no auth available"
fi

echo ""

# ──────────────────────────────────────────────
# 4. OPENCLAW GATEWAY (Mac Studio)
# ──────────────────────────────────────────────
echo "[ 4/4 ] Checking OpenClaw Gateway..."

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  "http://${OPENCLAW_HOST}:${OPENCLAW_PORT}/" \
  --max-time 5 2>/dev/null || echo "000")

if [[ "$HTTP_STATUS" == "200" || "$HTTP_STATUS" == "404" ]]; then
  pass "OpenClaw Gateway is running at ${OPENCLAW_HOST}:${OPENCLAW_PORT}"
elif [[ "$HTTP_STATUS" == "000" ]]; then
  fail "OpenClaw Gateway not reachable at ${OPENCLAW_HOST}:${OPENCLAW_PORT}"
  echo "       To start: ssh mac-studio → tmux new -s openclaw"
  echo "       → export SUPABASE_SERVICE_KEY=<from bitwarden>"
  echo "       → bash ~/Iza-OS-Tree-of-Life/venture-hub/scripts/openclaw-gateway.sh"
else
  warn "OpenClaw Gateway returned HTTP ${HTTP_STATUS} — may need inspection"
fi

echo ""

# ──────────────────────────────────────────────
# BONUS: venture-hub (Vercel)
# ──────────────────────────────────────────────
echo "[ BONUS ] Checking venture-hub (Vercel)..."

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  "${VENTURE_HUB_URL}/api/ventures" \
  --max-time 10 2>/dev/null || echo "000")

if [[ "$HTTP_STATUS" == "200" ]]; then
  pass "venture-hub API is live at ${VENTURE_HUB_URL}/api/ventures"
elif [[ "$HTTP_STATUS" == "000" ]]; then
  fail "venture-hub unreachable — check Vercel deployment"
else
  warn "venture-hub returned HTTP ${HTTP_STATUS}"
fi

echo ""
echo "=============================================="
if [[ "$FAILURES" -eq 0 ]]; then
  echo -e "${GREEN} ALL CONNECTIONS OK — Ready to run agents${NC}"
else
  echo -e "${RED} ${FAILURES} connection(s) FAILED — Fix before running agents${NC}"
fi
echo "=============================================="

exit "$FAILURES"
