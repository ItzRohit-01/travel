import React from 'react';
import { motion } from 'framer-motion';
import { Link } from 'react-router-dom';
import { destinations } from '../../data/destinations';

const countries = [
	{ name: 'Japan', landmark: 'Fushimi Inari', img: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=600&q=60' },
	{ name: 'Iceland', landmark: 'Skógafoss', img: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=600&q=60' },
	{ name: 'Italy', landmark: 'Duomo di Milano', img: 'https://images.unsplash.com/photo-1467269204594-9661b134dd2b?auto=format&fit=crop&w=600&q=60' },
	{ name: 'Peru', landmark: 'Machu Picchu', img: 'https://images.unsplash.com/photo-1505678261036-a3fcc5e884ee?auto=format&fit=crop&w=600&q=60' },
	{ name: 'Jordan', landmark: 'Petra', img: 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?auto=format&fit=crop&w=600&q=60' },
	{ name: 'New Zealand', landmark: 'Milford Sound', img: 'https://images.unsplash.com/photo-1502786129293-79981df4e689?auto=format&fit=crop&w=600&q=60' },
];

const card = {
	borderRadius: 16,
	overflow: 'hidden',
	background: '#fff',
	border: '1px solid rgba(15,23,42,0.06)',
	boxShadow: '0 14px 40px rgba(15,23,42,0.08)',
};

function Countries() {
	return (
		<div style={{ display: 'grid', gap: 14 }}>
			<div>
				<h2 style={{ margin: 0, color: '#0f172a' }}>Explore countries</h2>
				<p style={{ color: '#475569', marginTop: 4 }}>Responsive grid with hover and lazy images.</p>
			</div>

			<div style={{ display: 'grid', gap: 14, gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))' }}>
					{countries.map((country) => {
						const match = destinations.find((d) => d.name === country.name);
						const link = match ? `/destination/${match.id}` : '#';
						return (
							<motion.div
								key={country.name}
								whileHover={{ y: -6 }}
								transition={{ type: 'spring', stiffness: 220, damping: 18 }}
								style={{ ...card, padding: 0 }}
							>
								<Link to={link} style={{ textDecoration: 'none', color: 'inherit', display: 'block' }}>
									<div style={{ height: 160, backgroundSize: 'cover', backgroundPosition: 'center', backgroundImage: `url(${country.img})` }} />
									<div style={{ padding: '12px 12px', display: 'grid', gap: 6 }}>
										<div style={{ fontWeight: 800 }}>{country.name}</div>
										<div style={{ color: '#475569', fontSize: 14 }}>{country.landmark}</div>
										<span style={{ color: '#2563eb', fontWeight: 700 }}>View details →</span>
									</div>
								</Link>
								</motion.div>
								);
							})}
			</div>
		</div>
	);
}

export default Countries;
