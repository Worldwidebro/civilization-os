/**
 * Nightly P&L Calculation Job
 * 
 * Runs every night at 2 AM UTC
 * Calculates venture revenue + costs → profit
 * Updates venture_revenue_summary table
 * 
 * Data flow:
 * Paddle webhooks → The Office (revenue)
 * STAFF-001 API → The Office (staff costs)
 * The Office → ventures-master.csv → Supabase
 * This job aggregates into P&L view
 */

import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
);

export async function calculateNightlyPnL() {
  console.log('🌙 Starting nightly P&L calculation...');
  
  const now = new Date();
  const monthDate = new Date(now.getFullYear(), now.getMonth(), 1);
  
  // Get all ventures
  const { data: ventures } = await supabase
    .from('business_ventures_master')
    .select('venture_id');
  
  if (!ventures) {
    console.error('No ventures found');
    return;
  }

  let calculated = 0;
  
  for (const v of ventures) {
    // Get revenue from The Office (payment events)
    const { data: revenueEvents } = await supabase
      .from('the_office_events')
      .select('amount')
      .eq('venture_id', v.venture_id)
      .eq('event_type', 'payment')
      .gte('created_at', monthDate.toISOString());
    
    const revenueGross = revenueEvents?.reduce((sum, e) => sum + (e.amount || 0), 0) || 0;
    
    // Get staff costs from STAFF-001 integration
    const { data: staffing } = await supabase
      .from('venture_staffing')
      .select('monthly_cost')
      .eq('venture_id', v.venture_id)
      .eq('status', 'active');
    
    const costStaff = staffing?.reduce((sum, s) => sum + (s.monthly_cost || 0), 0) || 0;
    
    // Get operational costs (estimate: 20% of revenue for infrastructure)
    const costOperational = revenueGross * 0.2;
    const costInfra = revenueGross * 0.1;
    const totalCosts = costStaff + costOperational + costInfra;
    
    // Calculate P&L
    const revenueNet = revenueGross - (revenueGross * 0.05); // 5% payment processing fee
    const profit = revenueNet - totalCosts;
    const marginPercent = revenueNet > 0 ? (profit / revenueNet * 100) : 0;
    
    // Upsert into venture_revenue_summary
    const { error } = await supabase
      .from('venture_revenue_summary')
      .upsert(
        {
          venture_id: v.venture_id,
          month_date: monthDate.toISOString().split('T')[0],
          revenue_gross: revenueGross,
          revenue_net: revenueNet,
          costs_operational: costOperational,
          costs_staff: costStaff,
          costs_infrastructure: costInfra,
          profit,
          margin_percent: marginPercent,
          calculated_at: now.toISOString()
        },
        { onConflict: 'venture_id,month_date' }
      );
    
    if (error) {
      console.error(`Error calculating P&L for ${v.venture_id}:`, error);
    } else {
      calculated++;
    }
  }
  
  console.log(`✅ P&L calculated for ${calculated}/${ventures.length} ventures`);
  console.log('📊 Dashboards will refresh with latest P&L data');
}

// Call this function nightly via cron job
// Example: 0 2 * * * ts-node scripts/nightly-p-l-sync.ts
if (require.main === module) {
  calculateNightlyPnL()
    .then(() => process.exit(0))
    .catch(err => {
      console.error('Fatal error:', err);
      process.exit(1);
    });
}
