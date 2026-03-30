# /scaffold-venture [business_id]

Create the full STAGE 1 scaffold for a venture: GitHub repo + all required files.

## Usage
```
/scaffold-venture ec-044
/scaffold-venture fin-001
```

## Steps

1. **Load venture data from Supabase:**
```sql
SELECT bv.name, bv.sector, bv.business_id, bv.description,
       va.icp_title, va.competitors, va.first_dollar_action
FROM business_ventures bv
LEFT JOIN venture_audit va ON va.business_id = bv.business_id
WHERE bv.business_id = '$ARGUMENTS';
```

2. **Derive repo name** from sector + business_id + name:
   - Pattern: `{sector-code}-{NNN}-{venture-name-kebab}`
   - Example: `ec-044-live-commerce-platform`

3. **Create private GitHub repo:**
```bash
gh repo create Worldwidebro/{repo_name} --private --description "{venture description}"
```

4. **Push scaffold files** (create locally, push in one commit):

   **README.md** — include: business_id, sector, first_dollar_action, venture-hub link

   **VENTURE.json:**
   ```json
   {
     "business_id": "...",
     "name": "...",
     "sector": "...",
     "stage": "SCAFFOLD",
     "first_dollar_action": "...",
     "venture_hub_url": "https://venture-hub-pi.vercel.app/ventures/{business_id}",
     "created_at": "{ISO date}"
   }
   ```

   **.gitignore** — block .env, *.key, *.secret, node_modules, .DS_Store

   **docs/ICP.md** — from `venture_audit.icp_title`

   **docs/COMPETITORS.md** — from `venture_audit.competitors`

5. **Mark task complete in Supabase:**
```sql
UPDATE aoc_tasks SET status='success', completed_at=now()
WHERE venture_id = '$ARGUMENTS' AND task_type = 'scaffold';
```

6. **Confirm:** Print repo URL and venture-hub URL.

## Sector Code Reference
```
bw ec edu et em fin fs fh lt mc ops ps st spec tech comm
```
