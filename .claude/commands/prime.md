# /prime

Load full Civilization OS context so Claude understands the current state of the system before starting work.

## Steps

1. Read key project files into context:
   - `CLAUDE.md` — identity, layers, security rules
   - `AGENT_OPERATIONS_MASTER.md` — task claim pattern, stage checklist
   - `MASTER-FOLDER-MAP.md` — all paths across all devices

2. Run connection health check:
```bash
bash scripts/check-connections.sh
```

3. Query live queue depth from Supabase:
```sql
SELECT agent, status, count(*)
FROM aoc_tasks
GROUP BY agent, status
ORDER BY agent, status;
```

4. Query venture completion snapshot:
```sql
SELECT sector, count(*) AS total
FROM business_ventures
GROUP BY sector
ORDER BY total DESC;
```

5. Print a session brief:
```
╔══════════════════════════════════════════╗
║  Civilization OS — Session Brief
║  Date: {today}
║  Agent: claude-code (MacBook Air)
╠══════════════════════════════════════════╣
║  Connections: Supabase ✅  GitHub ✅
║  OpenClaw: ❌ (start on Mac Studio)
╠══════════════════════════════════════════╣
║  Queue: {N} claude-code tasks pending
║  Priority: ec-* → fin-* → ps-*
╠══════════════════════════════════════════╣
║  Next: /claim-task  or  /venture-status all
╚══════════════════════════════════════════╝
```

6. Ask: "Ready to claim a task?"
