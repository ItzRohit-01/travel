import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import BudgetBar from '../../components/ui/BudgetBar';

const chips = ['Ongoing', 'Upcoming', 'Completed'];

const trips = [
	{ id: 1, name: 'Kyoto Discovery', status: 'Ongoing', summary: '5 days • Food + culture', budget: 3200, used: 1900 },
	{ id: 2, name: 'Bali Escape', status: 'Upcoming', summary: 'Surf + temples', budget: 2400, used: 0 },
	{ id: 3, name: 'Lisbon Weekend', status: 'Completed', summary: 'City walks + food', budget: 2100, used: 2050 },
	{ id: 4, name: 'Reykjavik Aurora', status: 'Upcoming', summary: 'Northern lights hunt', budget: 4500, used: 0 },
	{ id: 5, name: 'Dolomites Trek', status: 'Ongoing', summary: 'Hikes + rifugios', budget: 3800, used: 2500 },
];

const card = {
	borderRadius: 16,
	padding: '16px 16px',
	background: '#fff',
	border: '1px solid rgba(15,23,42,0.06)',
	boxShadow: '0 14px 40px rgba(15,23,42,0.08)',
};

function TripList() {
	const [tab, setTab] = useState('Ongoing');
	const filtered = trips.filter((trip) => trip.status === tab);

	return (
		<div style={{ display: 'grid', gap: 16 }}>
			<div style={{ display: 'flex', alignItems: 'center', gap: 10, flexWrap: 'wrap' }}>
				{chips.map((chip) => (
					<button
						key={chip}
						onClick={() => setTab(chip)}
						style={{
							padding: '10px 14px',
							borderRadius: 12,
							border: tab === chip ? '1px solid transparent' : '1px solid rgba(15,23,42,0.08)',
							background: tab === chip ? 'linear-gradient(135deg, #22d3ee 0%, #3b82f6 100%)' : '#f8fafc',
							color: tab === chip ? '#fff' : '#0f172a',
							fontWeight: 700,
							cursor: 'pointer',
							boxShadow: tab === chip ? '0 16px 34px rgba(59,130,246,0.25)' : 'none',
						}}
					>
						{chip}
					</button>
				))}
			</div>

			<div style={{ display: 'grid', gap: 12 }}>
				<AnimatePresence>
					{filtered.map((trip) => (
						<motion.div
							key={trip.id}
							layout
							initial={{ opacity: 0, y: 8 }}
							animate={{ opacity: 1, y: 0 }}
							exit={{ opacity: 0, y: -8 }}
							style={{ ...card, display: 'grid', gap: 10 }}
						>
							<div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 10, flexWrap: 'wrap' }}>
								<div>
									<div style={{ fontWeight: 800, color: '#0f172a' }}>{trip.name}</div>
									<div style={{ color: '#475569', fontSize: 14 }}>{trip.summary}</div>
								</div>
								<span style={{ padding: '6px 10px', borderRadius: 999, background: trip.status === 'Ongoing' ? 'rgba(16,185,129,0.12)' : trip.status === 'Upcoming' ? 'rgba(59,130,246,0.12)' : 'rgba(251,191,36,0.16)', color: '#0f172a', fontSize: 12 }}>{trip.status}</span>
							</div>
							<BudgetBar totalBudget={trip.budget} usedBudget={trip.used} />
							<div style={{ display: 'flex', gap: 10, flexWrap: 'wrap' }}>
								<button style={{ padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(15,23,42,0.08)', background: '#f8fafc', cursor: 'pointer', fontWeight: 600 }}>
									View itinerary
								</button>
								<button style={{ padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(15,23,42,0.08)', background: '#f8fafc', cursor: 'pointer', fontWeight: 600 }}>
									Continue planning
								</button>
							</div>
						</motion.div>
					))}
				</AnimatePresence>
			</div>
		</div>
	);
}

export default TripList;
