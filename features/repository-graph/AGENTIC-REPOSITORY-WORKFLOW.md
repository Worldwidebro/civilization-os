# Agentic Repository & Copilot Awareness: Stale → Live → Autonomous

This document specifies a 12-phase agentic data/graph workflow and a 100-action "Repository Awareness Protocol" to make GitHub Copilot and coding agents operationally aware across a large repository ecosystem.

Status: draft

## Location
This file is added to features/repository-graph/AGENTIC-REPOSITORY-WORKFLOW.md on branch `add/repository-graph-plans`.

---

## Overview
Goal: give coding agents (Copilot and others) a canonical Repository Knowledge Graph and an Awareness Protocol so they know what exists, what it means, how it connects, what depends on it, what can be reused, what changed, and what impact a proposed change will have—before writing code.

This doc contains:
- 12-phase Stale → Live → Autonomous pipeline
- 100 GitHub Copilot Awareness Actions (Repository Awareness Protocol)
- Suggested storage and implementation mapping
- Suggested next steps and automation checklist

---

## 12 Phases (Stale → Live → Autonomous)

Phase 0 — Intake
- Goal: understand what needs to become live.
- Inputs: Client, Dataset, Business objective, Required freshness, Required outputs, Compliance requirements.
- Outputs: Data mission, success criteria, sources required, freshness SLA, quality SLA, output requirements.

Phase 1 — Discover
- Goal: find everything relevant (databases, APIs, files, repos, systems, existing graphs, pipelines).
- Output: Source registry.

Phase 2 — Profile
- Goal: understand the data before touching it (schema, volume, duplicates, freshness, relationships).
- Output: Data profile + quality & freshness scores.

Phase 3 — Ingest
- Goal: bring information into the platform (API, DB, CSV, PDF, JSON, events) into a RAW data lake.
- Note: nothing is truth yet.

Phase 4 — Clean + Resolve
- Goal: normalize, deduplicate, entity resolution, identity matching, conflict resolution → canonical records with provenance.

Phase 5 — Model
- Goal: determine entities, properties, relationships, ontology, constraints, and node/edge design.

Phase 6 — Build Graph
- Goal: construct the knowledge graph and store source, timestamp, confidence, lineage, version with facts.

Phase 7 — Validate
- Goal: schema/entity/relationship validity, duplicates, contradictions, source credibility, freshness, confidence.
- Outcomes: PASS → production, FAIL → remediation, UNCERTAIN → human review.

Phase 8 — Activate
- Goal: connect the graph to APIs, dashboards, RAG, applications, agents, reports, workflows so data becomes operational.

Phase 9 — Monitor
- Goal: watch freshness, data quality, source availability, schema changes, graph health, API health, agent performance.
- Example: detect stale facts and trigger refresh.

Phase 10 — Learn
- Goal: record what worked/failed, convert proven procedures into reusable skills (task → execution → evaluation → skill update).

Phase 11 — Automate
- Goal: progressively reduce human intervention: manual → assisted → supervised → autonomous based on confidence thresholds.

Phase 12 — Continuous Operation
- Goal: controlled autonomous operating state: continuous detection, retrieval, resolution, reconcile, validate, update, publish loop.

Completion gates: each phase has a hard exit criterion (e.g., Intake: mission defined; Discovery: sources mapped; Profiling: data understood; … Continuous: autonomous refresh operating).

Three completion states: Data Complete, Knowledge Complete, Operationally Complete (Level 3 target).

---

## Repository Connection Agentic Workflow (summary)

Discover repos → Identify/Register → Ingest code + metadata → Understand repository → Extract connections → Resolve entities → Build repository graph → Map capabilities → Discover synergies → Test connections → Create integrations → Deploy/Activate → Monitor changes → Update graph (loop)

---

## 100 GitHub Copilot Awareness Actions (Repository Awareness Protocol)

This is the canonical 100-action checklist to make Copilot aware before edits. Use as a structured set of awareness gates in .github/awareness and copilot-instructions.

A. Identity & Registry — 1–10
1. Identify the repository.
2. Read the canonical repository ID.
3. Read the repository's canonical name.
4. Identify owner/organization.
5. Identify whether it is owned, forked, mirrored, archived, or external.
6. Check the canonical repository registry.
7. Detect duplicate repository names.
8. Detect duplicate implementations.
9. Detect renamed repositories.
10. Establish the repository's canonical identity before modifying anything.

B. Repository Understanding — 11–20
11. Read the README.
12. Read architecture documentation.
13. Read contribution guidelines.
14. Read repository instructions.
15. Read agent instructions.
16. Inspect directory structure.
17. Identify primary languages.
18. Identify frameworks.
19. Identify runtime requirements.
20. Determine the repository's actual purpose from code—not only its README.

C. Codebase Awareness — 21–30
21. Map files to modules.
22. Map modules to packages.
23. Identify classes.
24. Identify functions.
25. Identify services.
26. Identify entry points.
27. Identify configuration files.
28. Identify environment variables.
29. Identify executable workflows.
30. Identify the critical execution paths.

D. Dependency Awareness — 31–40
31. Read package manifests.
32. Identify direct dependencies.
33. Identify transitive dependencies.
34. Identify internal repository dependencies.
35. Identify external APIs.
36. Identify databases.
37. Identify queues/event systems.
38. Identify infrastructure dependencies.
39. Identify version constraints.
40. Identify potential breaking dependencies.

E. Repository Graph — 41–50
41. Create the repository's graph node.
42. Connect it to its capabilities.
43. Connect it to dependencies.
44. Connect it to upstream repositories.
45. Connect it to downstream repositories.
46. Connect it to agents.
47. Connect it to skills.
48. Connect it to ventures.
49. Connect it to tools/services.
50. Connect it to relevant datasets and documents.

F. Capability Awareness — 51–60
51. Determine what capability the repository provides.
52. Identify secondary capabilities.
53. Identify capabilities implemented elsewhere.
54. Detect duplicate capability implementations.
55. Find repositories providing the same capability.
56. Find repositories that could extend the capability.
57. Find missing capabilities.
58. Determine whether the repository is reusable.
59. Determine whether it should become a shared service.
60. Register capability mappings.

G. Task Awareness — 61–70
61. Understand the requested outcome.
62. Translate the request into required capabilities.
63. Find repositories implementing those capabilities.
64. Identify existing code that should be reused.
65. Identify workflows that already solve part of the task.
66. Identify existing skills that can perform portions of the task.
67. Identify affected repositories.
68. Identify affected ventures.
69. Identify affected services.
70. Create an implementation plan before editing.

H. Impact Awareness — 71–80
71. Determine what files will change.
72. Determine what modules will change.
73. Determine what APIs could change.
74. Determine what repositories could be affected.
75. Determine what workflows could be affected.
76. Determine what agents could be affected.
77. Determine what capabilities could be affected.
78. Determine what ventures could be affected.
79. Determine whether the change is backward-compatible.
80. Produce an impact report before implementation.

I. Implementation Awareness — 81–90
81. Reuse existing components before creating new ones.
82. Follow repository architecture.
83. Follow coding standards.
84. Follow dependency policies.
85. Preserve existing APIs unless explicitly changing them.
86. Add tests for new behavior.
87. Add integration tests for repository connections.
88. Update documentation.
89. Update the repository registry after structural changes.
90. Update the capability graph after capability changes.

J. Verification & Continuous Awareness — 91–100
91. Run unit tests.
92. Run integration tests.
93. Run repository builds.
94. Run security checks.
95. Run dependency checks.
96. Compare behavior before and after the change.
97. Inspect CI results.
98. Update the repository graph.
99. Record what changed and why.
100. Learn from the completed task and make the successful procedure reusable as a skill.

---

## Where to put awareness artifacts in a repo
Example directory layout (suggested .github/ structure):

.github/
├── copilot-instructions.md
├── awareness/
│   ├── 01-identity.md
│   ├── 02-repository.md
│   ├── 03-codebase.md
│   ├── 04-dependencies.md
│   ├── 05-graph.md
│   ├── 06-capabilities.md
│   ├── 07-task.md
│   ├── 08-impact.md
│   ├── 09-implementation.md
│   └── 10-verification.md

skills/
├── repository-discovery/
├── dependency-analysis/
├── capability-mapping/
├── graph-update/
├── integration/
└── stale-to-live/

workflows/
├── repository-audit.yml
├── dependency-audit.yml
├── capability-audit.yml
├── graph-sync.yml
└── awareness-refresh.yml

---

## Storage and implementation mapping (recommended defaults)
- Raw repo snapshots (artifacts, blobs): MinIO or S3 (object storage).
- Operational metadata & registry: PostgreSQL.
- Knowledge graph: Neo4j (or alternate graph DB).
- Vector embeddings / retrieval memory: Qdrant.
- Documents/PDFs: object store + embedding pipeline (Stirling PDF or similar).
- Agent/tracing/observability: Langfuse.

---

## Tool mapping (example)
Include the list of tools you provided and recommended role assignments in the doc. Example: Graphify for graph generation, Serena for semantic code understanding, Qdrant for vectors, Neo4j for graph store, MinIO for storage, Langfuse for traces, etc.

---

## Next engineering steps (initial roadmap & checklist)
1. Merge this doc into the default docs (review + approve PR).  
2. Add GitHub Actions: graph-sync.yml (nightly) and awareness-refresh.yml (on push/webhook).  
3. Implement a Repository Discovery job that enumerates org repos and writes a minimal registry entry to Postgres.  
4. Add snapshots: clone repositories and store snapshots into object storage (MinIO).  
5. Run static analysis pipeline (imports, manifests, infra, CI) and write candidate edges to a staging graph.  
6. Run entity resolution and canonicalization.  
7. Push validated nodes/edges into Neo4j and embeddings into Qdrant.  
8. Expose API and UI for queries and impact reports.  
9. Iterate and extend agents and skills; add security/license checks.  

---

## Questions / decisions required
- Confirm adding this file to Worldwidebro/civilization-os at the given path (this commit will add it to branch `add/repository-graph-plans`).
- Do you want the initial discovery to run against all repos in the Worldwidebro account? (This can be large; option: start with a curated list.)
- Preferred storage: MinIO (self-host) or S3-compatible? If none, I will list both options and default to MinIO in the doc.
- Do you want me to include the OmniRoute link and the tool table verbatim in the doc? (I will unless you ask me not to.)

---

This commit adds the plan document. After you confirm the questions above, I will:
- update the doc with your preferences,
- open a PR description (note: I cannot create a pull request via this toolset, so I will provide the exact PR title/body and next steps for you to open the PR or we can proceed collaboratively), and
- prepare GitHub Actions and initial discovery job templates as follow-up commits on the same branch if you want.
