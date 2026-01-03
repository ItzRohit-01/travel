import React from 'react';
import { motion } from 'framer-motion';

const itineraries = [
	{ title: 'Iceland Ring Road 7D', stops: 'Reykjavik • Vik • Hofn • Myvatn', budget: 5200, saves: 214 },
	{ title: 'Mexico City Long Weekend', stops: 'Roma Norte • Centro Histórico • Teotihuacan', budget: 1400, saves: 148 },
	{ title: 'Swiss Lakes + Alps', stops: 'Luzern • Interlaken • Zermatt', budget: 4100, saves: 186 },
	{ title: 'Bali Creative Retreat 10D', stops: 'Canggu • Ubud • Nusa Penida', budget: 3100, saves: 201 },
];

const creators = [
	{ name: 'Alicia Roads', trips: 18, focus: 'Food + city breaks' },
	{ name: 'Nomad Labs', trips: 24, focus: 'Remote-work friendly' },
	{ name: 'Summit Seekers', trips: 12, focus: 'Hiking + nature' },
];

const liveTrips = [
	{ title: 'Tokyo Cherry Bloom', dates: 'Apr 3-10', members: 8, vibe: 'Culture' },
	{ title: 'Patagonia Fall Trek', dates: 'May 11-18', members: 5, vibe: 'Adventure' },
];

const card = {
	borderRadius: 16,
	padding: '16px 16px',
	background: '#fff',
	border: '1px solid rgba(15,23,42,0.06)',
	boxShadow: '0 14px 40px rgba(15,23,42,0.08)',
};

function Community() {
	return (
		<div style={{ display: 'grid', gap: 16 }}>
			<motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.45 }}
				style={{
					...card,
					background: 'linear-gradient(135deg, #0ea5e9 0%, #6366f1 50%, #a855f7 100%)',
					color: '#fff',
					border: 'none',
					boxShadow: '0 30px 80px rgba(79,70,229,0.35)',
					display: 'grid',
					gap: 10,
				}}
			>
				<div style={{ fontSize: 13, letterSpacing: '0.5px', fontWeight: 800, opacity: 0.9 }}>TRAVELERS HUB</div>
				<div style={{ display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: 14 }}>
					<div style={{ flex: 1, minWidth: 260 }}>
						<h2 style={{ margin: 0, color: '#fff' }}>Follow, remix, and co-create trips</h2>
						<p style={{ margin: '6px 0 0', maxWidth: 620 }}>Browse curated public itineraries, join live trips, and copy a plan into your own workspace with one click.</p>
					</div>
					<div style={{ display: 'grid', gap: 8, minWidth: 220 }}>
						<button style={{ padding: '12px 14px', borderRadius: 12, border: '1px solid rgba(255,255,255,0.25)', background: 'rgba(255,255,255,0.12)', color: '#fff', fontWeight: 800, cursor: 'pointer' }}>
							Start a collab trip
						</button>
						<button style={{ padding: '12px 14px', borderRadius: 12, border: '1px solid rgba(255,255,255,0.25)', background: '#fff', color: '#0f172a', fontWeight: 800, cursor: 'pointer' }}>
							Share my itinerary
						</button>
					</div>
				</div>
			</motion.div>

			<section style={{ display: 'grid', gap: 10 }}>
				<div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: 10 }}>
					<h3 style={{ margin: 0, color: '#0f172a' }}>Trending itineraries</h3>
					<div style={{ display: 'flex', gap: 10 }}>
						<button style={{ padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(15,23,42,0.08)', background: '#f8fafc', cursor: 'pointer', fontWeight: 700 }}>All</button>
						<button style={{ padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(15,23,42,0.08)', background: '#f8fafc', cursor: 'pointer', fontWeight: 700 }}>Remote work</button>
						<button style={{ padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(15,23,42,0.08)', background: '#f8fafc', cursor: 'pointer', fontWeight: 700 }}>Adventure</button>
					</div>
				</div>
				<div style={{ display: 'grid', gap: 12, gridTemplateColumns: 'repeat(auto-fit, minmax(260px, 1fr))' }}>
					{itineraries.map((itinerary) => (
						<motion.div key={itinerary.title} whileHover={{ y: -4 }} style={card}>
							<div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 10 }}>
								<div>
									<div style={{ fontWeight: 800, color: '#0f172a' }}>{itinerary.title}</div>
									<div style={{ color: '#475569', margin: '4px 0 10px' }}>{itinerary.stops}</div>
								</div>
								<span style={{ padding: '6px 10px', borderRadius: 999, background: 'rgba(34,211,238,0.14)', color: '#0f172a', fontSize: 12, fontWeight: 700 }}>{itinerary.saves} saves</span>
							</div>
							<div style={{ fontWeight: 700, color: '#0f172a' }}>₹{itinerary.budget}</div>
							<div style={{ display: 'flex', gap: 8, marginTop: 10 }}>
								<button style={{ flex: 1, padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(15,23,42,0.08)', background: '#f8fafc', cursor: 'pointer', fontWeight: 700 }}>
									Preview
								</button>
								<button style={{ flex: 1, padding: '10px 12px', borderRadius: 10, border: 'none', background: 'linear-gradient(135deg, #22d3ee 0%, #3b82f6 100%)', color: '#fff', cursor: 'pointer', fontWeight: 800 }}>
									Copy this trip
								</button>
							</div>
						</motion.div>
					))}
				</div>
			</section>

			<section style={{ display: 'grid', gap: 12, gridTemplateColumns: '2fr 1.1fr', alignItems: 'stretch' }}>
				<div style={{ display: 'grid', gap: 10 }}>
					<h3 style={{ margin: 0, color: '#0f172a' }}>Featured creators</h3>
					<div style={{ display: 'grid', gap: 10 }}>
						{creators.map((creator) => (
							<motion.div key={creator.name} whileHover={{ y: -3 }} style={{ ...card, display: 'flex', alignItems: 'center', gap: 12 }}>
								<div style={{ width: 52, height: 52, borderRadius: '28%', background: 'linear-gradient(135deg, #22d3ee 0%, #6366f1 100%)', display: 'grid', placeItems: 'center', color: '#fff', fontWeight: 800 }}>
									{creator.name.slice(0, 2)}
								</div>
								<div style={{ flex: 1 }}>
									<div style={{ fontWeight: 800, color: '#0f172a' }}>{creator.name}</div>
									<div style={{ color: '#475569', fontSize: 14 }}>{creator.focus}</div>
								</div>
								<span style={{ padding: '8px 12px', borderRadius: 999, background: 'rgba(15,23,42,0.05)', color: '#0f172a', fontWeight: 700, fontSize: 13 }}>{creator.trips} trips</span>
							</motion.div>
						))}
					</div>
				</div>
				<div style={{ display: 'grid', gap: 10 }}>
					<h3 style={{ margin: 0, color: '#0f172a' }}>Live + co-planning</h3>
					<div style={{ display: 'grid', gap: 10 }}>
						{liveTrips.map((trip) => (
							<motion.div key={trip.title} whileHover={{ y: -3 }} style={{ ...card, background: 'linear-gradient(135deg, #f8fafc 0%, #eff6ff 100%)' }}>
								<div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 10 }}>
									<div>
										<div style={{ fontWeight: 800, color: '#0f172a' }}>{trip.title}</div>
										<div style={{ color: '#475569', fontSize: 14 }}>{trip.dates}</div>
									</div>
									<span style={{ padding: '6px 10px', borderRadius: 999, background: 'rgba(99,102,241,0.14)', color: '#0f172a', fontWeight: 700, fontSize: 12 }}>{trip.vibe}</span>
								</div>
								<div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 10 }}>
									<span style={{ color: '#0f172a', fontWeight: 700 }}>{trip.members} members</span>
									<button style={{ padding: '10px 12px', borderRadius: 10, border: 'none', background: 'linear-gradient(135deg, #22d3ee 0%, #3b82f6 100%)', color: '#fff', cursor: 'pointer', fontWeight: 800 }}>
										Join room
									</button>
								</div>
							</motion.div>
						))}
					</div>
				</div>
			</section>
		</div>
	);
}

export default Community;
