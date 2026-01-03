import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';

const seed = [
	{ id: 1, title: 'Day 1 • Arrival + Old Town walk', cost: 180 },
	{ id: 2, title: 'Day 2 • Museum + food tour', cost: 240 },
];

const templates = [
	'Coffee crawl + gallery hop',
	'Sunset hike + rooftop dinner',
	'Island ferry + seafood feast',
];

const card = {
	borderRadius: 16,
	padding: '16px 16px',
	background: '#fff',
	border: '1px solid rgba(15,23,42,0.06)',
	boxShadow: '0 14px 40px rgba(15,23,42,0.08)',
};

function BuildItinerary() {
	const [sections, setSections] = useState(seed);
	const [draft, setDraft] = useState('');
	const [cost, setCost] = useState(120);

	const addSection = () => {
		if (!draft) return;
		setSections((prev) => [...prev, { id: Date.now(), title: draft, cost: Number(cost) || 0 }]);
		setDraft('');
	};

	const remove = (id) => setSections((prev) => prev.filter((item) => item.id !== id));

	const total = sections.reduce((sum, item) => sum + item.cost, 0);
	const riskColor = total < 700 ? '#10b981' : total < 1100 ? '#f59e0b' : '#ef4444';

	return (
		<div style={{ display: 'grid', gap: 18 }}>
			<motion.div initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.4 }} style={{ ...card, display: 'grid', gap: 10 }}>
				<div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 12, flexWrap: 'wrap' }}>
					<div>
						<h2 style={{ margin: 0, color: '#0f172a' }}>Build itinerary</h2>
						<p style={{ color: '#475569', margin: 0 }}>Add sections, see per-day cost, and watch risk colors adapt.</p>
					</div>
					<span style={{ padding: '8px 12px', borderRadius: 999, background: 'rgba(15,23,42,0.05)', color: '#0f172a', fontWeight: 700 }}>Step 2 · Plan</span>
				</div>

				<div style={{ display: 'grid', gap: 10, gridTemplateColumns: '2fr 1fr 120px', alignItems: 'center', marginTop: 10 }}>
					<input value={draft} onChange={(e) => setDraft(e.target.value)} placeholder="Day 3 • Wine region" style={{ padding: '12px 14px', borderRadius: 12, border: '1px solid #cbd5e1' }} />
					<input type="number" value={cost} onChange={(e) => setCost(e.target.value)} style={{ padding: '12px 14px', borderRadius: 12, border: '1px solid #cbd5e1' }} />
					<motion.button type="button" whileHover={{ y: -2 }} whileTap={{ scale: 0.98 }} onClick={addSection} style={{ padding: '12px 12px', borderRadius: 12, border: 'none', background: 'linear-gradient(135deg, #22d3ee 0%, #3b82f6 100%)', color: '#fff', fontWeight: 700, cursor: 'pointer' }}>
						Add section
					</motion.button>
				</div>

				<div style={{ marginTop: 14, padding: '12px 14px', borderRadius: 12, background: 'rgba(148,163,184,0.08)', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
					<span>Total cost</span>
					<span style={{ color: riskColor, fontWeight: 800 }}>₹{total}</span>
				</div>

				<div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
					{templates.map((tpl) => (
						<button key={tpl} onClick={() => setDraft(tpl)} style={{ padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(15,23,42,0.08)', background: '#f8fafc', cursor: 'pointer', fontWeight: 700 }}>
							Use template: {tpl}
						</button>
					))}
				</div>
			</motion.div>

			<section style={{ display: 'grid', gap: 12 }}>
				<h3 style={{ margin: 0, color: '#0f172a' }}>Sections</h3>
				<AnimatePresence>
					{sections.map((section) => (
						<motion.div
							key={section.id}
							layout
							initial={{ opacity: 0, y: 8 }}
							animate={{ opacity: 1, y: 0 }}
							exit={{ opacity: 0, y: -8 }}
							style={{ ...card, display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12 }}
						>
							<div>
								<div style={{ fontWeight: 700 }}>{section.title}</div>
								<div style={{ color: '#475569', fontSize: 14 }}>Cost ₹{section.cost}</div>
							</div>
							<div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
								<span style={{ padding: '6px 10px', borderRadius: 999, background: 'rgba(15,23,42,0.05)', color: '#0f172a', fontSize: 12 }}>
									{section.cost < 200 ? 'Green' : section.cost < 350 ? 'Yellow' : 'Red'}
								</span>
								<button onClick={() => remove(section.id)} style={{ padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(15,23,42,0.08)', background: '#f8fafc', cursor: 'pointer' }}>
									Remove
								</button>
							</div>
						</motion.div>
					))}
				</AnimatePresence>
			</section>
		</div>
	);
}

export default BuildItinerary;
