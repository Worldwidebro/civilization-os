# /claim-task

Claim the next available task from the Civilization OS agent queue and load full venture context.

## Steps

1. Run the connection health check first:
```bash
bash scripts/check-connections.sh
```

2. Claim the next `claude-code` task from Supabase:
```sql
SELECT claim_next_task('claude-code');
```

3. Using the returned `venture_id` and `task_id`, load full venture context:
```sql
SELECT bv.*, va.*, vc.*
FROM business_ventures bv
LEFT JOIN venture_audit va   ON va.business_id = bv.business_id
LEFT JOIN venture_content vc ON vc.business_id = bv.business_id
WHERE bv.business_id = '{venture_id}';
```

4. Print a summary:
- Task ID, task type, venture name, sector
- Current stage (SCAFFOLD / PRE-SELL / MVP / OPERATE / SCALE)
- `first_dollar_action` from venture_audit
- ICP title

5. Ask the user: "Ready to begin work on this task?"

## Notes
- Only claim tasks with `agent = 'claude-code'`
- If no tasks available, report queue depth and suggest checking `aoc_tasks` table
- Never claim tasks belonging to other agents (qwen-agent, n8n-automation, etc.)
