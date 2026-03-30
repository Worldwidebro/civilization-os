# Civilization OS — Claude Code Project Guide
# Owner: Antwuan Johns (@Worldwidebro)
# 687 ventures. One source of truth. Four layers.

---

## IDENTITY: WHO YOU ARE HERE

You are `claude-code`, operating as the primary technical agent for Civilization OS.
Your machine is MacBook Air. Your task queue is `aoc_tasks` in Supabase.
You claim tasks via `claim_next_task('claude-code')`.

---

## THE FOUR LAYERS (never skip, never duplicate)

```
1. SUPABASE      ← claim task, read venture data, write results
2. GITHUB        ← push code/files/features to venture repo
3. LOCAL FILES   ← T7/COS folders for working docs
4. VENTURE-HUB   ← auto-reflects Supabase (no manual update needed)
```

---

## SUPABASE

- **Project ID**: `cyhzilqldouzgynacqpe`
- **URL**: `https://cyhzilqldouzgynacqpe.supabase.co`
- **Key**: `$SUPABASE_SERVICE_KEY` (load from Bitwarden — never hardcode)

### Core tables

| Table | Rows | Purpose |
|-------|------|---------|
| `business_ventures` | 687 | Master venture list |
| `venture_audit` | 687 | ICP, competitors, first_dollar_action |
| `venture_content` | 1,374 | Social posts, email sequences |
| `aoc_tasks` | ~2,983 | Agent task queue |
| `presell_products` | — | SKU catalog |
| `waitlist_signups` | — | Email captures |
| `venture_metrics` | — | Revenue tracking |

### Task claim pattern (every session)

```sql
-- 1. Claim
SELECT claim_next_task('claude-code');

-- 2. Read venture context
SELECT bv.*, va.*, vc.*
FROM business_ventures bv
LEFT JOIN venture_audit va ON va.business_id = bv.business_id
LEFT JOIN venture_content vc ON vc.business_id = bv.business_id
WHERE bv.business_id = '{claimed_venture_id}';

-- 3. Mark complete
UPDATE aoc_tasks SET status='success', completed_at=now()
WHERE id='{task_id}';
```

---

## GITHUB

- **Org**: `Worldwidebro`
- **Auth**: `gh` CLI or `$GITHUB_TOKEN`
- **Repo naming**: `{sector-code}-{NNN}-{venture-name-kebab}`
  - Example: `ec-001-angels-in-daylight`, `fin-001-genixbank-lite`

### Sector codes

```
bw=beauty-wellness  comm=community    ec=ecommerce(110★)  edu=education
fin=financial(41★)  fs=fitness-sports fh=food-hospitality lt=logistics
mc=media-content    ops=operations    ps=professional-svc st=software-tech
spec=specialized    tech=technology   em=emerging         et=edu-training
```

### Per-venture scaffold (STAGE 1 — claude-code owns this)

Every repo must have:
- `README.md` — business_id, sector, first_dollar_action
- `VENTURE.json` — machine-readable config
- `.gitignore` — blocks secrets
- `docs/ICP.md` — from venture_audit.icp_title
- `docs/COMPETITORS.md` — from venture_audit.competitors

---

## AGENT ROSTER

| Agent | Machine | Owns |
|-------|---------|------|
| `claude-code` | MacBook Air | repos, code, Supabase schema, GitHub ops |
| `qwen-agent` | Mac Studio | mvp, ops, marketing, monetization, content |
| `clawd-cursor` | Mac Studio | GUI automation, browser tasks |
| `deerflow-main` | Mac Studio | deep research, competitor analysis |
| `n8n-automation` | Mac Studio | workflows, email sequences |
| `human-antwuan` | Anywhere | strategy, capital, content creation |

---

## VENTURE COMPLETION STAGES

```
STAGE 1 — SCAFFOLD    (claude-code)   → GitHub repo + README + VENTURE.json
STAGE 2 — PRE-SELL    (qwen-agent)    → Gumroad listing + Stripe link + waitlist
STAGE 3 — MVP         (qwen-agent)    → core product + landing page + payment tested
STAGE 4 — OPERATE     (n8n-automation)→ lead capture workflow + revenue tracking
STAGE 5 — SCALE       (all)           → legal entity + cap table + funding path
```

---

## OPENCLAW GATEWAY (Mac Studio — port 3333)

To start agent processing of 2,786+ pending tasks:
```bash
ssh divinejohns@100.87.214.70
tmux new -s openclaw
export SUPABASE_SERVICE_KEY="[from .env.consolidated]"
bash ~/Iza-OS-Tree-of-Life/venture-hub/scripts/openclaw-gateway.sh
```

Monitor: `tail -f ~/openviking.log`

---

## SECURITY RULES (non-negotiable)

**NEVER commit:**
- `.env` files → Bitwarden
- API keys, service keys, tokens → Bitwarden
- SSH keys → `~/.ssh` only
- `.auth0.env` → home directory only

**ALWAYS check before push:**
```bash
git diff --cached | grep -iE "key|secret|password|token"
```

**Run connection health check before any agent session:**
```bash
SUPABASE_SERVICE_KEY=<from bitwarden> bash scripts/check-connections.sh
```

---

## KEY PATHS

| What | Where |
|------|-------|
| venture-hub app | `~/Documents/Civilization OS/venture-hub/` |
| sector venture folders | `~/Documents/Civilization OS/020-20-ventures/` |
| T7 Shield working files | `/Volumes/T7 Shield/20-ventures/` |
| Mac Studio repo | `~/Iza-OS-Tree-of-Life/` (SSH) |
| Connection health check | `scripts/check-connections.sh` |
| Custom slash commands | `.claude/commands/` |

---

## VENTURE-HUB LIVE ENDPOINTS

```
venture-hub-pi.vercel.app/hub              ← mission control
venture-hub-pi.vercel.app/ventures         ← all 687 ventures
venture-hub-pi.vercel.app/ventures/[id]    ← per-venture dashboard
venture-hub-pi.vercel.app/presell/[slug]   ← pre-sell pages
venture-hub-pi.vercel.app/waitlist/[slug]  ← email capture
venture-hub-pi.vercel.app/api/ventures     ← REST API
```

Everything in Supabase auto-appears in venture-hub — no manual sync needed.

---

## PRIORITY ORDER (when multiple tasks available)

1. `ec-*` e-commerce ventures (110 ventures, highest revenue potential)
2. `fin-*` financial ventures (41 ventures)
3. `ps-*` professional services (25 ventures, fast first dollar)
4. `mc-*` media-content (20 ventures)
5. `st-*` software-technology (30 ventures)
6. All other sectors
