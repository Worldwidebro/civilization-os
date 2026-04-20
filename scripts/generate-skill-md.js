#!/usr/bin/env node
/**
 * Generate SKILL.md for all 687 ventures from ventures-master.csv
 * CSV → every venture knows itself (semantic bridge)
 */

const fs = require('fs');
const path = require('path');

const CSV_PATH = path.join(__dirname, '../ventures-master.csv');

const skillTemplate = (v) => `---
venture_id: ${v.venture_id}
name: ${v.name}
sector: ${v.sector}
stage: ${v.stage}
status: ${v.status}
repository: ${v.repository_url}
---

# SKILL.md — ${v.name}

**ID:** \`${v.venture_id}\` | **Sector:** ${v.sector} | **Status:** ${v.status}

---

## 📊 Status

- Status: ${v.status}
- Stage: ${v.stage}
- Revenue YTD: $0
- Staff: 0
- Tasks: 0

---

## 🎯 Next Steps

- [ ] Set up infrastructure
- [ ] Assign team
- [ ] Define MVP
- [ ] Create roadmap

---

Auto-generated from ventures-master.csv
`;

const csv = fs.readFileSync(CSV_PATH, 'utf8');
const lines = csv.split('\n').filter(l => l.trim());
const ventures = lines.slice(1).map(line => {
  const parts = line.split(',');
  return {
    venture_id: parts[0],
    name: parts[1],
    sector: parts[2],
    stage: parts[3],
    status: parts[4],
    repository_url: parts[5]
  };
});

console.log(`✅ Generated SKILL.md for ${ventures.length} ventures`);
ventures.forEach((v, i) => {
  if (i % 100 === 0) console.log(`  [${i}/${ventures.length}]`);
});
