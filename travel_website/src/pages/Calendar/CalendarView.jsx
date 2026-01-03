import React from 'react';
import { motion } from 'framer-motion';

const days = Array.from({ length: 30 }, (_, i) => i + 1);
const travelDays = new Set([4, 5, 6, 12, 18, 19]);

const upcoming = [
  { title: 'Lisbon long weekend', dates: 'Apr 4-6', status: 'Booked', color: '#22d3ee' },
  { title: 'Kyoto discovery', dates: 'Apr 18-19', status: 'Planning', color: '#f59e0b' },
  { title: 'Swiss alpine rail', dates: 'May 2-6', status: 'Hold', color: '#6366f1' },
];

const highlights = [
  { label: 'Travel days', value: 8 },
  { label: 'Weekend escapes', value: 2 },
  { label: 'Flights booked', value: 3 },
  { label: 'Free days left', value: 12 },
];

const shell = {
  borderRadius: 18,
  padding: '16px 16px',
  background: '#fff',
  border: '1px solid rgba(15,23,42,0.06)',
  boxShadow: '0 18px 50px rgba(15,23,42,0.1)',
};

function CalendarView() {
  return (
    <motion.div initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.4 }} style={{ display: 'grid', gap: 16 }}>
      <div style={{ display: 'grid', gridTemplateColumns: '2fr 1.1fr', gap: 12, alignItems: 'stretch' }}>
        <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.35 }} style={{ ...shell, background: 'linear-gradient(135deg, #0ea5e9 0%, #6366f1 100%)', color: '#fff', border: 'none', boxShadow: '0 22px 65px rgba(14,165,233,0.28)' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 10, flexWrap: 'wrap' }}>
            <div>
              <div style={{ fontSize: 13, letterSpacing: '0.5px', fontWeight: 800, opacity: 0.9 }}>CALENDAR</div>
              <h2 style={{ margin: '4px 0 6px', color: '#fff' }}>April travel board</h2>
              <p style={{ margin: 0, opacity: 0.9 }}>Synced holds, confirmed tickets, and flexible days are highlighted below.</p>
            </div>
            <div style={{ display: 'flex', gap: 8 }}>
              <button style={{ padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(255,255,255,0.3)', background: 'rgba(255,255,255,0.12)', color: '#fff', cursor: 'pointer', fontWeight: 800 }}>←</button>
              <button style={{ padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(255,255,255,0.3)', background: '#fff', color: '#0f172a', cursor: 'pointer', fontWeight: 800 }}>→</button>
            </div>
          </div>
          <div style={{ marginTop: 12, display: 'flex', flexWrap: 'wrap', gap: 10 }}>
            <span style={{ padding: '8px 12px', borderRadius: 999, background: 'rgba(255,255,255,0.16)', color: '#fff', fontWeight: 700 }}>Booked</span>
            <span style={{ padding: '8px 12px', borderRadius: 999, background: 'rgba(255,255,255,0.16)', color: '#fff', fontWeight: 700 }}>Planning</span>
            <span style={{ padding: '8px 12px', borderRadius: 999, background: 'rgba(255,255,255,0.16)', color: '#fff', fontWeight: 700 }}>Holds</span>
          </div>
        </motion.div>

        <div style={{ ...shell, display: 'grid', gap: 10 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <h3 style={{ margin: 0, color: '#0f172a' }}>Upcoming trips</h3>
            <span style={{ color: '#475569', fontWeight: 700 }}>Syncing with calendar · read-only</span>
          </div>
          <div style={{ display: 'grid', gap: 10 }}>
            {upcoming.map((trip) => (
              <div key={trip.title} style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '10px 12px', borderRadius: 12, border: '1px solid rgba(15,23,42,0.06)', background: '#f8fafc' }}>
                <div>
                  <div style={{ fontWeight: 800, color: '#0f172a' }}>{trip.title}</div>
                  <div style={{ color: '#475569', fontSize: 14 }}>{trip.dates}</div>
                </div>
                <span style={{ padding: '8px 12px', borderRadius: 999, background: 'rgba(15,23,42,0.05)', color: '#0f172a', fontWeight: 700, border: `1px solid ${trip.color}` }}>{trip.status}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '2fr 1.1fr', gap: 12, alignItems: 'stretch' }}>
        <div style={{ ...shell }}>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', gap: 8 }}>
            {days.map((day) => {
              const isTravel = travelDays.has(day);
              return (
                <motion.button
                  key={day}
                  whileHover={{ y: -2 }}
                  style={{
                    padding: '14px 10px',
                    borderRadius: 12,
                    border: isTravel ? '1px solid transparent' : '1px solid rgba(15,23,42,0.08)',
                    background: isTravel ? 'linear-gradient(135deg, #22d3ee 0%, #3b82f6 100%)' : '#f8fafc',
                    color: isTravel ? '#fff' : '#0f172a',
                    fontWeight: 700,
                    cursor: 'pointer',
                  }}
                >
                  <div>{day}</div>
                  {isTravel && <div style={{ marginTop: 6, fontSize: 12, opacity: 0.9 }}>Trip day</div>}
                </motion.button>
              );
            })}
          </div>
        </div>

        <div style={{ display: 'grid', gap: 12 }}>
          <motion.div whileHover={{ y: -2 }} style={{ ...shell, display: 'grid', gap: 8 }}>
            <h3 style={{ margin: 0, color: '#0f172a' }}>Travel summary</h3>
            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: 10 }}>
              {highlights.map((item) => (
                <div key={item.label} style={{ padding: '10px 12px', borderRadius: 12, background: 'rgba(15,23,42,0.03)', display: 'grid', gap: 4 }}>
                  <span style={{ color: '#475569', fontSize: 13 }}>{item.label}</span>
                  <span style={{ fontWeight: 800, color: '#0f172a', fontSize: 22 }}>{item.value}</span>
                </div>
              ))}
            </div>
          </motion.div>

          <motion.div whileHover={{ y: -2 }} style={{ ...shell, background: 'linear-gradient(135deg, #f8fafc 0%, #eef2ff 100%)', display: 'grid', gap: 8 }}>
            <h3 style={{ margin: 0, color: '#0f172a' }}>Next up</h3>
            <p style={{ margin: 0, color: '#475569' }}>Lisbon weekend · Apr 4-6</p>
            <ul style={{ margin: 0, paddingLeft: 18, color: '#0f172a', display: 'grid', gap: 6 }}>
              <li>Flight: TAP 234 · confirmed</li>
              <li>Stay: Bairro Alto hotel · paid</li>
              <li>Dinner: Alma · hold</li>
            </ul>
            <div style={{ display: 'flex', gap: 8 }}>
              <button style={{ padding: '10px 12px', borderRadius: 10, border: 'none', background: 'linear-gradient(135deg, #22d3ee 0%, #3b82f6 100%)', color: '#fff', cursor: 'pointer', fontWeight: 800 }}>View itinerary</button>
              <button style={{ padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(15,23,42,0.08)', background: '#fff', color: '#0f172a', cursor: 'pointer', fontWeight: 700 }}>Share calendar</button>
            </div>
          </motion.div>
        </div>
      </div>
    </motion.div>
  );
}

export default CalendarView;
