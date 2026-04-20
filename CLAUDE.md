# CivilizationOS — Root CLAUDE.md

**System Owner:** Worldwidebro Holdings  
**Date:** 2026-04-20  
**Status:** Live (80% operational, 20% wiring complete)

---

## 🧠 System Overview

CivilizationOS is a **semantic execution layer** that turns business intent → code → agents → revenue.

**Core Pattern:**
```
Business Intent (Ventures CSV)
  ↓ Ontology (Knowledge Graph)
  ↓ Structure (Supabase Schema)
  ↓ Execution (Code + Agents)
  ↓ Automation (ClickUp + The Office)
  ↓ Visibility (Venture Hub)
```

---

## 🏗️ Architecture (6 Layers)

### Layer 1: Repo (Atomic Code)
- 687 venture repos
- 25+ infrastructure repos
- 5+ profile repos
- **Total: 853 owned repos**

### Layer 2: Service (Deployable Units)
- Docker-based services
- API endpoints
- Independent deployment

### Layer 3: System (Connected Intelligence)
- autonomous-venture-studio (553 agents)
- iza-os-rag-system (semantic memory)
- the-office (audit trail)
- venture-hub (dashboard)

### Layer 4: Product (User-Facing)
- Venture dashboards
- Customer portals
- Analytics views

### Layer 5: Venture (Monetized)
- Revenue streams
- Cost allocation
- P&L tracking

### Layer 6: Portfolio (Scaled)
- Shared infrastructure
- Cross-venture intelligence
- Capital allocation

---

## 📊 Key Data Files

### ventures-master.csv (🔑 Source of Truth)
Location: `/civilization-os/ventures-master.csv`

Columns:
```
venture_id, name, sector, stage, status, repository_url, 
revenue_ytd, costs_mom, staff_count, blockers, next_action
```

**This file cascades to:**
- SKILL.md (each venture knows itself)
- Supabase (business_ventures_master table)
- Dashboards (all portfolio views)
- Agents (what to work on)

### Syncing
- GitHub: ventures-master.csv is source control
- Supabase: nightly sync job updates tables
- Each Venture: SKILL.md auto-generated from CSV

---

## 🤖 Agent System (553 Agents, 5 Tiers)

**Registry:** `/MASTER_AGENT_REGISTRY.md`

### Tier 1 — Strategic Leadership (5)
- EXECUTOR (coordinates execution)
- ANALYST (analyzes ventures)
- ARCHITECT (designs systems)
- RESEARCHER (market research)
- SCHEDULER (coordinates timing)

### Tier 2 — Domain Specialists (20)
- Financial (T2_FINANCIAL_SPECIALIST)
- Engineering (T2_CODE_ARCHITECT)
- Sales (T2_SALES_STRATEGIST)
- Operations (T2_OPS_COORDINATOR)
- etc.

### Tier 3 — Sector Specialists (50)
- Construction (T3_CONSTRUCTION_EXPERT)
- E-Commerce (T3_ECOMMERCE_EXPERT)
- Finance (T3_FINANCE_EXPERT)
- etc.

### Tier 4 — Venture Agents (400)
- One per venture (CON-001-AGENT, EC-001-AGENT, etc.)
- Reads SKILL.md
- Claims ClickUp tasks
- Executes within venture context

### Tier 5 — Support Agents (78)
- Infrastructure support
- Data sync
- Automation

---

## 🗄️ Supabase Schema

### Venture Tables
- `business_ventures_master` — CSV mirror (687 rows)
- `venture_revenue_summary` — P&L (nightly calc)
- `venture_staffing` — Contractors (Deel integration)
- `venture_dependencies` — Blockers + relationships
- `venture_funding` — SBA loans + capital
- `venture_agent_activity` — Execution log
- `canonical_tasks` — Unified task registry

### Views
- `venture_health_summary` — Quick health dashboard

---

## 🔀 Data Flow (Wiring Status)

### ✅ Wired (Working)
```
GitHub repos → Supabase aoc_tasks
GitHub repos → Supabase venture_tasks
Supabase → agents (read queries)
```

### ❌ Not Wired (In Progress)
```
Paddle webhooks → The Office revenue
STAFF-001 payroll → The Office costs
The Office → ventures-master.csv P&L
ClickUp MCP → canonical_tasks sync
ventures-master.csv → Each venture SKILL.md
```

---

## 📋 Task System

### Sources (3 currently fragmented)
1. **aoc_tasks** (Supabase) — Agent orchestration
2. **venture_tasks** (Supabase) — Venture-specific
3. **ClickUp** (External) — Team project management

### Unification
`canonical_tasks` table combines all three sources.

### Workflow
```
ClickUp task
  ↓ (MCP sync)
canonical_tasks (Supabase)
  ↓ (agent reads)
Tier 4 agent claims task
  ↓ (executes)
The Office logs action
  ↓ (aggregates)
venture_health_summary updates
  ↓ (dashboard reflects)
Venture Hub shows status
```

---

## 🎯 What's Built

✅ **Infrastructure:**
- 853 repos created
- Core platforms live (venture-hub, the-office, autonomous-venture-studio)
- Supabase schema 13/20 tables
- ClickUp connected via MCP
- 614 starred repos cataloged

✅ **Ventures:**
- 687 ventures defined in CSV
- 687 SKILL.md templates generated
- Repository URLs established
- Sector + stage tracking

✅ **Documentation:**
- SYSTEM-CLARITY.md (ventures vs tools vs profiles)
- CSV-MASTER-SCHEMA.md (data structure)
- PROJECT-GUIDE.md (4-phase implementation)
- EXECUTION-MANIFEST.md (task coordination)
- ARCHITECTURE-SUMMARY.md (complete reference)

---

## 🚀 What's Next (11 Priority Tasks)

### Batch 1 (Week 1) — Foundation
1. Repository Migration & Folder Structure
2. Root CLAUDE.md (THIS FILE)
3. Categorization & Tag All 853 Repos

### Batch 2 (Week 2) — Dashboards
2. Venture Hub Operations Dashboard
4. Agent Activity Tracking & Visibility
6. Sector Portal Pages

### Batch 3 (Week 2-3) — Revenue Wiring
3. Build Unified Revenue Infrastructure
5. Financial Reconciliation & P&L
7. SBA Microloan Tracking

### Batch 4 (Week 3-4) — Standardization
4. Apply Up Next Monorepo Template
8. Create Venture Runbooks & Templates

---

## 📖 How to Use This System

### If you're an Agent:
1. Read ventures-master.csv for sector assignment
2. Check SKILL.md for venture context
3. Read ClickUp MCP task assignments
4. Execute task
5. Log to The Office via API
6. System auto-updates dashboards

### If you're an Operator:
1. Check venture-hub dashboard for portfolio health
2. Update ventures-master.csv for status changes
3. Run nightly sync job (P&L calculation)
4. Review venture_health_summary view
5. Assign ClickUp tasks to agents
6. Monitor venture_agent_activity table

### If you're Building a New Venture:
1. Add row to ventures-master.csv
2. Run script/generate-skill-md.js
3. SKILL.md auto-pushed to venture repo
4. Venture agents auto-assigned from Tier 4
5. GitHub repo auto-mirrors to Supabase
6. Dashboard auto-adds to portfolio view

---

## 🔑 Key Files & Commands

### Data
```
ventures-master.csv          # Source of truth (687 ventures)
migrations/001_*.sql         # Supabase table creation
scripts/generate-skill-md.js # Auto-gen SKILL.md for all ventures
```

### Documentation
```
SYSTEM-CLARITY.md            # Ventures vs tools vs profiles
CSV-MASTER-SCHEMA.md         # Data structure definition
PROJECT-GUIDE.md             # 4-phase implementation plan
EXECUTION-MANIFEST.md        # Task coordination + agents
ARCHITECTURE-SUMMARY.md      # Complete reference
MASTER_AGENT_REGISTRY.md     # 553 agents + capabilities
```

### Dashboards
```
venture-hub/pages/[id]/operations     # Venture operations
venture-hub/pages/[id]/agents         # Agent activity
venture-hub/analytics/reconciliation  # P&L dashboard
venture-hub/sectors/[sector]          # Sector portals
```

---

## ⚡ Critical Configuration

### Supabase Project
```
Project: CivilizationOS
URL: https://cyhzilqldouzgynacqpe.supabase.co
Key: (in vault.secrets)
```

### GitHub Organization
```
Org: Worldwidebro
Repos: 853 total
```

### ClickUp Integration
```
MCP: Active
Workspaces: (needs audit)
Sync: canonical_tasks ↔ ClickUp (needs wiring)
```

### The Office (Convex)
```
Role: Central audit trail + data backbone
API: Used by all agents for logging
Data: Execution records for every action
```

---

## 🧠 Advanced Features

### Semantic Awareness
- Knowledge graph (iza-os-knowledge-graph) maps relationships
- Agents understand venture dependencies
- P&L calculations account for shared resources
- Cross-venture optimization via Tier 1 agents

### Self-Healing
- venture_health_summary view flags issues
- Tier 2 agents receive alerts
- Auto-escalation to Tier 1 for decision-making
- The Office logs all decisions

### Rapid Scaling
- New venture: Add row to CSV
- SKILL.md auto-generated
- Agents auto-assigned
- Dashboard auto-populated
- Ready to monetize immediately

---

## 📊 Quick Status Dashboard

| Component | Status | % Complete | Owner |
|-----------|--------|-----------|-------|
| Repos | ✅ Live | 100% | GitHub |
| Supabase | 🟡 Partial | 65% | Data team |
| Agents | ✅ Built | 100% | Auto studio |
| Dashboards | 🟡 Partial | 60% | Frontend |
| Revenue Wiring | ❌ Started | 10% | Integrations |
| Task Sync | ❌ Planned | 0% | Automation |
| Runbooks | 🟡 Partial | 40% | Docs team |

---

## 🔗 Links

- **Main Repo:** https://github.com/Worldwidebro/civilization-os
- **Venture Hub:** https://github.com/Worldwidebro/venture-hub
- **Agent Studio:** https://github.com/Worldwidebro/autonomous-venture-studio
- **Knowledge Graph:** https://github.com/Worldwidebro/iza-os-knowledge-graph
- **SBA Info:** https://www.sba.gov/funding-programs/loans/microloans

---

**Generated:** 2026-04-20  
**System:** CivilizationOS  
**Last Updated:** $(git log -1 --format=%cd civilization-os)
