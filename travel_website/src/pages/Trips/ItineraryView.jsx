import React, { useState } from 'react';
import { motion } from 'framer-motion';
import BudgetBar from '../../components/ui/BudgetBar';

const days = [
	{
		id: 1,
		day: 'Day 1',
		title: 'Arrival + Old Town',
		budget: 220,
		spent: 180,
		items: ['Check-in at boutique hotel', 'Guided Old Town walk', 'Welcome dinner at local bistro'],
	},
	{
		id: 2,
		day: 'Day 2',
		title: 'Museums + food tour',
		budget: 260,
		spent: 240,
		items: ['Modern art museum', 'Street food crawl', 'Night market'],
	},
	{
		id: 3,
		day: 'Day 3',
		title: 'Nature escape',
		budget: 310,
		spent: 180,
		items: ['Cable car to viewpoint', 'Lakeside picnic', 'Evening spa'],
	},
];

const shell = {
	borderRadius: 18,
	padding: '18px 18px',
	background: '#fff',
	border: '1px solid rgba(15,23,42,0.06)',
	boxShadow: '0 18px 50px rgba(15,23,42,0.1)',
};

function ItineraryView() {
	const [mode, setMode] = useState('list');
	const totalBudget = days.reduce((s, d) => s + d.budget, 0);
	const totalSpent = days.reduce((s, d) => s + d.spent, 0);

	return (
		<div style={{ display: 'grid', gap: 16 }}>
			<motion.div initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.45 }} style={shell}>
				<div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap' }}>
					<div>
						<div style={{ fontSize: 14, fontWeight: 800, color: '#06b6d4', letterSpacing: '0.5px' }}>PREMIUM ITINERARY</div>
						<h2 style={{ margin: '6px 0 4px', color: '#0f172a' }}>Kyoto Discovery</h2>
						<p style={{ color: '#475569', margin: 0 }}>Toggle between list and calendar view, with detailed budgets.</p>
					</div>
					<div style={{ display: 'flex', gap: 10 }}>
						<button onClick={() => setMode('list')} style={{ padding: '10px 14px', borderRadius: 12, border: mode === 'list' ? '1px solid transparent' : '1px solid rgba(15,23,42,0.08)', background: mode === 'list' ? 'linear-gradient(135deg, #22d3ee 0%, #3b82f6 100%)' : '#f8fafc', color: mode === 'list' ? '#fff' : '#0f172a', fontWeight: 700, cursor: 'pointer' }}>
							List view
						</button>
						<button onClick={() => setMode('calendar')} style={{ padding: '10px 14px', borderRadius: 12, border: mode === 'calendar' ? '1px solid transparent' : '1px solid rgba(15,23,42,0.08)', background: mode === 'calendar' ? 'linear-gradient(135deg, #22d3ee 0%, #3b82f6 100%)' : '#f8fafc', color: mode === 'calendar' ? '#fff' : '#0f172a', fontWeight: 700, cursor: 'pointer' }}>
							Calendar view
						</button>
					</div>
				</div>
				<div style={{ marginTop: 12 }}>
					<BudgetBar totalBudget={totalBudget} usedBudget={totalSpent} />
				</div>
			</motion.div>

			{mode === 'list' ? (
				<div style={{ display: 'grid', gap: 12 }}>
					{days.map((day) => {
						const ratio = day.spent / day.budget;
						const badgeColor = ratio < 0.6 ? 'rgba(16,185,129,0.14)' : ratio < 0.9 ? 'rgba(251,191,36,0.16)' : 'rgba(248,113,113,0.18)';
						const badgeText = ratio < 0.6 ? 'Low risk' : ratio < 0.9 ? 'Watch' : 'High risk';
						return (
							<motion.div key={day.id} initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.35 }} style={{ ...shell, display: 'grid', gap: 10 }}>
								<div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 10, flexWrap: 'wrap' }}>
									<div>
										<div style={{ fontWeight: 800, color: '#0f172a' }}>{day.day}</div>
										<div style={{ color: '#475569' }}>{day.title}</div>
									</div>
									<span style={{ padding: '8px 12px', borderRadius: 999, background: badgeColor, color: '#0f172a', fontWeight: 700, fontSize: 12 }}>{badgeText}</span>
								</div>

								<BudgetBar totalBudget={day.budget} usedBudget={day.spent} />

								<ul style={{ margin: 0, paddingLeft: 18, color: '#0f172a', display: 'grid', gap: 6 }}>
									{day.items.map((item) => (
										<li key={item} style={{ lineHeight: 1.5 }}>{item}</li>
									))}
								</ul>
							</motion.div>
						);
					})}
				</div>
			) : (
				<motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} style={{ ...shell }}>
					<p style={{ color: '#475569', marginTop: 0 }}>Calendar preview (static demo)</p>
					<div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(120px, 1fr))', gap: 10 }}>
						{days.map((day) => (
							<div key={day.id} style={{ padding: '12px 12px', borderRadius: 12, border: '1px solid rgba(15,23,42,0.08)', background: 'linear-gradient(135deg, #f8fafc 0%, #eef2ff 100%)' }}>
								<div style={{ fontWeight: 800, color: '#0f172a' }}>{day.day}</div>
								<div style={{ color: '#475569', fontSize: 14 }}>{day.title}</div>
								<div style={{ marginTop: 6, fontWeight: 700 }}>₹{day.spent} / ₹{day.budget}</div>
							</div>
						))}
					</div>
				</motion.div>
			)}
		</div>
	);
}

export default ItineraryView;
