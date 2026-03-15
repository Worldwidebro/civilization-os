# AGENT OPERATIONS MASTER
# Civilization OS — How Agents Delegate, Orchestrate & Complete Ventures
# Owner: Antwuan Johns (@Worldwidebro) | Updated: 2026-03-15

---

## THE RULE: ONE TRUTH, FOUR LAYERS

Every agent reads from and writes to the same 4 layers in order:

```
1. SUPABASE      ← claim task, read venture data, write results
2. GITHUB        ← push code, files, features to venture repo
3. LOCAL FILES   ← T7/COS folders for working docs
4. VENTURE-HUB   ← auto-reflects Supabase (no manual update needed)
```

**Agents never skip layers. Agents never duplicate work across layers.**

---

## AGENT ROSTER & WHAT EACH OWNS

| Agent | Machine | Handles | Claims Via |
|-------|---------|---------|-----------|
| `claude-code` | MacBook Air | repos, code, Supabase schema, GitHub ops | `claim_next_task('claude-code')` |
| `qwen-agent` | Mac Studio | mvp, ops, marketing, monetization, content | `claim_next_task('qwen-agent')` |
| `clawd-cursor` | Mac Studio | GUI automation, form fills, browser tasks | `claim_next_task('clawd-cursor')` |
| `deerflow-main` | Mac Studio | deep research, competitor analysis | `claim_next_task('deerflow-main')` |
| `n8n-automation` | Mac Studio | workflows, triggers, email sequences | `claim_next_task('n8n-automation')` |
| `human-antwuan` | Anywhere | strategy, capital, content creation | Manual |

---

## TASK CLAIM PATTERN (Every Session Start)

```sql
-- 1. Claim next available task
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

## VENTURE COMPLETION CHECKLIST (Per Venture, All 687)

Every venture must pass through these stages IN ORDER:

### STAGE 1 — SCAFFOLD (agent: claude-code)
- [x] GitHub repo created private (naming: `sector-NNN-venture-name`)
- [x] `README.md` pushed (business_id, sector, first dollar path)
- [x] `VENTURE.json` pushed (machine-readable config)
- [x] `.gitignore` pushed (blocks secrets)
- [ ] `docs/ICP.md` pushed (from venture_audit.icp_title)
- [ ] `docs/COMPETITORS.md` pushed (from venture_audit.competitors)
- [ ] Branch protection set on main

### STAGE 2 — PRE-SELL (agent: qwen-agent)
- [ ] Gumroad listing created (digital product or service)
- [ ] Stripe payment link created
- [ ] Waitlist page live at `/waitlist/[slug]`
- [ ] Social post drafted (in venture_content)
- [ ] Email sequence written (3 emails)

### STAGE 3 — MVP (agent: qwen-agent / claude-code)
- [ ] Core product built (code in `src/` OR Gumroad PDF)
- [ ] Landing page live
- [ ] Payment tested end-to-end
- [ ] First customer acquired

### STAGE 4 — OPERATE (agent: n8n-automation)
- [ ] n8n workflow for lead capture → email sequence
- [ ] Revenue tracked in `revenue_tracking` table
- [ ] Monthly report in `venture_metrics`

### STAGE 5 — SCALE (agent: all)
- [ ] Legal entity created in `legal_entities` table
- [ ] Cap table row in `equity_cap_table`
- [ ] Funding path documented in `funding_rounds`

---

## FILE → REPO MAPPING (What Goes Where)

```
LOCAL FILE                              → GITHUB REPO
─────────────────────────────────────────────────────
T7/20-ventures/03-ecommerce/_data/      → ec-NNN-venture-name/docs/
T7/20-ventures/03-ecommerce/_tasks/     → ec-NNN-venture-name/docs/TASKS.md
T7/20-ventures/03-ecommerce/_presell/   → ec-NNN-venture-name/presell/
COS/ECOM/skus/master-sku-catalog.csv    → venture-hub/data/
COS/ECOM/marketing/email-sequences/    → mc-NNN-venture-name/sequences/
COS/scripts/venture-creation/          → civilization-os/scripts/
```

---

## REPO NAMING RULES (enforced)

```
Pattern:  {sector-code}-{NNN}-{venture-name-kebab}
Examples: ec-001-angels-in-daylight
          fin-001-genixbank-lite
          bw-001-lash-extension-studio

Sector codes:
  bw   = beauty-wellness      (01) 40 ventures
  comm = community             (02) 50 ventures
  ec   = e-commerce            (03) 110 ventures  ← HIGHEST PRIORITY
  edu  = education             (04) 40 ventures
  et   = education-training    (05) 15 ventures
  em   = emerging              (06) 50 ventures
  fin  = financial             (07) 41 ventures  ← HIGH PRIORITY
  fs   = fitness-sports        (08) 25 ventures
  fh   = food-hospitality      (09) 35 ventures
  lt   = logistics-transport   (10) 30 ventures
  mc   = media-content         (11) 20 ventures
  ops  = operations            (12) 66 ventures
  ps   = professional-services (13) 25 ventures
  st   = software-technology   (14) 30 ventures
  spec = specialized           (15) 50 ventures
  tech = technology            (16) 60 ventures
```

---

## SECURITY RULES (non-negotiable)

```
NEVER commit:
  .env files     → Bitwarden
  API keys       → Bitwarden
  Service keys   → Bitwarden
  SSH keys       → ~/.ssh only
  .auth0.env     → stays in home dir, never in repo
  *.secrets      → Bitwarden

ALWAYS check before push:
  git diff --cached | grep -i "key\|secret\|password\|token"
```

---

## PENDING WORK QUEUE (as of 2026-03-15)

| Task Type | Pending | Complete | Agent |
|-----------|---------|----------|-------|
| mvp | 594 | 4 | qwen-agent |
| ops | 596 | 2 | qwen-agent |
| marketing | 685 | 2 | qwen-agent |
| monetization | 685 | 2 | qwen-agent |
| content | 89 | 0 | qwen-agent |
| launch | 48 | 2 | human-antwuan |
| tech | 89 | 0 | claude-code |
| **TOTAL** | **2,786** | **247** | |

**To start processing:** `ssh mac-studio` → `SUPABASE_SERVICE_KEY=xxx bash ~/Iza-OS-Tree-of-Life/venture-hub/scripts/openclaw-gateway.sh`

---

## WHAT VENTURE-HUB ALREADY HAS

```
venture-hub-pi.vercel.app/
├── /hub              ← AI Boss Hub command center
├── /ventures         ← all 687 ventures (live from Supabase)
├── /ventures/[id]    ← per-venture dashboard
├── /ventures/fin-001 ← GenixBank dedicated page
├── /directory        ← venture directory
├── /sectors          ← sector overview
├── /pricing          ← pricing plans
├── /presell/[slug]   ← pre-sell pages (BUILT TODAY)
├── /waitlist/[slug]  ← waitlist capture (BUILT TODAY)
├── /portfolio        ← portfolio page
├── /resume           ← Antwuan's resume
├── /analytics        ← analytics dashboard
└── /api/ventures     ← REST API for all 687
    /api/waitlist     ← waitlist signups API (BUILT TODAY)
    /api/presell      ← pre-sell products API (BUILT TODAY)
```

---

## TOMORROW'S PRIORITY BUILD LIST

### 1. Start Qwen Gateway (Mac Studio — 30 min)
```bash
ssh mac-studio
tmux new -s openclaw
SUPABASE_SERVICE_KEY=<from bitwarden> bash ~/Iza-OS-Tree-of-Life/venture-hub/scripts/openclaw-gateway.sh
```
→ 2,786 pending tasks start processing autonomously

### 2. Create First Gumroad Listing (30 min — $0 cost, $27+ revenue)
- Product: "Top 100 Winning Ecommerce Products" PDF
- Venture: EC-044-Live-Commerce-Platform
- Platform: gumroad.com → new product → $27
- Promote: 1 TikTok/IG post with link in bio

### 3. Post 1 LinkedIn Offer (15 min — $500 revenue)
- "Free 30-min business audit → then $500 strategy session"
- Venture: PS-017-Videography-Service
- Pay via: Stripe payment link

### 4. Form LLC (ongoing — legal foundation)
- Wyoming or home state → $50-150 online
- Get EIN → free via IRS.gov
- Open Mercury bank account → free
- Connect Stripe → all revenue routes here

### 5. Archive 137 Dead Bot Repos (automated — 1 hr)
```bash
# Run after Qwen gateway is running
python3 /Documents/Civilization OS/scripts/automation/archive_dead_repos.py
```
