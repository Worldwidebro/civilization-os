# Product Roadmap

This roadmap provides milestone-level direction from initial setup through production readiness.

## Foundation

**Objective:** Establish the technical and organizational baseline for product development.

- Define product scope, architecture, and glossary.
- Set up repository standards, contribution process, and CI baseline.
- Implement authentication and organization/user primitives.
- Establish initial data model for goals, initiatives, and tasks.
- Publish first internal documentation set.

## MVP

**Objective:** Deliver a usable core workflow for planning and execution.

- Create initiative planning workflow (goal → initiative → task breakdown).
- Enable assignment, status updates, and basic progress tracking.
- Add governance decision record creation and retrieval.
- Provide baseline notification flow for assignments and blockers.
- Ship initial dashboard for team-level operational visibility.

## Beta

**Objective:** Validate product value with pilot users and iterate quickly.

- Onboard pilot organizations with role-based access controls.
- Add analytics views for milestone progress and throughput trends.
- Improve reliability with background jobs, retries, and monitoring.
- Introduce import/export and selected third-party integrations.
- Capture structured feedback and run iteration cycles.

## Production

**Objective:** Operate as a stable, secure, and scalable platform.

- Harden security controls, auditing, and data retention operations.
- Implement HA deployment patterns and disaster recovery runbooks.
- Define and track formal SLOs and incident response process.
- Expand governance capabilities for multi-organization operations.
- Launch public transparency/reporting options where applicable.

## Current Execution Priorities (2026-03-13 Snapshot)

These priorities convert the current operator backlog into a practical, dependency-aware sequence.

### 1) Unblock Infrastructure First

- Configure Mac Studio + Tailscale baseline (`#47`, `#87`, `#8`) so local AI inference, automation, and sync workflows are stable.
- Stand up MCP integrations for Linear and Notion (`#3`, `#2`) to improve structured planning and cross-tool visibility.
- Connect OpenClaw with Supabase task dispatch (`#22`, `#21`) to enable reliable multi-agent execution.

### 2) Close In-Progress Work Immediately

- Finish Obsidian sector index population by adding the remaining `food-hospitality` file (`#40`).
- Deploy `venture-hub` to production via Vercel (`#98`) using existing `vercel.json`.

### 3) Prioritize First-Dollar Ventures

- Build and launch PS-009 Bookkeeping Service (`#60`) as the fastest adjacent upsell to PS-010.
- Deliver the initial service offers with clear first-dollar milestones: PS-001, PS-005, PS-006, PS-008, and PS-003 (`#29`, `#66`, `#72`, `#84`, `#99`).

### 4) Activate Monetization Rails

- Set up Gumroad and/or Polar product flows (`#30`, `#31`) for immediate checkout and distribution.
- Add Stripe + email capture foundations for venture-hub (`#63`, `#79`) to support conversion and lifecycle automation.

### 5) Improve Operating Cadence

- Run weekly progress automation and reporting (`#50`) from Supabase summary views.
- Batch top-50 venture tasks in `aoc_tasks` (`#59`) and maintain claim/dispatch loops for execution throughput.

### 6) Career/Brand Leverage Track

- Complete and publish the portfolio improvements (`#7`, `#18`, `#19`) and generate case studies (`#81`).
- Execute first 10 job applications with tailored assets (`#20`) to parallelize personal income opportunities with venture execution.
