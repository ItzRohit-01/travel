import React, { useEffect, useState } from 'react';
import { motion } from 'framer-motion';
import { Link } from 'react-router-dom';
import { destinations } from '../data/destinations';
import TravelChatbot from '../components/chat/TravelChatbot';

const Home = () => {
	const topDestinations = destinations.slice(0, 6);
	const [showSplash, setShowSplash] = useState(true);

	useEffect(() => {
		const timer = setTimeout(() => setShowSplash(false), 1600);
		return () => clearTimeout(timer);
	}, []);

	const containerVariants = {
		hidden: { opacity: 0 },
		visible: {
			opacity: 1,
			transition: {
				staggerChildren: 0.1,
				delayChildren: 0.2,
			},
		},
	};

	const itemVariants = {
		hidden: { opacity: 0, y: 20 },
		visible: {
			opacity: 1,
			y: 0,
			transition: { duration: 0.5 },
		},
	};

	return (
		<div style={{ display: 'grid', gap: 32 }}>
			{showSplash && (
				<motion.div
					initial={{ opacity: 0 }}
					animate={{ opacity: 1 }}
					exit={{ opacity: 0 }}
					style={{ position: 'fixed', inset: 0, zIndex: 3000, display: 'grid', placeItems: 'center', background: 'radial-gradient(circle at 20% 20%, rgba(99,102,241,0.16), transparent 32%), radial-gradient(circle at 80% 0%, rgba(14,165,233,0.2), transparent 30%), #0b1224' }}
				>
					<motion.div
						initial={{ scale: 0.8, opacity: 0 }}
						animate={{ scale: 1, opacity: 1 }}
						transition={{ duration: 0.6, ease: 'easeOut' }}
						style={{ textAlign: 'center', color: '#fff', display: 'grid', gap: 10 }}
					>
						<motion.div
							initial={{ letterSpacing: '4px' }}
							animate={{ letterSpacing: '1px' }}
							transition={{ duration: 0.8, ease: 'easeOut' }}
							style={{ fontSize: 42, fontWeight: 900 }}
						>
							GlobeTrotter
						</motion.div>
						<motion.div
							initial={{ opacity: 0, y: 12 }}
							animate={{ opacity: 1, y: 0 }}
							transition={{ delay: 0.2, duration: 0.5 }}
							style={{ fontSize: 16, color: 'rgba(255,255,255,0.8)' }}
						>
							Designing journeys that feel cinematic
						</motion.div>
					</motion.div>
				</motion.div>
			)}
			{/* Hero Section */}
			<motion.section
				initial={{ opacity: 0 }}
				animate={{ opacity: 1 }}
				transition={{ duration: 0.7 }}
				style={{
					minHeight: 620,
					background: 'radial-gradient(circle at 20% 20%, rgba(255,255,255,0.18), transparent 28%), radial-gradient(circle at 80% 0%, rgba(255,255,255,0.16), transparent 30%), linear-gradient(130deg, #0ea5e9 0%, #2563eb 40%, #7c3aed 80%)',
					borderRadius: 22,
					padding: '70px 48px',
					color: '#fff',
					display: 'grid',
					gridTemplateColumns: '1.1fr 0.9fr',
					alignItems: 'center',
					gap: 28,
					position: 'relative',
					overflow: 'hidden',
					boxShadow: '0 60px 140px rgba(59,130,246,0.45)'
				}}
			>
				{/* Floating glow */}
				<motion.div
					animate={{ scale: [1, 1.08, 1] }}
					transition={{ duration: 5, repeat: Infinity, ease: 'easeInOut' }}
					style={{
						position: 'absolute',
						bottom: -120,
						left: -60,
						width: 380,
						height: 380,
						background: 'radial-gradient(circle, rgba(14,165,233,0.55) 0%, transparent 60%)',
						filter: 'blur(18px)',
						zIndex: 0
					}}
				/>

				{/* Left content */}
				<motion.div
					style={{ position: 'relative', zIndex: 1, display: 'grid', gap: 18 }}
					initial={{ y: 18, opacity: 0 }}
					animate={{ y: 0, opacity: 1 }}
					transition={{ duration: 0.6, ease: 'easeOut' }}
				>
					<div style={{ display: 'inline-flex', alignItems: 'center', gap: 10, padding: '8px 12px', borderRadius: 999, background: 'rgba(255,255,255,0.14)', border: '1px solid rgba(255,255,255,0.3)', width: 'fit-content' }}>
						<span style={{ fontSize: 14, fontWeight: 700 }}>🌐 Curated by travel strategists</span>
					</div>

					<motion.h1
						style={{ fontSize: 54, margin: '6px 0', fontWeight: 900, letterSpacing: '-1.2px', lineHeight: 1.1 }}
						animate={{ y: [0, -6, 0] }}
						transition={{ duration: 3.2, repeat: Infinity, ease: 'easeInOut' }}
					>
						Design unforgettable journeys with cinematic visuals.
					</motion.h1>

					<p style={{ fontSize: 18, margin: 0, maxWidth: 640, lineHeight: 1.6, color: 'rgba(255,255,255,0.9)' }}>
						Real-time discovery, immersive previews, and tailored routes built for travelers who want the best of every city and every season.
					</p>

					<div style={{ display: 'flex', gap: 12, flexWrap: 'wrap' }}>
						<Link to="/dashboard" style={{ textDecoration: 'none' }}>
							<motion.button
								whileHover={{ scale: 1.05, y: -2 }}
								whileTap={{ scale: 0.97 }}
								style={{
									padding: '14px 22px',
									background: '#fff',
									color: '#0ea5e9',
									border: 'none',
									borderRadius: 12,
									fontWeight: 800,
									fontSize: 15,
									cursor: 'pointer',
									boxShadow: '0 16px 38px rgba(255,255,255,0.25)'
								}}
							>
								Launch Planner →
							</motion.button>
						</Link>
						<Link to="/destination/1" style={{ textDecoration: 'none' }}>
							<motion.button
								whileHover={{ scale: 1.05, y: -2 }}
								whileTap={{ scale: 0.97 }}
								style={{
									padding: '14px 18px',
									background: 'rgba(255,255,255,0.08)',
									color: '#fff',
									border: '1px solid rgba(255,255,255,0.4)',
									borderRadius: 12,
									fontWeight: 700,
									fontSize: 15,
									cursor: 'pointer',
									backdropFilter: 'blur(6px)'
								}}
							>
								Preview Japan Experience
							</motion.button>
						</Link>
					</div>

					<div style={{ display: 'flex', gap: 14, flexWrap: 'wrap', marginTop: 8 }}>
						<div style={{ padding: '12px 14px', borderRadius: 14, background: 'rgba(255,255,255,0.12)', border: '1px solid rgba(255,255,255,0.25)', minWidth: 180 }}>
							<div style={{ fontSize: 13, opacity: 0.9 }}>Live deals</div>
							<div style={{ fontWeight: 800, fontSize: 20 }}>340+ curated stays</div>
						</div>
						<div style={{ padding: '12px 14px', borderRadius: 14, background: 'rgba(255,255,255,0.12)', border: '1px solid rgba(255,255,255,0.25)', minWidth: 180 }}>
							<div style={{ fontSize: 13, opacity: 0.9 }}>Avg. rating</div>
							<div style={{ fontWeight: 800, fontSize: 20 }}>4.8 ⭐ worldwide</div>
						</div>
						<div style={{ padding: '12px 14px', borderRadius: 14, background: 'rgba(255,255,255,0.12)', border: '1px solid rgba(255,255,255,0.25)', minWidth: 180 }}>
							<div style={{ fontSize: 13, opacity: 0.9 }}>Instant routes</div>
							<div style={{ fontWeight: 800, fontSize: 20 }}>12 pro itineraries</div>
						</div>
					</div>
				</motion.div>

				{/* Right visual stack */}
				<div style={{ position: 'relative', zIndex: 1, height: '100%', display: 'grid', placeItems: 'center' }}>
					<motion.div
						initial={{ opacity: 0, scale: 0.9 }}
						animate={{ opacity: 1, scale: 1 }}
						transition={{ delay: 0.2, type: 'spring', stiffness: 120, damping: 14 }}
						style={{
							position: 'relative',
							width: '100%',
							maxWidth: 480,
							aspectRatio: '4 / 5',
							borderRadius: 20,
							overflow: 'hidden',
							boxShadow: '0 30px 80px rgba(0,0,0,0.35)',
							background: '#0b1224'
						}}
					>
						<img
							src="https://images.unsplash.com/photo-1504788363733-507549153474?auto=format&fit=crop&w=1000&q=80"
							alt="Tokyo skyline"
							style={{ width: '100%', height: '100%', objectFit: 'cover', opacity: 0.9 }}
						/>
						<div style={{ position: 'absolute', inset: 0, background: 'linear-gradient(180deg, transparent 55%, rgba(0,0,0,0.55))' }} />
						<div style={{ position: 'absolute', bottom: 16, left: 16, right: 16, color: '#fff', display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end' }}>
							<div>
								<div style={{ fontWeight: 800, fontSize: 20 }}>Night pulse • Tokyo</div>
								<div style={{ opacity: 0.85 }}>Shibuya Crossing • Rooftop bar route</div>
							</div>
							<div style={{ display: 'flex', gap: 8 }}>
								<span style={{ padding: '6px 10px', borderRadius: 10, background: 'rgba(255,255,255,0.14)', border: '1px solid rgba(255,255,255,0.25)', fontWeight: 700 }}>2h walk</span>
								<span style={{ padding: '6px 10px', borderRadius: 10, background: '#22d3ee', color: '#0b1224', fontWeight: 800 }}>Live</span>
							</div>
						</div>
					</motion.div>

					{/* Floating cards */}
					<motion.div
						initial={{ opacity: 0, y: 16 }}
						animate={{ opacity: 1, y: 0 }}
						transition={{ delay: 0.4, duration: 0.6 }}
						style={{ position: 'absolute', top: 30, right: -10, width: 180 }}
					>
						<div style={{ background: '#0f172a', color: '#fff', padding: '14px 16px', borderRadius: 14, boxShadow: '0 16px 40px rgba(0,0,0,0.25)', border: '1px solid rgba(255,255,255,0.1)', backdropFilter: 'blur(6px)' }}>
							<div style={{ fontWeight: 800 }}>Live Airfare Radar</div>
							<div style={{ fontSize: 13, opacity: 0.8, marginTop: 4 }}>Tokyo ↔ Paris drop detected</div>
							<div style={{ marginTop: 10, display: 'flex', justifyContent: 'space-between', fontSize: 13 }}>
								<span>Business</span>
								<span style={{ fontWeight: 800 }}>-18%</span>
							</div>
							<div style={{ marginTop: 6, display: 'flex', justifyContent: 'space-between', fontSize: 13 }}>
								<span>Economy</span>
								<span style={{ fontWeight: 800 }}>-11%</span>
							</div>
						</div>
					</motion.div>

					<motion.div
						initial={{ opacity: 0, y: 20 }}
						animate={{ opacity: 1, y: 0 }}
						transition={{ delay: 0.55, duration: 0.6 }}
						style={{ position: 'absolute', bottom: 24, right: 26, background: '#0ea5e9', color: '#fff', padding: '12px 14px', borderRadius: 14, boxShadow: '0 16px 40px rgba(14,165,233,0.35)' }}
					>
						<div style={{ fontWeight: 800 }}>Next departure</div>
						<div style={{ fontSize: 13, opacity: 0.9 }}>Haneda → Reykjavik • 08:45</div>
					</motion.div>
				</div>
			</motion.section>

			<TravelChatbot destinations={destinations} />

			{/* Featured Destinations */}
			<section style={{ display: 'grid', gap: 20 }}>
				<div style={{ textAlign: 'center' }}>
					<h2 style={{ fontSize: 36, margin: 0, color: '#0f172a', fontWeight: 900 }}>✨ Featured Destinations</h2>
					<p style={{ color: '#475569', marginTop: 8, fontSize: 16 }}>Handpicked destinations that will take your breath away</p>
				</div>

				<motion.div
					variants={containerVariants}
					initial="hidden"
					animate="visible"
					style={{
						display: 'grid',
						gap: 20,
						gridTemplateColumns: 'repeat(auto-fit, minmax(320px, 1fr))'
					}}
				>
					{topDestinations.map((destination) => (
						<motion.div
							key={destination.id}
							variants={itemVariants}
							whileHover={{ y: -12 }}
							style={{ cursor: 'pointer' }}
						>
							<Link
								to={`/destination/${destination.id}`}
								style={{
									display: 'block',
									borderRadius: 16,
									overflow: 'hidden',
									background: '#fff',
									border: '1px solid rgba(15,23,42,0.06)',
									boxShadow: '0 12px 40px rgba(15,23,42,0.08)',
									textDecoration: 'none',
									color: 'inherit'
								}}
							>
							<div style={{ position: 'relative', height: 220, overflow: 'hidden' }}>
								<motion.img
									src={destination.image}
									alt={destination.name}
									style={{ width: '100%', height: '100%', objectFit: 'cover' }}
									whileHover={{ scale: 1.08 }}
									transition={{ duration: 0.4 }}
									onError={(e) => e.target.src = 'https://via.placeholder.com/400x220'}
								/>
								<div style={{
									position: 'absolute',
									top: 0,
									left: 0,
									right: 0,
									bottom: 0,
									background: 'linear-gradient(to bottom, transparent 40%, rgba(0,0,0,0.5))'
								}} />
								<div style={{
									position: 'absolute',
									top: 12,
									right: 12,
									background: '#fff',
									padding: '6px 12px',
									borderRadius: 8,
									fontWeight: 700,
									fontSize: 13,
									boxShadow: '0 4px 12px rgba(0,0,0,0.15)'
								}}>
									⭐ {destination.rating}
								</div>
							</div>

							<div style={{ padding: '20px' }}>
								<h3 style={{ margin: '0 0 8px 0', fontSize: 20, fontWeight: 800, color: '#0f172a' }}>
									{destination.name}
								</h3>
								<p style={{ color: '#475569', fontSize: 14, margin: '0 0 12px 0' }}>
									📍 {destination.region} • {destination.landmark}
								</p>
								<p style={{ color: '#64748b', fontSize: 14, lineHeight: 1.5, margin: '0 0 12px 0' }}>
									{destination.description.substring(0, 80)}...
								</p>

								<div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginBottom: 12 }}>
									<span style={{
										padding: '4px 8px',
										background: '#e0f2fe',
										color: '#0369a1',
										borderRadius: 4,
										fontSize: 11,
										fontWeight: 600
									}}>
										✈️ {destination.bestTime}
									</span>
									<span style={{
										padding: '4px 8px',
										background: '#fef3c7',
										color: '#92400e',
										borderRadius: 4,
										fontSize: 11,
										fontWeight: 600
									}}>
										💰 {destination.avgCost}
									</span>
								</div>

								<button style={{
									width: '100%',
									padding: '10px 12px',
									background: 'linear-gradient(135deg, #0ea5e9 0%, #6366f1 100%)',
									color: '#fff',
									border: 'none',
									borderRadius: 8,
									fontWeight: 700,
									cursor: 'pointer',
									fontSize: 13
								}}>
									Explore Destination →
								</button>
							</div>
						</Link>
					</motion.div>
					))}
				</motion.div>
			</section>

			{/* CTA Section */}
			<motion.section
				initial={{ opacity: 0, y: 40 }}
				animate={{ opacity: 1, y: 0 }}
				transition={{ delay: 0.5 }}
				style={{
					background: 'linear-gradient(120deg, #f0f9ff 0%, #e0e7ff 100%)',
					borderRadius: 16,
					padding: '60px 40px',
					textAlign: 'center',
					border: '1px solid rgba(14,165,233,0.2)'
				}}
			>
				<h2 style={{ fontSize: 32, margin: '0 0 12px 0', color: '#0f172a', fontWeight: 900 }}>Ready for your next adventure?</h2>
				<p style={{ color: '#475569', fontSize: 16, margin: '0 0 24px 0', maxWidth: 500, marginLeft: 'auto', marginRight: 'auto' }}>
					Join thousands of travelers who've already discovered amazing destinations. Start planning your perfect trip today!
				</p>

				<Link to="/dashboard" style={{ textDecoration: 'none' }}>
					<motion.button
						whileHover={{ scale: 1.08 }}
						whileTap={{ scale: 0.95 }}
						style={{
							padding: '14px 32px',
							background: 'linear-gradient(135deg, #0ea5e9 0%, #6366f1 100%)',
							color: '#fff',
							border: 'none',
							borderRadius: 10,
							fontWeight: 800,
							fontSize: 15,
							cursor: 'pointer',
							boxShadow: '0 10px 30px rgba(14,165,233,0.3)'
						}}
					>
						Browse All Destinations
					</motion.button>
				</Link>
			</motion.section>
		</div>
	);
};

export default Home;
