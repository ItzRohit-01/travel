import React from 'react';
import { motion } from 'framer-motion';

const savedTrips = [
  { name: 'Kyoto Discovery', status: 'Ongoing', mood: 'Culture + food' },
  { name: 'Bali Escape', status: 'Upcoming', mood: 'Beach + wellness' },
  { name: 'Lisbon Weekend', status: 'Completed', mood: 'City break' },
];

const stats = [
  { label: 'Countries', value: 14 },
  { label: 'Cities lived', value: 4 },
  { label: 'Trips this year', value: 6 },
  { label: 'Total nights', value: 58 },
];

const preferences = ['Carry-on only', 'Remote-work friendly stays', 'Street food hunts', 'Early flights avoided'];
const badges = ['Top curator', 'Early planner', 'Budget savvy', 'Offline-ready'];

const card = {
  borderRadius: 16,
  padding: '16px 16px',
  background: '#fff',
  border: '1px solid rgba(15,23,42,0.06)',
  boxShadow: '0 14px 40px rgba(15,23,42,0.08)',
};

function Profile() {
  return (
    <div style={{ display: 'grid', gap: 16 }}>
      <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.4 }} style={{ ...card, display: 'grid', gap: 12 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 14, flexWrap: 'wrap' }}>
          <div style={{ width: 72, height: 72, borderRadius: '22%', background: 'linear-gradient(135deg, #22d3ee 0%, #6366f1 100%)', display: 'grid', placeItems: 'center', color: '#fff', fontWeight: 800, fontSize: 22 }}>
            AE
          </div>
          <div>
            <h2 style={{ margin: '0 0 4px', color: '#0f172a' }}>Alex Explorer</h2>
            <p style={{ margin: 0, color: '#475569' }}>alex.explorer@example.com</p>
            <p style={{ margin: 0, color: '#475569' }}>Based in Copenhagen · Loves slow travel</p>
          </div>
          <div style={{ marginLeft: 'auto', display: 'flex', gap: 10 }}>
            <button style={{ padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(15,23,42,0.08)', background: '#f8fafc', cursor: 'pointer', fontWeight: 700 }}>Edit profile</button>
            <button style={{ padding: '10px 12px', borderRadius: 10, border: 'none', background: 'linear-gradient(135deg, #22d3ee 0%, #3b82f6 100%)', color: '#fff', cursor: 'pointer', fontWeight: 800 }}>Share profile</button>
          </div>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))', gap: 10 }}>
          {stats.map((item) => (
            <div key={item.label} style={{ padding: '10px 12px', borderRadius: 12, background: 'rgba(15,23,42,0.03)', display: 'grid', gap: 4 }}>
              <span style={{ color: '#475569', fontSize: 13 }}>{item.label}</span>
              <span style={{ fontWeight: 800, color: '#0f172a', fontSize: 22 }}>{item.value}</span>
            </div>
          ))}
        </div>
      </motion.div>

      <div style={{ display: 'grid', gridTemplateColumns: '1.5fr 1fr', gap: 14, alignItems: 'stretch' }}>
        <div style={{ display: 'grid', gap: 12 }}>
          <h3 style={{ margin: 0, color: '#0f172a' }}>Saved trips</h3>
          <div style={{ display: 'grid', gap: 12, gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))' }}>
            {savedTrips.map((trip) => (
              <motion.div key={trip.name} whileHover={{ y: -4 }} style={{ ...card, display: 'grid', gap: 6 }}>
                <div style={{ fontWeight: 800, color: '#0f172a' }}>{trip.name}</div>
                <div style={{ color: '#475569' }}>{trip.mood}</div>
                <span style={{ padding: '8px 10px', borderRadius: 999, background: 'rgba(15,23,42,0.05)', color: '#0f172a', fontWeight: 700, fontSize: 12, width: 'fit-content' }}>{trip.status}</span>
                <div style={{ display: 'flex', gap: 8 }}>
                  <button style={{ flex: 1, padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(15,23,42,0.08)', background: '#f8fafc', cursor: 'pointer', fontWeight: 700 }}>Open</button>
                  <button style={{ padding: '10px 12px', borderRadius: 10, border: 'none', background: 'linear-gradient(135deg, #22d3ee 0%, #3b82f6 100%)', color: '#fff', cursor: 'pointer', fontWeight: 800 }}>Share</button>
                </div>
              </motion.div>
            ))}
          </div>
        </div>

        <div style={{ display: 'grid', gap: 12 }}>
          <motion.div whileHover={{ y: -3 }} style={{ ...card, display: 'grid', gap: 8 }}>
            <h3 style={{ margin: 0, color: '#0f172a' }}>Badges</h3>
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
              {badges.map((badge) => (
                <span key={badge} style={{ padding: '10px 12px', borderRadius: 12, background: 'linear-gradient(135deg, #f8fafc 0%, #eef2ff 100%)', border: '1px solid rgba(15,23,42,0.06)', fontWeight: 700, color: '#0f172a' }}>
                  {badge}
                </span>
              ))}
            </div>
          </motion.div>

          <motion.div whileHover={{ y: -3 }} style={{ ...card, display: 'grid', gap: 8 }}>
            <h3 style={{ margin: 0, color: '#0f172a' }}>Preferences</h3>
            <ul style={{ margin: 0, paddingLeft: 18, display: 'grid', gap: 6, color: '#0f172a' }}>
              {preferences.map((pref) => (
                <li key={pref}>{pref}</li>
              ))}
            </ul>
          </motion.div>
        </div>
      </div>

      <motion.div whileHover={{ y: -2 }} style={{ ...card, display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: 12 }}>
        <div>
          <div style={{ fontWeight: 800, color: '#0f172a' }}>Travel streak</div>
          <p style={{ margin: 0, color: '#475569' }}>2 trips booked back-to-back · keep the streak alive with one more weekend.</p>
        </div>
        <button style={{ padding: '12px 14px', borderRadius: 12, border: 'none', background: 'linear-gradient(135deg, #22d3ee 0%, #3b82f6 100%)', color: '#fff', cursor: 'pointer', fontWeight: 800 }}>Book a quick escape</button>
      </motion.div>
    </div>
  );
}

export default Profile;
