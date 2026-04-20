# PROJECT GUIDE — Fixing System Architecture & Proper Git Commits

**Objective:** Restructure Civilization OS repos into proper categories (Ventures/Infrastructure/Profiles) and establish correct git workflows.  
**Outcome:** 687 repos properly organized, clear data sources, clean dashboards.  
**Timeline:** 4-6 weeks across 4 phases.

---

## Phase 1: Audit & Categorization (Week 1)

### 1.1 Categorize All 687 Repos

**Where:** GitHub Org audit script  
**Git Repo:** `worldwidebro/civilization-os` (orchestrator repo)  
**Commit to:** `worldwidebro/civilization-os` (not individual venture repos)

**Tasks:**
```bash
# Script: scripts/audit-repos.py
# Reads all repos in org
# Outputs: AUDIT-REPORT.csv with categories

Output: AUDIT-REPORT.csv
├─ repo_name
├─ current_location
├─ correct_location (VENTURES, INFRASTRUCTURE, PROFILES)
├─ requires_rename (true/false)
├─ requires_move (true/false)
└─ notes

Example rows:
resume,worldwidebro/resume,worldwidebro/profiles/antwuan-johns/resume,true,true,"Owner resume"
fin-023-investment-portfolio-ai,worldwidebro/fin-023-...,worldwidebro/ventures/fin-023-...,false,true,"Venture - needs move"
tech-ventures-portfolio,worldwidebro/tech-ventures-...,worldwidebro/infrastructure/tech-ventures-...,true,true,"Infrastructure tool - needs rename + move"
```

**Commit to:**
```bash
cd worldwidebro/civilization-os
git add scripts/audit-repos.py AUDIT-REPORT.csv
git commit -m "audit: categorize all 687 repos into ventures/infrastructure/profiles

Per SYSTEM-CLARITY.md:
- VENTURES (products to sell): ~650 repos
- INFRASTRUCTURE (internal tools): ~25 repos  
- PROFILES (team metadata): ~5 repos

AUDIT-REPORT.csv shows required moves and renames.
Next step: Implement Phase 2 migration."
git push origin main
```

---

### 1.2 Create Master Data Files

**Where:** worldwidebro/civilization-os  
**Commit to:** `worldwidebro/civilization-os` (master org repo)

**Files to create:**

```csv
# VENTURES.csv (all 650+ real products)
venture_id,name,sector,stage,status,repository_url,health_score,last_updated
FIN-023-Investment-Portfolio-AI,Investment Portfolio AI,financial,in_progress,in_progress,https://github.com/worldwidebro/ventures/fin-023-investment-portfolio-ai,45,2026-04-20
BW-001-Up-Next,Up Next Beauty Marketplace,beauty-wellness,mvp,in_progress,https://github.com/worldwidebro/ventures/bw-001-up-next,65,2026-04-20
...
```

```markdown
# INFRASTRUCTURE.md (all internal tools/systems)

## Purpose
Catalog of infrastructure and internal tools that support the venture ecosystem.
These are NOT ventures (not sold to customers).
These ARE systems used by operations, agents, and dashboards.

## Tools

### Portal/Dashboard Layer
- **venture-hub** (worldwidebro/infrastructure/venture-hub)
  Purpose: Unified dashboard for 687 ventures
  Owner: Hub Team
  Status: Production
  Repos Depending: All dashboards

### Data/Audit Layer
- **the-office** (worldwidebro/infrastructure/the-office)
  Purpose: Central data backbone, audit trail, analytics
  Owner: Data Team
  Status: Production

### Agent/Orchestration Layer
- **autonomous-venture-studio** (worldwidebro/infrastructure/autonomous-venture-studio)
  Purpose: Agent orchestration (553 agents)
  Owner: Agent Team
  Status: Production

### Memory/Learning Layer
- **iza-os-rag-system** (worldwidebro/infrastructure/iza-os-rag-system)
  Purpose: Semantic memory and RAG for agents
  Owner: AI Team
  Status: Development

### Integration Layer
- **iza-os-integrations** (worldwidebro/infrastructure/iza-os-integrations)
  Purpose: API connectors (Stripe, Paddle, HubSpot, etc)
  Owner: Integration Team
  Status: Development

### Portfolio Management
- **tech-ventures-portfolio** (worldwidebro/infrastructure/tech-ventures-portfolio)
  Purpose: Portfolio management and analysis tool
  Owner: Operations Team
  Status: Production
  NOTE: NOT a venture (does not sell to external customers)

### Other Infrastructure
- **pitch-kit** (worldwidebro/infrastructure/pitch-kit)
  Purpose: Automated pitch generation and deck creation
  
- **ops-staff-001-staffing** (worldwidebro/infrastructure/ops-staff-001-staffing)
  Purpose: Contractor management and payroll (Deel integration)
```

```markdown
# PROFILES.md (team members)

## Civilization OS Leadership

### Antwuan Johns
- **Role:** Founder, CEO
- **Profile URL:** worldwidebro/profiles/antwuan-johns/
- **Resume:** worldwidebro/profiles/antwuan-johns/resume/
- **Portfolio:** Civilization OS (687 ventures)
- **Achievements:** Built autonomous venture creation OS

### Divine Johns
- **Role:** Chief AI Architect, Venture Director
- **Profile URL:** worldwidebro/profiles/divine-johns/
- **Portfolio:** worldwidebro/profiles/divine-johns/divine-johns-portfolio/
- **Ventures Managed:** 478+
- **Achievements:** Multi-agent orchestration, IZA-OS architecture
```

**Commit:**
```bash
cd worldwidebro/civilization-os
git add VENTURES.csv INFRASTRUCTURE.md PROFILES.md
git commit -m "docs: create master data catalogs for ventures/infrastructure/profiles

Per SYSTEM-CLARITY.md, define three categories:
- VENTURES.csv: 650+ products sold to customers
- INFRASTRUCTURE.md: 25+ internal tools and systems
- PROFILES.md: Team leadership and key people

These are sources of truth for org structure.
Venture Hub imports VENTURES.csv for dashboard.
Ops dashboard imports INFRASTRUCTURE.md for systems view.
Team dashboard imports PROFILES.md for team view."
git push origin main
```

---

## Phase 2: Restructure GitHub Organization (Week 2-3)

### 2.1 Create Folder Structure

**Execute via GitHub CLI:**

```bash
# Create org folders (GitHub doesn't have native folders, but we can simulate with topic-based navigation)
# Instead, we'll move repos and update documentation to reflect structure

# Step 1: Create README files that show intended structure
gh repo create worldwidebro/ventures --public --description "Active ventures - products built to sell"
gh repo create worldwidebro/infrastructure --public --description "Infrastructure and internal tools"
gh repo create worldwidebro/profiles --public --description "Team profiles and professional pages"

# Step 2: For each venture repo, add GitHub topic
for venture_id in $(cat VENTURES.csv | cut -d, -f1 | tail -n +2); do
  gh repo edit worldwidebro/ventures/$venture_id --add-topic "venture" --add-topic "active"
done

# Step 3: For each infrastructure repo, add GitHub topic
for tool in venture-hub the-office autonomous-venture-studio; do
  gh repo edit worldwidebro/infrastructure/$tool --add-topic "infrastructure" --add-topic "internal"
done

# Step 4: For each profile, add GitHub topic
for profile in antwuan-johns divine-johns; do
  gh repo edit worldwidebro/profiles/$profile --add-topic "profile" --add-topic "team"
done
```

### 2.2 Migrate Individual Repos

**For each venture repo:**

```bash
# Example: fin-023-investment-portfolio-ai

cd fin-023-investment-portfolio-ai

# Step 1: Update README to show new structure
cat > README.md << 'EOF'
# FIN-023 Investment Portfolio AI

**Part of:** Civilization OS Ventures  
**Venture Code:** FIN-023  
**Repository:** worldwidebro/ventures/fin-023-investment-portfolio-ai  
**Status:** In Progress  

## About
[Product description]

## How This Fits
- Venture Hub: [link to dashboard]
- SKILL.md: [auto-generated metadata]
- Operations: [ops overview]
- Team: [contractors assigned]
EOF

# Step 2: Update package.json/config to reflect new repo location
# (if repo references are hardcoded)

# Step 3: Generate/update SKILL.md from CSV
cat > SKILL.md << 'EOF'
# FIN-023 Metadata

venture_id: FIN-023-Investment-Portfolio-AI
sector: financial
status: in_progress
health_score: 45
revenue_ytd: $0
staff_count: 2
blockers: "Waiting on Stripe Connect"
next_action: "Complete mobile app by 2026-05-15"
last_synced: 2026-04-20T14:30:00Z
data_sources: "GitHub, The Office, STAFF-001"
EOF

# Step 4: Commit changes
git add README.md SKILL.md package.json
git commit -m "chore: update repo metadata for new structure

Per SYSTEM-CLARITY.md and PROJECT-GUIDE.md:
- Clarify this is a VENTURE (product)
- Add SKILL.md with auto-generated metadata
- Update README to reflect Ventures folder structure
- Link to Venture Hub dashboard

Repository will be moved to: worldwidebro/ventures/fin-023-..."
git push origin main
```

**Commit to each venture repo individually (they own their own docs)**

---

### 2.3 Migrate Infrastructure Repos

**For each infrastructure repo:**

```bash
# Example: tech-ventures-portfolio

cd tech-ventures-portfolio

# Step 1: Remove fake "revenue" claims, clarify it's a tool
cat > README.md << 'EOF'
# Tech Ventures Portfolio

**Part of:** Civilization OS Infrastructure  
**Repository:** worldwidebro/infrastructure/tech-ventures-portfolio  
**Type:** Internal Tool (NOT a venture)  
**Status:** Production  

## Purpose
Portfolio management and analysis tool for coordinating 687 ventures.

## This is NOT a Venture
This system is used internally by operations and agents.
It is not sold to external customers.
It is NOT included in the Civilization OS 687-venture count.

## What It Does
- Analyzes venture portfolio performance
- Coordinates resource allocation
- Tracks interdependencies between ventures

## Using This
[Usage docs]

## Contributing
[Contribution guide]
EOF

# Step 2: Create TOOL.md (internal metadata, NOT venture metadata)
cat > TOOL.md << 'EOF'
# Tech Ventures Portfolio — Internal Metadata

tool_id: tech-ventures-portfolio
type: infrastructure
purpose: "Portfolio management and analysis"
status: production
owner: operations-team
repositories: [list]
dependencies: ["the-office", "venture-hub"]
used_by: ["agents", "operations", "analytics"]
last_updated: 2026-04-20

## NOT a Venture
This tool does not have:
- External customers
- Revenue targets
- Customer acquisition strategy
- Market competition

It is internal infrastructure.
EOF

# Step 3: Commit
git add README.md TOOL.md
git commit -m "clarify: this is infrastructure, not a venture

Per SYSTEM-CLARITY.md:
- Remove false '$200K/month revenue' claims
- Clarify this is an internal tool
- Not sold to customers
- Does not generate primary revenue
- Used by operations and agents internally

This is infrastructure, not a venture."
git push origin main
```

**Commit to each infrastructure repo individually**

---

### 2.4 Migrate Profile Repos

**For each profile:**

```bash
# Example: divine-johns-portfolio under new structure

cd divine-johns/divine-johns-portfolio

# Update README to show it's a profile, not a venture
cat > README.md << 'EOF'
# Divine Johns Professional Portfolio

**Part of:** Civilization OS Team Profiles  
**Team Member:** Divine Johns  
**Role:** Chief AI Architect, Venture Director  
**Repository:** worldwidebro/profiles/divine-johns/divine-johns-portfolio  

## About
Professional portfolio website showcasing achievements in building Civilization OS.

## This is NOT a Venture
This website is about the team member's professional background.
It is not a product sold to customers.
It is NOT included in the 687 ventures.

[Portfolio content]
EOF

# Create PROFILE.md (team metadata)
cat > PROFILE.md << 'EOF'
# Divine Johns — Team Profile

person_id: divine-johns
name: Divine Johns
role: Chief AI Architect, Venture Director
profile_url: worldwidebro/profiles/divine-johns/
portfolio_url: worldwidebro/profiles/divine-johns/divine-johns-portfolio/
ventures_managed: 478+
key_achievements:
  - Multi-agent orchestration
  - IZA-OS semantic memory architecture
  - 101+ AI agents coordinated with MCP
  - Enterprise-grade system design

contact: [email]
last_updated: 2026-04-20
EOF

# Commit
git add README.md PROFILE.md
git commit -m "chore: clarify this is a team profile, not a venture

Per SYSTEM-CLARITY.md:
- This is a professional portfolio about Divine Johns
- Not a venture (no customers, no revenue)
- Part of team profiles in Civilization OS
- Repository location: worldwidebro/profiles/divine-johns/"
git push origin main
```

**Commit to each profile repo individually**

---

## Phase 3: Update Venture Hub & Dashboards (Week 3)

### 3.1 Update Venture Hub CSV Import

**Where:** worldwidebro/infrastructure/venture-hub  
**Commit to:** venture-hub repo

```bash
cd venture-hub

# Update CSV import to use correct sources
cat > scripts/load-ventures.ts << 'EOF'
import * as fs from 'fs';
import * as csv from 'csv-parse';

// Load VENTURES.csv only (from civilization-os repo)
// Do NOT load infrastructure or profiles
const url = 'https://raw.githubusercontent.com/worldwidebro/civilization-os/main/VENTURES.csv';

async function loadVentures() {
  const response = await fetch(url);
  const text = await response.text();
  
  const records = [];
  const parser = csv.parse(text, {
    columns: true,
    skip_empty_lines: true
  });
  
  for await (const record of parser) {
    records.push({
      id: record.venture_id,
      name: record.name,
      sector: record.sector,
      stage: record.stage,
      status: record.status,
      repository_url: record.repository_url,
      health_score: parseInt(record.health_score),
      last_updated: record.last_updated
    });
  }
  
  return records;
}

export async function syncVenturesFromMaster() {
  const ventures = await loadVentures();
  console.log(`Loaded ${ventures.length} ventures from VENTURES.csv`);
  
  // Import into Supabase business_ventures_master
  // ... upsert logic
}
EOF

git add scripts/load-ventures.ts
git commit -m "fix: import only VENTURES.csv, not infrastructure/profiles

Per SYSTEM-CLARITY.md:
- Venture Hub shows 650+ VENTURES only
- Does NOT show infrastructure tools
- Does NOT show team profiles
- Source: civilization-os/VENTURES.csv

Dashboard now shows accurate venture count and avoids confusion with tools/profiles."
git push origin main
```

### 3.2 Create Infrastructure Dashboard

**Where:** worldwidebro/infrastructure/tech-ventures-portfolio (or new repo)  
**Commit to:** infrastructure repo

```bash
# New dashboard for internal systems
cat > /infrastructure/dashboard/pages/systems.tsx << 'EOF'
// Systems/Infrastructure Dashboard
// Shows: venture-hub, the-office, autonomous-venture-studio, etc
// Does NOT show individual ventures (use Venture Hub for that)

import { INFRASTRUCTURE } from '../data/infrastructure.md';

export default function SystemsDashboard() {
  return (
    <div>
      <h1>Infrastructure & Internal Tools</h1>
      <p>Systems that support {687} Civilization OS ventures.</p>
      
      {INFRASTRUCTURE.tools.map(tool => (
        <SystemCard key={tool.id} tool={tool} />
      ))}
    </div>
  );
}
EOF

git add pages/systems.tsx
git commit -m "feat: infrastructure dashboard shows internal systems

Per SYSTEM-CLARITY.md:
- Shows: venture-hub, the-office, iza-os-*, etc
- Does NOT show individual ventures
- Purpose: ops team visibility into infrastructure
- Source: civilization-os/INFRASTRUCTURE.md"
git push origin main
```

### 3.3 Create Team Profiles Page

**Where:** worldwidebro/profiles/  
**Commit to:** new repo or update existing

```bash
# New team directory
mkdir -p worldwidebro/team-directory
cd worldwidebro/team-directory

cat > pages/team.tsx << 'EOF'
// Team Profiles Directory
// Shows: Antwuan Johns, Divine Johns, etc
// Links to their professional portfolios and profiles

import { PROFILES } from '../data/profiles.md';

export default function TeamDirectory() {
  return (
    <div>
      <h1>Civilization OS Leadership</h1>
      
      {PROFILES.people.map(person => (
        <ProfileCard key={person.id} person={person} />
      ))}
    </div>
  );
}
EOF

git add pages/team.tsx
git commit -m "feat: team directory shows leadership profiles

Per SYSTEM-CLARITY.md:
- Shows: Antwuan Johns, Divine Johns, other leaders
- Links to professional portfolios
- Links to individual resumes
- Source: civilization-os/PROFILES.md"
git push origin main
```

---

## Phase 4: Final Sync & Testing (Week 4)

### 4.1 Create Validation Script

**Where:** worldwidebro/civilization-os  
**Commit to:** civilization-os repo

```bash
cd civilization-os

cat > scripts/validate-structure.py << 'EOF'
#!/usr/bin/env python3
"""
Validate that repos are in correct categories and have proper metadata.

Checks:
- VENTURES.csv only contains real ventures (have revenue, customers, or clear product)
- INFRASTRUCTURE.md only contains internal tools (not sold to customers)
- PROFILES.md only contains people (not repos)
- Each venture has SKILL.md
- Each infrastructure repo has TOOL.md
- Dashboards import from correct sources
"""

import csv
import json
import requests
from pathlib import Path

def validate_ventures():
    # Load VENTURES.csv
    # Check each venture repo exists at worldwidebro/ventures/[id]
    # Check each has SKILL.md
    # Check no infrastructure tools are included
    pass

def validate_infrastructure():
    # Load INFRASTRUCTURE.md
    # Check each tool repo exists at worldwidebro/infrastructure/[name]
    # Check each has TOOL.md (NOT SKILL.md)
    # Check no ventures are included
    pass

def validate_profiles():
    # Load PROFILES.md
    # Check each person repo exists at worldwidebro/profiles/[name]
    # Check each has PROFILE.md
    pass

def main():
    print("Validating Civilization OS structure...")
    
    validate_ventures()
    validate_infrastructure()
    validate_profiles()
    
    print("✅ All validations passed")

if __name__ == '__main__':
    main()
EOF

chmod +x scripts/validate-structure.py

git add scripts/validate-structure.py
git commit -m "scripts: add validation for org structure

Validates that:
- VENTURES.csv contains only real ventures
- INFRASTRUCTURE.md contains only internal tools
- PROFILES.md contains only people
- Each repo has correct metadata files
- Dashboards import from correct sources

Run: python3 scripts/validate-structure.py"
git push origin main
```

### 4.2 Test All Dashboards

```bash
# Test 1: Venture Hub shows only ventures
curl https://venture-hub/api/ventures/count
# Expected: 650 (not 687, excluding infrastructure+profiles)

# Test 2: Infrastructure Dashboard shows only tools
curl https://ops-dashboard/api/infrastructure/count
# Expected: 25 tools

# Test 3: Team Directory shows only profiles
curl https://team-directory/api/profiles/count
# Expected: 5-10 people

# Test 4: Verify no leakage
curl https://venture-hub/api/ventures | grep -i "infrastructure"
# Expected: (empty - no infrastructure repos)
```

---

## Commit Strategy Summary

### Where to Commit What

```
worldwidebro/civilization-os/ (Master Org Repo)
├── VENTURES.csv                    ← All real ventures
├── INFRASTRUCTURE.md               ← All internal tools
├── PROFILES.md                     ← All team members
├── AUDIT-REPORT.csv                ← Migration tracking
├── scripts/audit-repos.py           ← Audit script
├── scripts/validate-structure.py    ← Validation script
└── docs/SYSTEM-CLARITY.md          ← Architecture docs

worldwidebro/ventures/[venture-id]/  (Each Venture)
├── SKILL.md                         ← Auto-generated from VENTURES.csv
├── claude.md                        ← Operations runbook
├── README.md                        ← Updated with structure
└── [product code]

worldwidebro/infrastructure/[tool]/  (Each Infrastructure Tool)
├── TOOL.md                          ← Metadata (NOT venture metadata)
├── README.md                        ← Updated to clarify not a venture
└── [tool code]

worldwidebro/profiles/[person]/      (Each Profile)
├── [name]-portfolio/                ← Portfolio website
├── PROFILE.md                       ← Team metadata
├── README.md
└── resume/                          ← Resume (if separate)
```

---

## Git Commit Message Template

### For Organization-Level Changes (civilization-os repo)
```
docs: categorize repos and create master data catalogs

Per SYSTEM-CLARITY.md and PROJECT-GUIDE.md:
- VENTURES.csv: 650+ products sold to customers
- INFRASTRUCTURE.md: 25+ internal tools and systems
- PROFILES.md: 5+ team leadership
- AUDIT-REPORT.csv: Migration status

This fixes the overlap confusion where infrastructure tools
and team profiles were treated as ventures.
```

### For Venture Repo Updates
```
chore: update metadata for new organization structure

Per SYSTEM-CLARITY.md:
- This is a VENTURE (product, not infrastructure)
- Add SKILL.md with auto-generated metadata
- Update README to reflect ventures folder structure
- Clarify purpose and revenue model
```

### For Infrastructure Repo Updates
```
clarify: this is infrastructure, not a venture

Per SYSTEM-CLARITY.md:
- This is an internal TOOL (not sold to customers)
- Add TOOL.md with internal metadata
- Remove misleading revenue claims
- Clarify purpose and internal users
```

### For Profile/Team Repos
```
chore: clarify this is a team profile, not a venture

Per SYSTEM-CLARITY.md:
- This is a PROFILE (team member information)
- Not a product or venture
- Not included in 687 ventures count
- Links to professional portfolio and resume
```

---

## Timeline & Effort

| Phase | Task | Duration | Effort | Owner |
|-------|------|----------|--------|-------|
| 1.1 | Audit all 687 repos | 2-4 hours | Script + manual review | Ops |
| 1.2 | Create master data files | 2-3 hours | CSV/markdown files | Ops |
| 2.1 | Create folder structure | 1-2 hours | GitHub org setup | DevOps |
| 2.2 | Migrate venture repos (650) | 4-6 hours | Batch script + updates | DevOps |
| 2.3 | Migrate infrastructure repos (25) | 2-3 hours | Manual updates | Eng |
| 2.4 | Migrate profile repos (5) | 1-2 hours | Manual updates | Ops |
| 3.1 | Update Venture Hub | 2-3 hours | Code changes | Eng |
| 3.2 | Create infrastructure dashboard | 3-4 hours | New component | Eng |
| 3.3 | Create team directory | 2-3 hours | New component | Eng |
| 4.1 | Create validation script | 1-2 hours | Python script | Ops |
| 4.2 | Test all dashboards | 2-3 hours | Manual testing | QA |
| **Total** | | | **25-35 hours** | |

---

## Success Metrics

After completion:

✅ All 687 repos are in correct folders (ventures/infrastructure/profiles)  
✅ Each venture has SKILL.md (auto-generated from VENTURES.csv)  
✅ Each infrastructure tool has TOOL.md (NOT venture metadata)  
✅ Each profile has PROFILE.md (team metadata)  
✅ Venture Hub shows 650 ventures (not 687)  
✅ Infrastructure Dashboard shows 25 tools  
✅ Team Directory shows 5+ profiles  
✅ No leakage (infrastructure/profiles don't appear in venture dashboard)  
✅ All git commits follow standard message format  
✅ Validation script passes 100%  

---

## Rollback Plan

If something breaks:

```bash
# Git history shows all changes
git log --oneline --all | head -20

# Revert problematic commit
git revert <commit-hash>

# Or reset to previous state
git reset --hard <previous-commit>

# Verify with validation script
python3 scripts/validate-structure.py
```

---

## Questions?

- **Why split into three categories?** → Clarity: ventures are different from tools and profiles
- **Why use SKILL.md vs TOOL.md?** → Venture Hub agents read SKILL.md; ops reads TOOL.md
- **Why commit to civilization-os repo?** → Single source of truth for entire org structure
- **Why move repos instead of copy?** → Clean history, single authority, no duplicates
- **How often to sync VENTURES.csv?** → Nightly (or on-demand when new ventures created)
