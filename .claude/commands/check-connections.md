# /check-connections

Run the Civilization OS connection health check and report status of all systems.

## Steps

1. Run the health check script:
```bash
SUPABASE_SERVICE_KEY="${SUPABASE_SERVICE_KEY}" bash scripts/check-connections.sh
```

2. Parse the output and summarize:
   - ✅ PASS / ❌ FAIL / ⚠️ WARN for each connection
   - Supabase (REST API + venture count + task queue)
   - GitHub (auth + org access)
   - OpenClaw Gateway (port 3333)
   - venture-hub Vercel API

3. If any FAILs:
   - For missing `SUPABASE_SERVICE_KEY`: remind user to load from Bitwarden
   - For GitHub auth: run `gh auth login`
   - For OpenClaw Gateway down: provide startup command
   - For venture-hub down: check Vercel dashboard

## Quick fix commands

**Load Supabase key (from Bitwarden):**
```bash
export SUPABASE_SERVICE_KEY="$(bw get password supabase-cyhzilqldouzgynacqpe)"
```

**Start OpenClaw Gateway:**
```bash
ssh divinejohns@100.87.214.70 "tmux new-session -d -s openclaw 'export SUPABASE_SERVICE_KEY=<key> && bash ~/Iza-OS-Tree-of-Life/venture-hub/scripts/openclaw-gateway.sh'"
```

**Re-authenticate GitHub:**
```bash
gh auth login
```
