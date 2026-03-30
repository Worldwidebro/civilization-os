# /task-complete [task_id]

Mark a claimed task as complete in Supabase and log the outcome.

## Usage
```
/task-complete 1a2b3c4d
```

## Steps

1. Mark success in `aoc_tasks`:
```sql
UPDATE aoc_tasks
SET status = 'success', completed_at = now()
WHERE id = '$ARGUMENTS'
  AND agent = 'claude-code';
```

2. Verify the update returned exactly 1 row. If 0 rows updated:
   - Check that the task ID is correct
   - Check that `agent = 'claude-code'` (you can only complete your own tasks)

3. Fetch the venture context to log what was delivered:
```sql
SELECT t.task_type, t.venture_id, bv.name, bv.sector
FROM aoc_tasks t
JOIN business_ventures bv ON bv.business_id = t.venture_id
WHERE t.id = '$ARGUMENTS';
```

4. Print confirmation:
```
✅ Task complete
   ID:      {task_id}
   Venture: {venture_name} ({venture_id})
   Type:    {task_type}
   Time:    {completed_at}

Next: /claim-task  to pick up the next item
```

## Notes
- Never mark another agent's task complete
- If the task produced a GitHub repo, include the URL in your confirmation
- If the task produced Supabase data changes, confirm the rows written
