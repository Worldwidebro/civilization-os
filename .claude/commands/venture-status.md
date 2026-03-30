# /venture-status [business_id_or_sector]

Show the current completion stage and next actions for one venture or an entire sector.

## Usage
```
/venture-status ec-044
/venture-status fin
/venture-status all
```

## Steps

### Single venture (`/venture-status ec-044`)
1. Query Supabase:
```sql
SELECT bv.name, bv.business_id, bv.sector,
       va.first_dollar_action, va.icp_title,
       (SELECT count(*) FROM aoc_tasks WHERE venture_id = bv.business_id AND status = 'pending') AS pending_tasks,
       (SELECT count(*) FROM aoc_tasks WHERE venture_id = bv.business_id AND status = 'success') AS done_tasks
FROM business_ventures bv
LEFT JOIN venture_audit va ON va.business_id = bv.business_id
WHERE bv.business_id = '$ARGUMENTS';
```

2. Check GitHub for repo existence:
```bash
gh repo view Worldwidebro/{repo_slug} --json name,url,updatedAt 2>/dev/null || echo "NO_REPO"
```

3. Determine stage:
   - No repo → STAGE 0 (needs scaffold)
   - Repo exists, no VENTURE.json → STAGE 1 incomplete
   - VENTURE.json present → check `stage` field

4. Print a status card:
```
╔══════════════════════════════════╗
║  ec-044 · Live Commerce Platform
║  Stage: SCAFFOLD ✅  Pre-Sell ❌
║  Pending tasks: 4
║  Next: /scaffold-venture ec-044
╚══════════════════════════════════╝
```

### Sector summary (`/venture-status ec`)
Query all ventures in the sector and show a table:
- Total ventures, repos created, pending tasks, revenue ($0 until tracked)

### Full dashboard (`/venture-status all`)
Show counts per sector across all 5 stages.
