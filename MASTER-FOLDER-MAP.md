# MASTER FOLDER MAP — Civilization OS
# Complete structure across ALL devices, ALL systems
# Updated: 2026-03-14

---

## DEVICE OVERVIEW

| Device | Role | Key Storage |
|--------|------|-------------|
| MacBook Air (acebless) | Dev + Claude Code | ~/Documents/Civilization OS/, venture-hub |
| T7 Shield (USB → Air) | Active working SSD | /Volumes/T7 Shield/ |
| Mac Studio (divinejohns) | Heavy AI + Docker | ~/Iza-OS-Tree-of-Life/, /Volumes/LaCie/ |
| Supabase (always-on) | Source of truth DB | project: cyhzilqldouzgynacqpe |
| GitHub (Worldwidebro) | Code + version control | 687 repos |

---

## ═══════════════════════════════════════
## MACBOOK AIR — Primary Working Machine
## ═══════════════════════════════════════

```
~/Documents/Civilization OS/                   ← MAIN COS DIRECTORY (114.9MB)
│
├── 00-core-infrastructure/                    ← Governance, infra config
│   └── docker/docker-compose.yml              ← (moved here from home)
│
├── 020-20-ventures/                           ← VENTURE SECTOR FOLDERS
│   ├── 01-beauty-wellness/   (BW | 40 ventures)
│   │   ├── _data/            ← per-venture data files
│   │   ├── _tasks/           ← task docs
│   │   └── _presell/         ← pre-sell content
│   ├── 02-community/         (COM | 50 ventures)
│   ├── 03-ecommerce/         (EC | 110 ventures) ← HIGHEST PRIORITY
│   ├── 04-education/         (EDU | 40 ventures)
│   ├── 05-education-training/(ET | 15 ventures)
│   ├── 06-emerging/          (EM | 50 ventures)
│   ├── 07-financial/         (FIN | 41 ventures) ← HIGH PRIORITY
│   ├── 08-fitness-sports/    (FS | 25 ventures)
│   ├── 09-food-hospitality/  (FH | 35 ventures)
│   ├── 10-logistics-transport/(LT | 30 ventures)
│   ├── 11-media-content/     (MC | 20 ventures) ← HIGH PRIORITY
│   ├── 12-operations/        (OPS | 66 ventures)
│   ├── 13-professional-services/(PS | 25 ventures) ← HIGH PRIORITY
│   ├── 14-software-technology/(ST | 30 ventures) ← HIGH PRIORITY
│   ├── 15-specialized/       (SP | 50 ventures)
│   ├── 16-technology/        (TECH | 60 ventures)
│   └── VENTURE-DATA-MAP.md   ← HOW LAYERS CONNECT
│
├── ECOM/                                      ← ECOMMERCE HUB (NEW)
│   ├── skus/
│   │   ├── master-sku-catalog.csv             ← ALL SKUs across ventures
│   │   ├── digital/                           ← digital product specs
│   │   ├── physical/                          ← physical product specs
│   │   ├── services/                          ← service SKUs
│   │   └── inventory-management-system/       ← (moved from root)
│   ├── vendors/
│   │   ├── master-vendor-list.csv             ← Printful, Gumroad, Stripe...
│   │   ├── contacts/
│   │   ├── terms/
│   │   └── onboarding/
│   ├── products/
│   │   ├── live/                              ← selling right now
│   │   │   ├── shopify-autopilot/
│   │   │   ├── personal-shopper-ai/
│   │   │   └── cli-products/
│   │   ├── pre-sell/                          ← sell before building
│   │   │   ├── PRE-SELL-MASTER.md             ← strategy + active SKUs
│   │   │   ├── dropship-hub/
│   │   │   ├── amazon-fba-optimizer/
│   │   │   └── social-commerce-platform/
│   │   ├── waitlist/
│   │   │   └── WAITLIST-SYSTEM.md             ← email capture strategy
│   │   ├── digital-products/
│   │   └── 21-products/                       ← full product catalog
│   ├── pricing/
│   │   ├── bundles/
│   │   └── price-sheets/
│   ├── marketing/
│   │   ├── ad-copy/
│   │   ├── email-sequences/
│   │   │   └── ecommerce-email-automation/
│   │   ├── social-content/
│   │   └── landing-pages/
│   ├── revenue/
│   │   ├── gumroad/gumroad-integration/
│   │   ├── stripe/
│   │   ├── affiliate-sites/
│   │   └── projections/
│   └── campaigns/
│       ├── active/
│       └── templates/
│
├── data/                                      ← DATA ARCHIVE
│   ├── snapshots/
│   │   ├── civilization_os_parsed_structure.json (25MB)
│   │   └── civilization_os_enhanced_index.json
│   ├── registries/
│   │   ├── COMPLETE_AGENT_REGISTRY.json
│   │   ├── UNIFIED_AGENT_REGISTRY.json
│   │   └── agent_registry.json
│   ├── ventures/
│   │   ├── supabase_ventures_678.json
│   │   ├── complete_venture_ecosystem.csv
│   │   └── business_repository_list.csv
│   └── exports/
│       └── worldwidebro_starred_repos.json
│
├── docs/                                      ← ORGANIZED DOCS
│   ├── strategy/
│   │   ├── 90_DAY_LAUNCH_ROADMAP.md
│   │   ├── ADVANCED_MONETIZATION_STRATEGIES.md
│   │   └── 30_DAY_CONTENT_CALENDAR.md
│   ├── agent-guides/
│   │   ├── AGENT_ASSIGNMENTS.md
│   │   └── AGENT_SWARM_DEPLOYMENT_GUIDE.md
│   ├── architecture/
│   └── sessions/
│
├── scripts/                                   ← ALL SCRIPTS
│   ├── venture-creation/
│   │   ├── create_venture_directories.py
│   │   ├── execute_venture_creation.py
│   │   └── run_venture_creation.sh
│   ├── automation/
│   │   ├── get_auth0_token.sh
│   │   └── run_now.sh
│   └── deploy/
│
├── logs/
│   └── civilization-os-automation.log
│
└── venture-hub/                               ← LIVE NEXT.JS APP
    ├── app/
    │   ├── hub/                               ← AI Boss Hub
    │   ├── ventures/                          ← 687 venture dashboard
    │   │   ├── [id]/                          ← single venture page
    │   │   └── fin-001/                       ← GenixBank dedicated
    │   ├── presell/                           ← PRE-SELL PAGES (NEW)
    │   │   └── [slug]/                        ← per-product presell
    │   ├── waitlist/                          ← WAITLIST PAGES (NEW)
    │   │   └── [slug]/                        ← per-product waitlist
    │   ├── ecom/                              ← ECOM DASHBOARD (NEW)
    │   ├── directory/
    │   ├── sectors/
    │   ├── pricing/
    │   └── api/
    │       ├── ventures/
    │       ├── waitlist/                      ← NEW
    │       └── presell/                       ← NEW
    ├── config/
    │   ├── claude-ollama.json
    │   └── openclaw-agents.json
    └── data/
        ├── venture_registry.json
        └── master-sku-catalog.csv             ← link to ECOM/skus/
```

---

## ═══════════════════════════════════════
## T7 SHIELD — Working SSD (USB on Air)
## ═══════════════════════════════════════

```
/Volumes/T7 Shield/
│
├── 20-ventures/                               ← VENTURE WORKING FILES
│   ├── 01-beauty-wellness/ (BW)
│   │   ├── _data/     ← venture cards, research
│   │   ├── _tasks/    ← sprint tasks
│   │   ├── _assets/   ← logos, images, copy
│   │   └── _presell/  ← presell content + drafts
│   ├── 02-community/ (COM)
│   ├── 03-ecommerce/ (EC) ← 110 ventures, highest priority
│   │   └── [each has _data, _tasks, _assets, _presell]
│   ├── 04-education/ through 16-technology/
│   └── agent-ops/     ← agent coordination files
│
├── Civilization-OS/
│   └── 20-ventures/   ← original venture docs (pre-restructure)
│
├── STRATEGY/
│   ├── content-calendar-2026-03.md
│   └── [sector strategies]
│
├── tasks/
│   ├── todo.md
│   ├── GSD-MASTER-2026-03-13.md
│   └── lessons.md
│
├── scripts/
│   ├── session-start.sh   (civ-start alias)
│   └── agent-dispatch.sh
│
├── docs/
├── execution/
├── n8n-workflows/
├── logs/
├── Obsidian/vault/        ← Obsidian vault
└── Storage-Databases/     ← DB exports
```

---

## ═══════════════════════════════════════
## MAC STUDIO — Compute Machine
## ═══════════════════════════════════════

```
~/Iza-OS-Tree-of-Life/             ← PRIMARY CODE REPO
├── docs/                          ← synced from T7
├── tasks/                         ← synced from T7
├── ops/infra/scripts/             ← synced from T7 scripts
├── agents-global/                 ← Civilization OS agents
│   └── openclaw-gateway.sh        ← Qwen/Ollama gateway
└── ventures/core/workflows/

/Volumes/LaCie/SecondBrain/        ← BULK ARCHIVE (4TB)
├── CivilizationOS/                ← full COS archive
├── Storage-Databases/             ← T7 db exports mirrored
└── AI-Models/ollama-models/       ← Qwen2.5:32b + others
```

---

## ═══════════════════════════════════════
## SUPABASE — Always-On Database
## ═══════════════════════════════════════

```
Project: cyhzilqldouzgynacqpe

Core Tables:
├── business_ventures          (687 rows — master venture list)
├── venture_tasks              (7,048 rows)
├── venture_audit              (687 rows — ICP, competitors)
├── venture_content            (1,374 rows)
├── venture_dashboard_summary  (MATERIALIZED VIEW)
├── aoc_tasks                  (2,983 rows — agent queue)
├── presell_products           (NEW — SKU catalog)
├── waitlist_signups           (NEW — email captures)
└── ecom_vendors               (NEW — vendor list)

Sector breakdown:
├── e-commerce       → 110 ventures (EC-001 to EC-110)
├── technology       → 60 ventures  (TECH-001+)
├── operations       → 66 ventures  (OPS-001+)
├── community        → 50 ventures  (COM-001+)
├── emerging         → 50 ventures  (EM-001+)
├── specialized      → 50 ventures  (SP-001+)
├── financial        → 41 ventures  (FIN-001+)
├── beauty-wellness  → 40 ventures  (BW-001+)
├── education        → 40 ventures  (EDU-001+)
├── software-tech    → 30 ventures  (ST-001+)
└── [6 more sectors]
```

---

## ═══════════════════════════════════════
## GITHUB — Worldwidebro Org
## ═══════════════════════════════════════

```
github.com/Worldwidebro/
├── venture-hub         ← main app (deployed at venture-hub-pi.vercel.app)
├── ec-001-angels-in-daylight
├── ec-002-new-world-apparel
├── ec-003-shopify-autopilot
│   ... (110 EC repos)
├── fin-001-genixbank-lite
│   ... (41 FIN repos)
│   ... (636 more repos)
└── [687 total venture repos]

Naming pattern: {sector-lower}-{num}-{venture-name-lower}
Example: ec-001-angels-in-daylight
```

---

## ═══════════════════════════════════════
## HOW IT ALL CONNECTS — The Data Flow
## ═══════════════════════════════════════

```
Idea/Venture
    │
    ▼
Supabase business_ventures (row)
    │
    ├──→ GitHub repo (Worldwidebro/{venture-slug})
    │         └──→ Code lives here
    │
    ├──→ T7 /20-ventures/{sector}/{venture-id}/
    │         └──→ _data/ _tasks/ _assets/ _presell/
    │
    ├──→ COS /020-20-ventures/{sector}/
    │         └──→ Working docs mirror
    │
    ├──→ ECOM/ (if selling products)
    │         ├──→ skus/master-sku-catalog.csv (SKU row)
    │         ├──→ products/pre-sell/ (presell content)
    │         └──→ products/waitlist/ (waitlist page)
    │
    └──→ venture-hub app
              ├──→ /ventures/{business-id}  (dashboard)
              ├──→ /presell/{slug}          (sell before building)
              └──→ /waitlist/{slug}         (collect emails)
```

---

## ═══════════════════════════════════════
## AGENTS + ORCHESTRATION
## ═══════════════════════════════════════

```
Claude Code (MacBook Air)
    └── creates repos, writes code, manages Supabase

OpenClaw Gateway (Mac Studio → port 3333)
    └── routes tasks from aoc_tasks → Qwen2.5:32b
    └── start: ssh mac-studio → openclaw-gateway.sh

Clawd Cursor (TO ADD on Mac Studio)
    └── GUI automation — sees screen, executes UI tasks
    └── plug into aoc_tasks as 'clawd-cursor' agent
    └── repo: github.com/AmrDab/clawd-cursor

OpenVikings (openclaw-gateway)
    └── configs at: venture-hub/config/openclaw-agents.json
    └── gateway log: ~/openviking.log

n8n (Mac Studio)
    └── hourly: checks aoc_tasks, dispatches to agents
    └── workflows: /Volumes/T7 Shield/n8n-workflows/
```
