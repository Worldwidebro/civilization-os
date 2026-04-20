# CSV Master Schema — Single Source of Truth for All 687 Ventures

**Current State:** ventures.js (JSON) → Venture Hub portfolio  
**Proposed State:** ventures.csv (master) → Supabase → Dashboards + Each Repo's SKILL.md  
**Goal:** All venture data synchronized from one place

---

## Current Data Structure

**File:** `/Users/acebless/Documents/venture-hub/data/ventures.js`  
**Format:** JavaScript with embedded JSON  
**Records:** 687 ventures  
**Current Columns:**
```json
{
  "id": "FIN-001-GenixBank-Lite",
  "name": "Genixbank Lite",
  "sector": "financial",
  "stage": "planned",
  "status": "planned",
  "repository_url": "https://github.com/Worldwidebro/fin-001-genixbank-lite"
}
```

---

## Extended Master CSV Schema

Convert `ventures.js` → `ventures-master.csv` with these columns:

### Identity
```
venture_id (PK)         → "FIN-001-GenixBank-Lite"
venture_name            → "Genixbank Lite"
sector_code             → "FIN" (from sector)
sector_name             → "financial"
```

### Status
```
stage                   → "planned", "mvp", "beta", "live"
status                  → "planned", "in_progress", "launched"
health_score            → 0-100 (calculated from: revenue + staffing + progress)
last_updated            → 2026-04-20
```

### Product
```
repository_url          → GitHub repo for code
description             → "What this venture does"
target_customer         → "Who buys this"
revenue_model           → "SaaS", "1-time", "subscription", "affiliate"
```

### Financial (Tracked in The Office, synced back to CSV)
```
revenue_ytd             → $0 (from The Office revenue_transactions)
revenue_mom             → $0 (this month)
costs_mom               → $0 (from STAFF-001 payroll allocation)
profit_ytd              → revenue_ytd - costs_ytd
margin_percent          → (profit / revenue) × 100
runway_months           → months until cash positive
```

### Staffing (From STAFF-001, synced back to CSV)
```
staff_count             → number of active contractors
staff_allocation_pct    → avg allocation %
primary_dev_id          → lead developer (contractor ID)
primary_contact         → client name
```

### Operations
```
blocked_by              → "TECH-042" (comma-sep list of venture IDs blocking this)
depends_on              → "FIN-001" (comma-sep list of ventures this depends on)
blockers                → "Waiting on backend API" (human text)
next_action             → "Complete feature X by 2026-04-25"
```

### Integrations & Syncing
```
clickup_project_id      → ClickUp project ID (if tracked there)
github_issue_count      → # of open issues
agent_ids               → "claude-code,venture-ops" (agents assigned)
last_synced_at          → 2026-04-20T14:30:00Z
data_sources            → "The Office, STAFF-001, ClickUp" (which systems have data for this venture)
```

### Metadata
```
created_at              → 2025-06-15
founder_name            → client/founder name
notes                   → internal notes
sba_loan_amount         → $ amount if microloan applied
```

---

## CSV Structure (as flat file)

```csv
venture_id,venture_name,sector_code,sector_name,stage,status,health_score,last_updated,repository_url,description,target_customer,revenue_model,revenue_ytd,revenue_mom,costs_mom,profit_ytd,margin_percent,runway_months,staff_count,staff_allocation_pct,primary_dev_id,primary_contact,blocked_by,depends_on,blockers,next_action,clickup_project_id,github_issue_count,agent_ids,last_synced_at,data_sources,created_at,founder_name,notes,sba_loan_amount
FIN-001-GenixBank-Lite,Genixbank Lite,FIN,financial,planned,planned,15,2026-04-20,https://github.com/Worldwidebro/fin-001-genixbank-lite,Banking platform lite,Freelancers,SaaS,0,0,0,0,0%,N/A,0,0,,,,,,OpenClaw,0,claude-code,2026-04-20T14:30:00Z,GitHub;The Office;STAFF-001,2025-06-15,Unknown,Awaiting design phase,
FIN-002-Credit-Repair-Automation,Credit Repair Automation,FIN,financial,planned,planned,10,2026-04-20,https://github.com/Worldwidebro/fin-002-credit-repair-automation,Credit repair automation,Credit seekers,Subscription,0,0,0,0,0%,N/A,0,0,,,,,,OpenClaw,0,claude-code,2026-04-20T14:30:00Z,GitHub;The Office,2025-06-15,Unknown,,
BW-001-Up-Next,Up Next Beauty Marketplace,BW,beauty-wellness,mvp,in_progress,45,2026-04-20,https://github.com/Worldwidebro/bw-001-up-next,Two-sided booking marketplace,Hair stylists,Subscription,0,0,3200,0,-100%,12,2,150%,contractor-123,Alexus Johnson,,,Waiting on Stripe Connect,Complete mobile app by 2026-05-15,,,,claude-code;venture-ops,2026-04-20T14:30:00Z,GitHub;The Office;STAFF-001,2026-03-15,Alexus Johnson,Alexus is responsive and excited,
```

---

## Data Flow: CSV as Master Source

```
┌─────────────────────────────────┐
│ VENTURES-MASTER.CSV             │
│ (Single source of truth)        │
│ 687 ventures + metadata         │
│ Version controlled in Git       │
└──────────────┬──────────────────┘
               │
      ┌────────┴────────┬─────────────┬──────────────┐
      ↓                 ↓             ↓              ↓
    (1)               (2)           (3)            (4)
  SUPABASE        VENTURE HUB    EACH REPO      INTEGRATIONS
  business_       /analytics     SKILL.md       (ClickUp, STAFF)
  ventures        /operations    claude.md
                                                │
                         ┌───────────────┬──────┴──────┐
                         ↓               ↓             ↓
                    REVENUE CHANGE   STAFFING CHANGE   STATUS CHANGE
                         │               │             │
                         └───────────────┴──────┬──────┘
                                                ↓
                        UPDATE CSV (merge → Git commit)
```

### Flow Details

**1. CSV → Supabase (Initial Load + Nightly Sync)**
```sql
-- Create table from CSV
CREATE TABLE business_ventures_master (
  venture_id TEXT PRIMARY KEY,
  venture_name TEXT,
  sector_code TEXT,
  sector_name TEXT,
  stage TEXT,
  status TEXT,
  health_score INT,
  last_updated TIMESTAMP,
  repository_url TEXT,
  
  -- Financial
  revenue_ytd DECIMAL,
  revenue_mom DECIMAL,
  costs_mom DECIMAL,
  profit_ytd DECIMAL,
  margin_percent DECIMAL,
  
  -- Staffing
  staff_count INT,
  staff_allocation_pct INT,
  primary_dev_id TEXT,
  
  -- Operations
  blocked_by TEXT,      -- comma-separated venture IDs
  depends_on TEXT,      -- comma-separated venture IDs
  blockers TEXT,
  next_action TEXT,
  
  -- Metadata
  created_at TIMESTAMP,
  last_synced_at TIMESTAMP,
  data_sources TEXT     -- comma-separated: "The Office,STAFF-001,GitHub"
);

-- Trigger: on CSV import, update Supabase
-- Frequency: nightly or on-demand via git webhook
```

**2. Supabase → Venture Hub Dashboards**
```
GET /api/ventures/master
  → Query business_ventures_master
  → Display in /analytics (all ventures)
  → Display in /ventures/[id]/overview (single venture)
  → Display health score + financials + staffing
```

**3. CSV → Each Venture's Repo**
```
Every venture repo needs:

/SKILL.md (auto-generated from CSV)
├─ venture_id: FIN-001-GenixBank-Lite
├─ sector: financial
├─ status: planned
├─ health_score: 15
├─ staff: [list from CSV]
├─ revenue: $0 YTD
├─ blockers: [from CSV]
├─ next_action: [from CSV]
└─ last_synced: 2026-04-20T14:30:00Z

/claude.md (auto-generated from CSV + Supabase)
├─ Quick Stats
├─ System Connections (The Office, STAFF-001, ClickUp)
├─ Agent Capabilities
├─ Data Flow
├─ Running Checklist
└─ Last Updated

TEMPLATE:
─────────
# [venture_name] ([venture_id])

## Status
- Stage: {{stage}}
- Health: {{health_score}}/100
- Last Updated: {{last_updated}}

## Team
- Contractors: {{staff_count}}
- Lead Dev: {{primary_dev_id}}
- Allocation: {{staff_allocation_pct}}%

## Financial (YTD)
- Revenue: ${{revenue_ytd}}
- Costs: ${{costs_mom}}/month
- Profit: ${{profit_ytd}}
- Margin: {{margin_percent}}%

## Blockers & Next Actions
- Blocked By: {{blocked_by}}
- Blockers: {{blockers}}
- Next Action: {{next_action}} (due: {{deadline}})

## Agents Working Here
{{agent_ids}}

## Data Sources
Last synced: {{last_synced_at}}
From: {{data_sources}}
```

**4. Updates Flow Back to CSV**

When data changes anywhere:

```
The Office records revenue
  ↓
Nightly job updates CSV: revenue_ytd, revenue_mom
  ↓
CSV committed to git with comment: "sync: FIN-001 +$1,500 revenue"
  ↓
Git webhook triggers Supabase update
  ↓
Supabase notifies Venture Hub
  ↓
Dashboard refreshes

OR

STAFF-001 logs contractor hours
  ↓
Weekly sync updates CSV: staff_count, costs_mom, staff_allocation_pct
  ↓
CSV committed to git
  ↓
Each venture's SKILL.md regenerated
  ↓
Agents see updated staffing when they read SKILL.md
```

---

## Implementation Roadmap

### Phase 1: Create CSV Master (1-2 days)

```bash
# Step 1: Export current ventures.js → CSV
# (Convert JSON array → CSV rows)

# Step 2: Add blank columns for:
# - Financial (revenue_ytd, costs_mom, profit, margin, runway)
# - Staffing (staff_count, allocation, primary_dev)
# - Operations (blocked_by, depends_on, blockers, next_action)
# - Metadata (clickup_project_id, agent_ids, health_score, last_synced)

# Step 3: Populate high-value rows (top 30 ventures)
# - Revenue from The Office
# - Staffing from STAFF-001
# - Blockers from ClickUp
# - Dependencies from GitHub

# Step 4: Commit to git as ventures-master.csv
```

### Phase 2: Wire CSV → Supabase (1-2 days)

```bash
# Step 1: Create edge function: /api/sync/csv-to-supabase
# - Reads ventures-master.csv from GitHub
# - Upserts to business_ventures_master table
# - Logs sync event to The Office

# Step 2: Create trigger on GitHub (on CSV commit)
# - Webhook → /api/sync/csv-to-supabase
# - Auto-sync when CSV changes

# Step 3: Create scheduled job (nightly)
# - Query The Office for revenue changes
# - Query STAFF-001 for cost changes
# - Update CSV with new data
# - Commit to git

# Step 4: Test end-to-end
# - Manually add data to CSV
# - Verify Supabase updates
# - Verify dashboards refresh
```

### Phase 3: Wire CSV → Each Venture's Repo (2-3 days)

```bash
# Step 1: Create edge function: /api/sync/csv-to-repos
# - For each venture in CSV
# - Generate SKILL.md content
# - Generate claude.md content
# - Create/update PR in venture repo

# Step 2: Create GitHub Action in each venture
# - On SKILL.md change, trigger agent tasks
# - On claude.md change, update operations checklist

# Step 3: Schedule sync job
# - Daily: regenerate SKILL.md + claude.md for all 687 ventures
# - Push updates to each repo

# Step 4: Test with 3 ventures first
# - BW-001 (beauty-wellness, has staffing)
# - FIN-001 (financial, planned)
# - TECH-001 (technology, unknown)
```

### Phase 4: Dashboard Integration (1-2 days)

```bash
# Venture Hub already pulls from Supabase
# Just update queries to read from business_ventures_master

# New endpoints:
GET /api/ventures/master/all           → all 687 (for portfolio)
GET /api/ventures/master/[id]          → single venture (for /operations)
GET /api/ventures/master/health        → all with health scores
GET /api/ventures/master/blocked       → all currently blocked
GET /api/ventures/master/sector/[name] → all in sector
```

---

## CSV Location & Version Control

**Main file:**
```
/Users/acebless/Documents/venture-hub/data/ventures-master.csv
(committed to git: worldwidebro/venture-hub)
```

**Mirrors:**
```
Supabase: business_ventures_master table
The Office: ventures_master table (copy for auditing)
Each venture repo: SKILL.md + claude.md (auto-generated)
```

**Versioning:**
```
ventures-master.csv is version-controlled
Every change is a git commit: "sync: [venture-id] [what changed]"
History shows who updated what, when
Rollback easy (revert commit)
Audit trail automatic
```

---

## Sample CSV Rows (After Population)

```csv
venture_id,venture_name,sector_code,sector_name,stage,status,health_score,revenue_ytd,revenue_mom,costs_mom,profit_ytd,margin_percent,staff_count,staff_allocation_pct,primary_dev_id,blocked_by,depends_on,blockers,next_action,agent_ids,last_synced_at
BW-001-Up-Next,Up Next Beauty Marketplace,BW,beauty-wellness,mvp,in_progress,65,$0,$0,$3200,$-3200,-100%,2,150%,contractor-123,,FIN-001,Waiting on payment API,Complete mobile app by 2026-05-15,claude-code;venture-ops,2026-04-20T14:30:00Z
FIN-001-GenixBank-Lite,Genixbank Lite,FIN,financial,planned,planned,15,$0,$0,$0,$0,0%,0,0%,,,,,,claude-code,2026-04-20T08:00:00Z
TECH-042-AI-Code-Gen,AI Code Generator,TECH,technology,beta,in_progress,78,$12500,$3100,$5200,$7300,58%,3,100%,contractor-456,,EC-001;FIN-001,Schema design incomplete,Launch beta features by 2026-05-01,claude-code;venture-ops,2026-04-20T16:45:00Z
EC-001-E-Commerce,E-Commerce Platform,EC,e-commerce,mvp,in_progress,42,$2800,$800,$8500,$-5700,-203%,5,80%,contractor-789,TECH-042,,High churn rate,Implement retention emails by 2026-04-30,claude-code,2026-04-20T12:15:00Z
```

---

## Benefits of CSV-as-Master

✅ **Single source of truth:** One file, version-controlled  
✅ **Easy to audit:** Git history shows all changes  
✅ **Distributed easily:** Sync to repos + dashboards automatically  
✅ **Human-readable:** Can edit directly if needed  
✅ **Lightweight:** No new databases  
✅ **Syncs easily:** Git webhooks trigger updates  
✅ **Integrates with agents:** Every venture has current data in SKILL.md  
✅ **Supports decisions:** Dashboard shows full status at a glance  

---

## Query Patterns

**"Which ventures are making money?"**
```
Filter: profit_ytd > 0
Sort by: profit_ytd DESC
Count: revenue-positive ventures
```

**"What's blocking launches?"**
```
Filter: blocked_by IS NOT NULL
Show: blocked_by + blockers columns
```

**"Contractor utilization?"**
```
Group by: primary_dev_id
Sum: staff_count per contractor
Avg: staff_allocation_pct
```

**"Health dashboard?"**
```
All ventures: venture_id, health_score, status
Sort by: health_score ASC (troubled first)
Show: blockers + next_action for each
```

---

## Next Steps

1. **Export current ventures.js → ventures-master.csv** (2-3 hours)
   - Convert JSON array to CSV
   - Keep current columns
   - Add blank columns for extended schema

2. **Populate top 30 ventures with real data** (4-6 hours)
   - Query The Office for revenue
   - Query STAFF-001 for costs
   - Get blockers from ClickUp
   - Get health scores from manual assessment

3. **Create /api/sync/csv-to-supabase** (2-3 hours)
   - Read CSV from GitHub
   - Upsert to business_ventures_master
   - Log to audit trail

4. **Wire CSV → SKILL.md in 3 ventures** (2-3 hours)
   - BW-001, FIN-001, TECH-001
   - Test that SKILL.md updates when CSV changes
   - Verify agents can read current status

5. **Create dashboard queries** (1-2 hours)
   - Health score view
   - Blocked ventures view
   - Financials view

---

## Questions for You

1. **How often should CSV sync?** (hourly, daily, on-commit?)
2. **Who edits the CSV directly?** (ops team, automation only?)
3. **What's the priority population order?** (top 30 by revenue, all 687, specific sectors?)
4. **Should old ventures.js stay?** (or migrate completely to CSV?)
