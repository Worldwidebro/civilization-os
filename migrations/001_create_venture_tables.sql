-- Mission: Create 7 missing tables to complete semantic hub

CREATE TABLE business_ventures_master (
  venture_id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  sector TEXT NOT NULL,
  stage TEXT, status TEXT,
  repository_url TEXT,
  revenue_ytd DECIMAL(12,2) DEFAULT 0,
  costs_mom DECIMAL(12,2) DEFAULT 0,
  staff_count INTEGER DEFAULT 0,
  blockers JSONB, next_action TEXT,
  last_synced_at TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE venture_revenue_summary (
  id SERIAL PRIMARY KEY,
  venture_id TEXT REFERENCES business_ventures_master(venture_id),
  month_date DATE NOT NULL,
  revenue_gross DECIMAL(12,2) DEFAULT 0,
  revenue_net DECIMAL(12,2) DEFAULT 0,
  costs_operational DECIMAL(12,2) DEFAULT 0,
  costs_staff DECIMAL(12,2) DEFAULT 0,
  costs_infrastructure DECIMAL(12,2) DEFAULT 0,
  profit DECIMAL(12,2) DEFAULT 0,
  margin_percent DECIMAL(5,2) DEFAULT 0,
  calculated_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(venture_id, month_date)
);

CREATE TABLE venture_staffing (
  id SERIAL PRIMARY KEY,
  venture_id TEXT REFERENCES business_ventures_master(venture_id),
  contractor_id TEXT NOT NULL,
  contractor_name TEXT,
  role TEXT, allocation_percentage INTEGER,
  hourly_rate DECIMAL(10,2),
  monthly_cost DECIMAL(12,2),
  start_date DATE, end_date DATE,
  status TEXT DEFAULT 'active',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE venture_dependencies (
  id SERIAL PRIMARY KEY,
  venture_id TEXT REFERENCES business_ventures_master(venture_id),
  depends_on_venture_id TEXT REFERENCES business_ventures_master(venture_id),
  dependency_type TEXT,
  status TEXT DEFAULT 'pending',
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE venture_funding (
  id SERIAL PRIMARY KEY,
  venture_id TEXT REFERENCES business_ventures_master(venture_id),
  funding_type TEXT,
  amount DECIMAL(12,2),
  interest_rate DECIMAL(5,2),
  term_months INTEGER,
  status TEXT DEFAULT 'pending',
  application_date DATE,
  approval_date DATE,
  disbursement_date DATE,
  monthly_payment DECIMAL(12,2),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE venture_agent_activity (
  id SERIAL PRIMARY KEY,
  venture_id TEXT REFERENCES business_ventures_master(venture_id),
  agent_id TEXT NOT NULL,
  agent_name TEXT,
  action TEXT,
  task_id TEXT,
  input_data JSONB,
  output_data JSONB,
  status TEXT DEFAULT 'pending',
  error_message TEXT,
  duration_seconds INTEGER,
  executed_at TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE canonical_tasks (
  id SERIAL PRIMARY KEY,
  venture_id TEXT REFERENCES business_ventures_master(venture_id),
  task_id TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  description TEXT,
  source TEXT,
  source_id TEXT,
  task_type TEXT,
  priority TEXT DEFAULT 'medium',
  status TEXT DEFAULT 'open',
  assigned_agent_id TEXT,
  assigned_agent_name TEXT,
  due_date DATE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  completed_at TIMESTAMP
);

-- Indexes
CREATE INDEX idx_ventures_sector ON business_ventures_master(sector);
CREATE INDEX idx_ventures_status ON business_ventures_master(status);
CREATE INDEX idx_revenue_venture ON venture_revenue_summary(venture_id);
CREATE INDEX idx_staffing_venture ON venture_staffing(venture_id);
CREATE INDEX idx_deps_venture ON venture_dependencies(venture_id);
CREATE INDEX idx_funding_venture ON venture_funding(venture_id);
CREATE INDEX idx_activity_venture ON venture_agent_activity(venture_id);
CREATE INDEX idx_tasks_venture ON canonical_tasks(venture_id);

-- Health view
CREATE OR REPLACE VIEW venture_health_summary AS
SELECT v.venture_id, v.name, v.sector, v.status,
  COALESCE(r.revenue_net, 0) as revenue,
  COALESCE(r.profit, 0) as profit,
  (SELECT COUNT(*) FROM venture_staffing WHERE venture_id = v.venture_id AND status = 'active') as staff,
  (SELECT COUNT(*) FROM canonical_tasks WHERE venture_id = v.venture_id AND status != 'completed') as tasks
FROM business_ventures_master v
LEFT JOIN venture_revenue_summary r ON v.venture_id = r.venture_id;
