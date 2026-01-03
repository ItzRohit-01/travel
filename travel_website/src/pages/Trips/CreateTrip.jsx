import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';

const suggestions = [
	{ name: 'Bali Escape', description: 'Beaches, temples, and rice terraces.', budget: 2200 },
	{ name: 'Swiss Peaks', description: 'Trains, lakes, and alpine hikes.', budget: 3800 },
	{ name: 'Tokyo Lights', description: 'Cuisine, culture, and tech delights.', budget: 3200 },
];

const vibes = ['Slow travel', 'Adventure', 'Remote work', 'City breaks', 'Food-led'];
const perks = ['Free cancel within 48h', 'Split costs with friends', 'Offline access to plans'];

const card = {
	borderRadius: 16,
	padding: '16px 16px',
	background: '#fff',
	border: '1px solid rgba(15,23,42,0.06)',
	boxShadow: '0 14px 40px rgba(15,23,42,0.08)',
};

function CreateTrip() {
	const [form, setForm] = useState({ name: '', start: '', end: '', budget: '' });
	const [created, setCreated] = useState([]);
	const [notice, setNotice] = useState('');
	const isValid = form.name && form.start && form.end;

	const handleChange = (field, value) => {
		setForm((prev) => ({ ...prev, [field]: value }));
	};

	const handleSubmit = () => {
		if (!isValid) return;
		const newTrip = {
			id: Date.now(),
			...form,
			summary: `${form.start} → ${form.end}`,
		};
		setCreated((prev) => [newTrip, ...prev]);
		setNotice(`Trip "${form.name}" created (demo save).`);
		setForm({ name: '', start: '', end: '', budget: '' });
		setTimeout(() => setNotice(''), 2200);
	};

	const applySuggestion = (item) => {
		setForm((prev) => ({ ...prev, name: item.name, budget: item.budget }));
	};

	return (
		<div style={{ display: 'grid', gap: 18 }}>
			<motion.div initial={{ opacity: 0, y: 16 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.4 }} style={{ ...card, display: 'grid', gap: 12 }}>
				<div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 12, flexWrap: 'wrap' }}>
					<div>
						<h2 style={{ margin: 0, color: '#0f172a' }}>Create a trip</h2>
						<p style={{ color: '#475569', margin: 0 }}>Name it, set dates, choose a vibe—everything syncs to your itinerary builder.</p>
					</div>
					<span style={{ padding: '8px 12px', borderRadius: 999, background: 'rgba(34,211,238,0.14)', color: '#0f172a', fontWeight: 700 }}>Step 1 · Setup</span>
				</div>

				<div style={{ display: 'grid', gap: 12, gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', marginTop: 12 }}>
					<label style={{ display: 'grid', gap: 6 }}>
						<span>Trip name</span>
						<input value={form.name} onChange={(e) => handleChange('name', e.target.value)} placeholder="Mediterranean escape" style={{ padding: '12px 14px', borderRadius: 12, border: '1px solid #cbd5e1' }} />
					</label>
					<label style={{ display: 'grid', gap: 6 }}>
						<span>Start date</span>
						<input type="date" value={form.start} onChange={(e) => handleChange('start', e.target.value)} style={{ padding: '12px 14px', borderRadius: 12, border: '1px solid #cbd5e1' }} />
					</label>
					<label style={{ display: 'grid', gap: 6 }}>
						<span>End date</span>
						<input type="date" value={form.end} onChange={(e) => handleChange('end', e.target.value)} style={{ padding: '12px 14px', borderRadius: 12, border: '1px solid #cbd5e1' }} />
					</label>
					<label style={{ display: 'grid', gap: 6 }}>
						<span>Budget (optional)</span>
						<input type="number" value={form.budget} onChange={(e) => handleChange('budget', e.target.value)} placeholder="3500" style={{ padding: '12px 14px', borderRadius: 12, border: '1px solid #cbd5e1' }} />
					</label>
				</div>

				<motion.div initial={{ opacity: 0.9 }} animate={{ opacity: 1 }} style={{ display: 'flex', gap: 10, flexWrap: 'wrap', marginTop: 6 }}>
					{vibes.map((vibe) => (
						<span key={vibe} style={{ padding: '10px 12px', borderRadius: 12, background: 'rgba(15,23,42,0.04)', color: '#0f172a', fontWeight: 700 }}>{vibe}</span>
					))}
				</motion.div>

				<motion.button
					type="button"
					whileHover={{ y: -2 }}
					whileTap={{ scale: 0.99 }}
					onClick={handleSubmit}
					disabled={!isValid}
					style={{ marginTop: 10, padding: '12px 16px', borderRadius: 12, border: 'none', background: isValid ? 'linear-gradient(135deg, #22d3ee 0%, #3b82f6 100%)' : '#cbd5e1', color: '#fff', fontWeight: 700, cursor: isValid ? 'pointer' : 'not-allowed', boxShadow: isValid ? '0 16px 38px rgba(59,130,246,0.25)' : 'none' }}
				>
					Create trip
				</motion.button>
			</motion.div>

			<section style={{ display: 'grid', gap: 12 }}>
				<AnimatePresence>
					{notice && (
						<motion.div
							initial={{ opacity: 0, y: 6 }}
							animate={{ opacity: 1, y: 0 }}
							exit={{ opacity: 0, y: -6 }}
							style={{ ...card, background: 'linear-gradient(135deg, #ecfeff 0%, #e0f2fe 100%)', border: '1px solid rgba(14,165,233,0.25)' }}
						>
							<div style={{ color: '#0f172a', fontWeight: 700 }}>{notice}</div>
							<div style={{ color: '#475569', fontSize: 14 }}>You can proceed to itinerary builder next.</div>
						</motion.div>
					)}
				</AnimatePresence>

				<h3 style={{ margin: 0, color: '#0f172a' }}>Suggested destinations</h3>
				<div style={{ display: 'grid', gap: 12, gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))' }}>
					<AnimatePresence>
						{suggestions.map((item) => (
							<motion.div key={item.name} layout initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0 }} style={card}>
								<div style={{ fontWeight: 700 }}>{item.name}</div>
								<p style={{ color: '#475569', margin: '6px 0 10px' }}>{item.description}</p>
								<div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
									<span style={{ color: '#0f172a', fontWeight: 700 }}>₹{item.budget}</span>
									<button onClick={() => applySuggestion(item)} style={{ padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(15,23,42,0.08)', background: '#f8fafc', cursor: 'pointer', fontWeight: 600 }}>
										Use this
									</button>
								</div>
							</motion.div>
						))}
					</AnimatePresence>
				</div>
				<div style={{ ...card, display: 'grid', gap: 8 }}>
					<h4 style={{ margin: 0, color: '#0f172a' }}>Perks</h4>
					<div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
						{perks.map((perk) => (
							<span key={perk} style={{ padding: '10px 12px', borderRadius: 12, background: 'linear-gradient(135deg, #f8fafc 0%, #eef2ff 100%)', border: '1px solid rgba(15,23,42,0.06)', fontWeight: 700, color: '#0f172a' }}>
								{perk}
							</span>
						))}
					</div>
				</div>

				{created.length > 0 && (
					<div style={{ ...card, display: 'grid', gap: 10 }}>
						<h4 style={{ margin: 0, color: '#0f172a' }}>Created trips (local demo)</h4>
						<div style={{ display: 'grid', gap: 10 }}>
							{created.map((trip) => (
								<div key={trip.id} style={{ padding: '12px 12px', borderRadius: 12, border: '1px solid rgba(15,23,42,0.08)', background: '#f8fafc', display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
									<div>
										<div style={{ fontWeight: 800, color: '#0f172a' }}>{trip.name}</div>
										<div style={{ color: '#475569', fontSize: 14 }}>{trip.summary}</div>
									</div>
									<span style={{ fontWeight: 700, color: '#0f172a' }}>{trip.budget ? `₹${trip.budget}` : 'Budget TBD'}</span>
								</div>
							))}
						</div>
					</div>
				)}
			</section>
		</div>
	);
}

export default CreateTrip;
