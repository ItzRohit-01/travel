import React from 'react';
import { motion } from 'framer-motion';

const metrics = [
  { label: 'Active trips', value: 128, color: '#22d3ee' },
  { label: 'Popular destination', value: 'Kyoto', color: '#6366f1' },
  { label: 'Avg budget', value: '₹3,450', color: '#f59e0b' },
  { label: 'New signups (24h)', value: 86, color: '#10b981' },
];

const chartData = [
  { label: 'Budget < ₹2k', value: 24 },
  { label: '₹2k - ₹4k', value: 46 },
  { label: '₹4k - ₹6k', value: 18 },
  { label: '>₹6k', value: 12 },
];

const health = [
  { name: 'API latency', status: 'Healthy', value: '183ms' },
  { name: 'Auth provider', status: 'Minor', value: 'Retrying tokens' },
  { name: 'Search index', status: 'Syncing', value: 'Rebuild 62%' },
];

const moderation = [
  { title: 'Report: Bali cowork stay', type: 'Review', status: 'Queued' },
  { title: 'Photo: Kyoto alley', type: 'Media', status: 'Flagged' },
  { title: 'Comment: Lisbon café', type: 'Comment', status: 'Under review' },
];

const activity = [
  'Alex exported Kyoto Discovery',
  'New itinerary: Patagonia Fall Trek added',
  '7 new members joined collab rooms',
  'Billing: 3 annual upgrades processed',
];

const card = {
  borderRadius: 16,
  padding: '16px 16px',
  background: '#fff',
  border: '1px solid rgba(15,23,42,0.06)',
  boxShadow: '0 14px 40px rgba(15,23,42,0.08)',
};

function AdminDashboard() {
  const total = chartData.reduce((s, d) => s + d.value, 0);

  return (
    <div style={{ display: 'grid', gap: 16 }}>
      <div>
        <h2 style={{ margin: 0, color: '#0f172a' }}>Admin dashboard</h2>
        <p style={{ color: '#475569', marginTop: 4 }}>Operational overview · read-only mock data for status, moderation, and budgets.</p>
      </div>

      <div style={{ display: 'grid', gap: 12, gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))' }}>
        {metrics.map((metric) => (
          <motion.div key={metric.label} whileHover={{ y: -3 }} style={{ ...card, display: 'grid', gap: 6 }}>
            <div style={{ fontSize: 13, color: '#475569' }}>{metric.label}</div>
            <div style={{ fontWeight: 800, color: '#0f172a', fontSize: 24 }}>{metric.value}</div>
            <div style={{ width: '55%', height: 6, borderRadius: 999, background: metric.color }} />
          </motion.div>
        ))}
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: 12, alignItems: 'stretch' }}>
        <motion.div whileHover={{ y: -3 }} style={{ ...card }}>
          <div style={{ fontWeight: 800, color: '#0f172a', marginBottom: 10 }}>Budget ranges</div>
          <div style={{ display: 'grid', gap: 10 }}>
            {chartData.map((item) => (
              <div key={item.label} style={{ display: 'grid', gap: 8 }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', color: '#0f172a' }}>
                  <span>{item.label}</span>
                  <span>{item.value}</span>
                </div>
                <div style={{ height: 10, borderRadius: 999, background: '#e2e8f0', overflow: 'hidden' }}>
                  <div style={{ height: '100%', width: `${Math.round((item.value / total) * 100)}%`, background: 'linear-gradient(135deg, #22d3ee 0%, #6366f1 100%)' }} />
                </div>
              </div>
            ))}
          </div>
        </motion.div>

        <motion.div whileHover={{ y: -3 }} style={{ ...card, background: 'linear-gradient(135deg, #f8fafc 0%, #eef2ff 100%)', display: 'grid', gap: 10 }}>
          <div style={{ fontWeight: 800, color: '#0f172a' }}>System health</div>
          {health.map((item) => (
            <div key={item.name} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '10px 12px', borderRadius: 12, background: '#fff', border: '1px solid rgba(15,23,42,0.06)' }}>
              <div>
                <div style={{ fontWeight: 800, color: '#0f172a' }}>{item.name}</div>
                <div style={{ color: '#475569', fontSize: 14 }}>{item.value}</div>
              </div>
              <span style={{ padding: '8px 12px', borderRadius: 999, background: 'rgba(15,23,42,0.05)', color: '#0f172a', fontWeight: 700, fontSize: 12 }}>{item.status}</span>
            </div>
          ))}
        </motion.div>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1.3fr 1fr 1fr', gap: 12, alignItems: 'stretch' }}>
        <motion.div whileHover={{ y: -3 }} style={{ ...card, display: 'grid', gap: 10 }}>
          <div style={{ fontWeight: 800, color: '#0f172a' }}>Moderation queue</div>
          {moderation.map((item) => (
            <div key={item.title} style={{ padding: '10px 12px', borderRadius: 12, border: '1px solid rgba(15,23,42,0.08)', background: '#f8fafc', display: 'grid', gap: 4 }}>
              <div style={{ fontWeight: 700, color: '#0f172a' }}>{item.title}</div>
              <div style={{ color: '#475569', fontSize: 14 }}>{item.type}</div>
              <span style={{ width: 'fit-content', padding: '8px 10px', borderRadius: 999, background: 'rgba(15,23,42,0.05)', color: '#0f172a', fontWeight: 700, fontSize: 12 }}>{item.status}</span>
            </div>
          ))}
          <button style={{ padding: '10px 12px', borderRadius: 10, border: 'none', background: 'linear-gradient(135deg, #22d3ee 0%, #3b82f6 100%)', color: '#fff', cursor: 'pointer', fontWeight: 800 }}>Review all</button>
        </motion.div>

        <motion.div whileHover={{ y: -3 }} style={{ ...card, display: 'grid', gap: 8 }}>
          <div style={{ fontWeight: 800, color: '#0f172a' }}>Activity</div>
          <ul style={{ margin: 0, paddingLeft: 18, display: 'grid', gap: 6, color: '#0f172a' }}>
            {activity.map((item) => (
              <li key={item}>{item}</li>
            ))}
          </ul>
        </motion.div>

        <motion.div whileHover={{ y: -3 }} style={{ ...card, background: 'linear-gradient(135deg, #0ea5e9 0%, #6366f1 100%)', color: '#fff', display: 'grid', gap: 8 }}>
          <div style={{ fontWeight: 800 }}>Export + alerts</div>
          <p style={{ margin: 0, opacity: 0.9 }}>Download CSV snapshots or toggle alerting for abnormal spend spikes.</p>
          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
            <button style={{ padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(255,255,255,0.3)', background: 'rgba(255,255,255,0.14)', color: '#fff', cursor: 'pointer', fontWeight: 800 }}>Export CSV</button>
            <button style={{ padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(255,255,255,0.3)', background: '#fff', color: '#0f172a', cursor: 'pointer', fontWeight: 800 }}>Enable alerts</button>
          </div>
        </motion.div>
      </div>
    </div>
  );
}

export default AdminDashboard;
