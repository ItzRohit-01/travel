import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { Link } from 'react-router-dom';
import { destinations, regions } from '../../data/destinations';
import BudgetBar from '../../components/ui/BudgetBar';

const heroStyle = {
	borderRadius: 20,
	padding: '40px 24px',
	background: 'linear-gradient(120deg, #0ea5e9 0%, #6366f1 60%, #a855f7 100%)',
	color: '#fff',
	boxShadow: '0 30px 80px rgba(99,102,241,0.3)',
};

const card = {
	borderRadius: 16,
	padding: '16px 16px',
	background: '#fff',
	border: '1px solid rgba(15,23,42,0.06)',
	boxShadow: '0 12px 40px rgba(15,23,42,0.08)',
	cursor: 'pointer',
	transition: 'all 0.3s ease',
};

const destCard = {
	borderRadius: 16,
	overflow: 'hidden',
	background: '#fff',
	border: '1px solid rgba(15,23,42,0.06)',
	boxShadow: '0 14px 40px rgba(15,23,42,0.08)',
	cursor: 'pointer',
	textDecoration: 'none',
	color: 'inherit',
};

const trips = [
	{ name: 'Kyoto Discovery', status: 'Active', budget: 3200, used: 1800 },
	{ name: 'Reykjavik Aurora', status: 'Upcoming', budget: 4500, used: 0 },
	{ name: 'Lisbon Weekend', status: 'Completed', budget: 2100, used: 2050 },
];

function Dashboard() {
	const [selectedRegion, setSelectedRegion] = useState('All');
	const [searchQuery, setSearchQuery] = useState('');
	const [sortBy, setSortBy] = useState('rating');

	let filteredDestinations = selectedRegion === 'All' 
		? destinations 
		: destinations.filter(d => d.region === selectedRegion);

	// Apply search filter
	if (searchQuery.trim()) {
		filteredDestinations = filteredDestinations.filter(d => 
			d.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
			d.landmark.toLowerCase().includes(searchQuery.toLowerCase()) ||
			d.description.toLowerCase().includes(searchQuery.toLowerCase())
		);
	}

	// Apply sorting
	if (sortBy === 'rating') {
		filteredDestinations = [...filteredDestinations].sort((a, b) => b.rating - a.rating);
	} else if (sortBy === 'name') {
		filteredDestinations = [...filteredDestinations].sort((a, b) => a.name.localeCompare(b.name));
	} else if (sortBy === 'cost') {
		filteredDestinations = [...filteredDestinations].sort((a, b) => {
			const costA = parseInt(a.avgCost.match(/\d+/)[0]);
			const costB = parseInt(b.avgCost.match(/\d+/)[0]);
			return costA - costB;
		});
	}

	const containerVariants = {
		hidden: { opacity: 0 },
		visible: {
			opacity: 1,
			transition: {
				staggerChildren: 0.1,
				delayChildren: 0.3,
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
		<div style={{ display: 'grid', gap: 24 }}>
			{/* Hero Section */}
			<motion.section 
				initial={{ opacity: 0, y: 24 }} 
				animate={{ opacity: 1, y: 0 }} 
				transition={{ duration: 0.45 }} 
				style={heroStyle}
			>
				<div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: 16, flexWrap: 'wrap' }}>
					<div>
						<motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.1 }} style={{ fontSize: 14, fontWeight: 700, letterSpacing: '0.5px' }}>Welcome back</motion.div>
						<motion.h1 initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.15 }} style={{ fontSize: 36, margin: '8px 0 12px', fontWeight: 800 }}>Design your next adventure</motion.h1>
						<motion.p initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.2 }} style={{ maxWidth: 520, lineHeight: 1.6, fontSize: 15 }}>Explore breathtaking destinations around the world. Plan your perfect trip with our comprehensive travel planning tools.</motion.p>
						<motion.button 
							initial={{ opacity: 0 }} 
							animate={{ opacity: 1 }} 
							transition={{ delay: 0.25 }}
							whileHover={{ scale: 1.05 }}
							whileTap={{ scale: 0.95 }}
							style={{ marginTop: 16, padding: '12px 20px', borderRadius: 12, border: 'none', background: '#fff', color: '#0ea5e9', fontWeight: 700, cursor: 'pointer' }}
						>
							Start Planning
						</motion.button>
					</div>
					<motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }} style={{ padding: '16px 20px', borderRadius: 14, background: 'rgba(255,255,255,0.16)', border: '1px solid rgba(255,255,255,0.2)', minWidth: 240 }}>
						<div style={{ fontSize: 13, opacity: 0.9, fontWeight: 600 }}>💡 Pro Tip</div>
						<div style={{ fontWeight: 700, marginTop: 4 }}>Filter by region or search for your dream destination</div>
					</motion.div>
				</div>
			</motion.section>

			{/* Popular Destinations Section */}
			<section style={{ display: 'grid', gap: 18 }}>
				<div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap', gap: 12 }}>
					<div>
						<h3 style={{ margin: 0, color: '#0f172a', fontSize: 24, fontWeight: 800 }}>🌍 Top Global Destinations</h3>
						<p style={{ color: '#475569', marginTop: 4, fontSize: 14 }}>Discover world-class destinations with highest ratings</p>
					</div>
				</div>

				{/* Search Bar */}
				<motion.div 
					initial={{ opacity: 0, y: 10 }}
					animate={{ opacity: 1, y: 0 }}
					style={{
						display: 'flex',
						gap: 12,
						alignItems: 'center',
						padding: '12px 16px',
						background: '#fff',
						borderRadius: 12,
						border: '1px solid rgba(15,23,42,0.1)',
						boxShadow: '0 4px 12px rgba(15,23,42,0.08)'
					}}
				>
					<span style={{ fontSize: 18 }}>🔍</span>
					<input
						type="text"
						placeholder="Search destinations, landmarks..."
						value={searchQuery}
						onChange={(e) => setSearchQuery(e.target.value)}
						style={{
							flex: 1,
							border: 'none',
							outline: 'none',
							fontSize: 14,
							fontFamily: 'inherit',
							padding: '4px 0'
						}}
					/>
					<select
						value={sortBy}
						onChange={(e) => setSortBy(e.target.value)}
						style={{
							padding: '6px 12px',
							borderRadius: 8,
							border: '1px solid rgba(15,23,42,0.1)',
							background: '#f8fafc',
							cursor: 'pointer',
							fontSize: 13,
							fontWeight: 600,
							color: '#0f172a'
						}}
					>
						<option value="rating">Sort by: Rating ⭐</option>
						<option value="name">Sort by: Name A-Z</option>
						<option value="cost">Sort by: Cost Low-High</option>
					</select>
				</motion.div>

				{/* Region Filter */}
				<div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', paddingBottom: 8 }}>
					<motion.button
						whileHover={{ scale: 1.05 }}
						whileTap={{ scale: 0.95 }}
						onClick={() => setSelectedRegion('All')}
						style={{
							padding: '8px 16px',
							borderRadius: 20,
							border: 'none',
							background: selectedRegion === 'All' ? 'linear-gradient(135deg, #0ea5e9 0%, #6366f1 100%)' : '#f1f5f9',
							color: selectedRegion === 'All' ? '#fff' : '#0f172a',
							fontWeight: 600,
							cursor: 'pointer',
							fontSize: 13,
							boxShadow: selectedRegion === 'All' ? '0 4px 12px rgba(14,165,233,0.3)' : 'none'
						}}
					>
						All Regions
					</motion.button>
					{regions.map((region) => (
						<motion.button
							key={region}
							whileHover={{ scale: 1.05 }}
							whileTap={{ scale: 0.95 }}
							onClick={() => setSelectedRegion(region)}
							style={{
								padding: '8px 16px',
								borderRadius: 20,
								border: 'none',
								background: selectedRegion === region ? 'linear-gradient(135deg, #0ea5e9 0%, #6366f1 100%)' : '#f1f5f9',
								color: selectedRegion === region ? '#fff' : '#0f172a',
								fontWeight: 600,
								cursor: 'pointer',
								fontSize: 13,
								boxShadow: selectedRegion === region ? '0 4px 12px rgba(14,165,233,0.3)' : 'none'
							}}
						>
							{region}
						</motion.button>
					))}
				</div>

				{/* Destinations Grid */}
				<motion.div 
					variants={containerVariants}
					initial="hidden"
					animate="visible"
					style={{ display: 'grid', gap: 16, gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))' }}
				>
					{filteredDestinations.map((destination) => (
						<motion.div
							key={destination.id}
							variants={itemVariants}
							whileHover={{ y: -8, boxShadow: '0 20px 60px rgba(15,23,42,0.15)' }}
							transition={{ type: 'spring', stiffness: 220, damping: 18 }}
							style={{ position: 'relative' }}
						>
							<Link to={`/destination/${destination.id}`} style={{ ...destCard, position: 'relative', overflow: 'hidden', display: 'block' }}>
							{/* Image */}
							<div style={{ position: 'relative', height: 180, overflow: 'hidden' }}>
								<img 
									src={destination.image} 
									alt={destination.name}
									style={{ width: '100%', height: '100%', objectFit: 'cover' }}
									onError={(e) => e.target.src = 'https://via.placeholder.com/400x300?text=' + destination.name}
								/>
								<div style={{
									position: 'absolute',
									top: 0,
									left: 0,
									right: 0,
									bottom: 0,
									background: 'linear-gradient(to bottom, transparent 50%, rgba(0,0,0,0.4))'
								}} />
								{/* Rating Badge */}
								<motion.div 
									initial={{ opacity: 0, scale: 0.8 }}
									animate={{ opacity: 1, scale: 1 }}
									style={{
										position: 'absolute',
										top: 12,
										right: 12,
										background: '#fff',
										borderRadius: 8,
										padding: '6px 10px',
										fontWeight: 700,
										fontSize: 13,
										boxShadow: '0 4px 12px rgba(0,0,0,0.15)'
									}}
								>
									⭐ {destination.rating}
								</motion.div>
							</div>

							{/* Content */}
							<div style={{ padding: '16px 16px', display: 'grid', gap: 8 }}>
								<div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'start', gap: 8 }}>
									<div>
										<div style={{ fontWeight: 800, fontSize: 18, color: '#0f172a' }}>{destination.name}</div>
										<div style={{ color: '#475569', fontSize: 13, marginTop: 2 }}>📍 {destination.region}</div>
									</div>
								</div>
								
								<div style={{ fontSize: 13, color: '#64748b', lineHeight: 1.4 }}>
									{destination.description.substring(0, 70)}...
								</div>

								<div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginTop: 4 }}>
									<span style={{ padding: '4px 8px', borderRadius: 6, background: '#e0f2fe', color: '#0369a1', fontSize: 11, fontWeight: 600 }}>
										✈️ {destination.bestTime}
									</span>
									<span style={{ padding: '4px 8px', borderRadius: 6, background: '#fef3c7', color: '#92400e', fontSize: 11, fontWeight: 600 }}>
										💰 {destination.avgCost}
									</span>
								</div>

								<div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 8, color: '#2563eb', fontWeight: 700, fontSize: 13 }}>
									View Details →
								</div>

								{/* Quick Highlights */}
								<div style={{ display: 'flex', gap: 4, flexWrap: 'wrap', marginTop: 8, paddingTop: 8, borderTop: '1px solid rgba(15,23,42,0.06)' }}>
									{destination.highlights.slice(0, 3).map((highlight) => (
										<span key={highlight} style={{ padding: '4px 8px', borderRadius: 4, background: '#f1f5f9', fontSize: 11, color: '#475569', fontWeight: 500 }}>
											{highlight}
										</span>
									))}
								</div>
							</div>
						</Link>
						</motion.div>
					))}
				</motion.div>
			</section>

			{/* Active Trips Section */}
			<section style={{ display: 'grid', gap: 14 }}>
				<div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 10, flexWrap: 'wrap' }}>
					<h3 style={{ margin: 0, color: '#0f172a', fontSize: 22, fontWeight: 800 }}>📅 Your Trips</h3>
					<Link to="/trips/create" style={{ color: '#2563eb', fontWeight: 700, textDecoration: 'none' }}>
						+ Create New Trip
					</Link>
				</div>
				<div style={{ display: 'grid', gap: 12, gridTemplateColumns: 'repeat(auto-fit, minmax(260px, 1fr))' }}>
					{trips.map((trip) => (
						<motion.div key={trip.name} whileHover={{ y: -4 }} style={card}>
							<div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 8 }}>
								<div style={{ fontWeight: 700, color: '#0f172a', fontSize: 16 }}>{trip.name}</div>
								<span style={{ padding: '6px 10px', borderRadius: 999, background: trip.status === 'Active' ? 'rgba(16,185,129,0.12)' : trip.status === 'Upcoming' ? 'rgba(59,130,246,0.12)' : 'rgba(251,191,36,0.16)', color: '#0f172a', fontSize: 12, fontWeight: 600 }}>{trip.status}</span>
							</div>
							<BudgetBar totalBudget={trip.budget} usedBudget={trip.used} />
							<motion.button 
								whileHover={{ scale: 1.02 }}
								whileTap={{ scale: 0.98 }}
								style={{ marginTop: 10, padding: '10px 12px', borderRadius: 10, border: '1px solid rgba(15,23,42,0.08)', background: '#f8fafc', cursor: 'pointer', fontWeight: 600, width: '100%' }}
							>
								View Trip
							</motion.button>
						</motion.div>
					))}
				</div>
			</section>
		</div>
	);
}

export default Dashboard;
