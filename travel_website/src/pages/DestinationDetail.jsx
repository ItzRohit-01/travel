import React, { useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { getDestinationById } from '../data/destinations';

const DestinationDetail = () => {
	const { id } = useParams();
	const navigate = useNavigate();
	const destination = getDestinationById(parseInt(id));
	const [selectedImage, setSelectedImage] = useState(0);

	if (!destination) {
		return (
			<div style={{ display: 'grid', placeItems: 'center', minHeight: '60vh' }}>
				<div style={{ textAlign: 'center' }}>
					<h2>Destination not found</h2>
					<button onClick={() => navigate('/dashboard')} style={{ padding: '10px 16px', borderRadius: 8, background: '#0ea5e9', color: '#fff', border: 'none', cursor: 'pointer', marginTop: 16 }}>
						Back to Dashboard
					</button>
				</div>
			</div>
		);
	}

	const allImages = [destination.image, ...destination.attractions.map(a => a.img)];

	return (
		<div>
			{/* Hero Section with Image Gallery */}
			<motion.section initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ duration: 0.5 }}>
				<div style={{ position: 'relative', height: 400 }}>
					<img 
						src={allImages[selectedImage]} 
						alt={destination.name}
						style={{ width: '100%', height: '100%', objectFit: 'cover' }}
						onError={(e) => e.target.src = 'https://via.placeholder.com/800x400?text=' + destination.name}
					/>
					<div style={{
						position: 'absolute',
						top: 0,
						left: 0,
						right: 0,
						bottom: 0,
						background: 'linear-gradient(to bottom, transparent 40%, rgba(0,0,0,0.6))'
					}} />

					{/* Back Button */}
					<motion.button 
						whileHover={{ scale: 1.1 }}
						onClick={() => navigate('/dashboard')}
						style={{
							position: 'absolute',
							top: 20,
							left: 20,
							padding: '10px 16px',
							background: 'rgba(255,255,255,0.9)',
							border: 'none',
							borderRadius: 8,
							cursor: 'pointer',
							fontWeight: 600,
							zIndex: 10
						}}
					>
						← Back
					</motion.button>

					{/* Title */}
					<motion.div 
						initial={{ opacity: 0, y: 20 }}
						animate={{ opacity: 1, y: 0 }}
						style={{
							position: 'absolute',
							bottom: 0,
							left: 0,
							right: 0,
							padding: '40px 24px',
							color: '#fff',
							zIndex: 5
						}}
					>
						<h1 style={{ fontSize: 42, margin: '0 0 12px 0', fontWeight: 800 }}>{destination.name}</h1>
						<p style={{ fontSize: 16, opacity: 0.9, margin: 0 }}>📍 {destination.region} • ⭐ {destination.rating} ({destination.reviews} reviews)</p>
					</motion.div>
				</div>

				{/* Image Gallery Thumbnails */}
				<div style={{ padding: '20px 24px', background: '#fff', borderBottom: '1px solid rgba(15,23,42,0.06)' }}>
					<div style={{ display: 'flex', gap: 12, overflowX: 'auto', paddingBottom: 8 }}>
						{allImages.map((img, idx) => (
							<motion.img
								key={idx}
								whileHover={{ scale: 1.05 }}
								onClick={() => setSelectedImage(idx)}
								src={img}
								alt={idx === 0 ? destination.name : destination.attractions[idx - 1].name}
								style={{
									width: 80,
									height: 80,
									borderRadius: 8,
									objectFit: 'cover',
									cursor: 'pointer',
									border: selectedImage === idx ? '3px solid #0ea5e9' : '1px solid rgba(15,23,42,0.06)',
									flex: '0 0 auto'
								}}
								onError={(e) => e.target.src = 'https://via.placeholder.com/80x80'}
							/>
						))}
					</div>
				</div>
			</motion.section>

			{/* Content Section */}
			<div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: 24, padding: '32px 24px', maxWidth: 1200, margin: '0 auto' }}>
				{/* Main Content */}
				<motion.div initial={{ opacity: 0, x: -20 }} animate={{ opacity: 1, x: 0 }} transition={{ delay: 0.2 }}>
					{/* Description */}
					<div style={{ marginBottom: 32 }}>
						<h2 style={{ margin: '0 0 12px 0', color: '#0f172a', fontSize: 24 }}>About {destination.name}</h2>
						<p style={{ color: '#475569', lineHeight: 1.8, fontSize: 16 }}>
							{destination.description}
						</p>
					</div>

					{/* Highlights */}
					<div style={{ marginBottom: 32 }}>
						<h3 style={{ margin: '0 0 16px 0', color: '#0f172a', fontSize: 20 }}>✨ Top Highlights</h3>
						<div style={{ display: 'grid', gap: 12, gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))' }}>
							{destination.highlights.map((highlight) => (
								<motion.div
									key={highlight}
									whileHover={{ x: 4 }}
									style={{
										padding: '16px',
										background: '#f0f9ff',
										borderRadius: 8,
										borderLeft: '4px solid #0ea5e9',
										cursor: 'pointer'
									}}
								>
									<p style={{ margin: 0, fontWeight: 600, color: '#0f172a' }}>🎯 {highlight}</p>
								</motion.div>
							))}
						</div>
					</div>

					{/* Attractions */}
					<div>
						<h3 style={{ margin: '0 0 16px 0', color: '#0f172a', fontSize: 20 }}>🏛️ Major Attractions</h3>
						<div style={{ display: 'grid', gap: 16, gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))' }}>
							{destination.attractions.map((attraction, idx) => (
								<motion.div
									key={idx}
									whileHover={{ y: -4 }}
									style={{
										borderRadius: 12,
										overflow: 'hidden',
										background: '#fff',
										border: '1px solid rgba(15,23,42,0.06)',
										boxShadow: '0 4px 12px rgba(15,23,42,0.08)',
										cursor: 'pointer'
									}}
								>
									<div style={{ height: 150, overflow: 'hidden' }}>
										<img 
											src={attraction.img} 
											alt={attraction.name}
											style={{ width: '100%', height: '100%', objectFit: 'cover' }}
											onError={(e) => e.target.src = 'https://via.placeholder.com/300x150'}
										/>
									</div>
									<div style={{ padding: '12px 14px', fontWeight: 600, color: '#0f172a' }}>
										{attraction.name}
									</div>
								</motion.div>
							))}
						</div>
					</div>
				</motion.div>

				{/* Sidebar */}
				<motion.div initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} transition={{ delay: 0.2 }}>
					{/* Booking Card */}
					<div style={{
						padding: '24px',
						background: 'linear-gradient(135deg, #0ea5e9 0%, #6366f1 100%)',
						borderRadius: 12,
						color: '#fff',
						marginBottom: 24,
						boxShadow: '0 20px 40px rgba(14,165,233,0.3)',
						position: 'sticky',
						top: 20
					}}>
						<h3 style={{ margin: '0 0 16px 0', fontSize: 20, fontWeight: 800 }}>Ready to Visit?</h3>
						
						<div style={{ display: 'grid', gap: 12, marginBottom: 16 }}>
							<div>
								<div style={{ fontSize: 12, opacity: 0.9 }}>Best Time to Visit</div>
								<div style={{ fontWeight: 700, fontSize: 14 }}>{destination.bestTime}</div>
							</div>
							<div>
								<div style={{ fontSize: 12, opacity: 0.9 }}>Average Cost (per person)</div>
								<div style={{ fontWeight: 700, fontSize: 14 }}>{destination.avgCost}</div>
							</div>
							<div style={{ paddingTop: 12, borderTop: '1px solid rgba(255,255,255,0.2)' }}>
								<div style={{ fontSize: 12, opacity: 0.9 }}>Reviews</div>
								<div style={{ fontWeight: 700, fontSize: 16 }}>⭐ {destination.rating} ({destination.reviews} reviews)</div>
							</div>
						</div>

						<motion.button
							whileHover={{ scale: 1.05 }}
							whileTap={{ scale: 0.95 }}
							style={{
								width: '100%',
								padding: '12px 16px',
								background: '#fff',
								color: '#0ea5e9',
								border: 'none',
								borderRadius: 8,
								fontWeight: 700,
								cursor: 'pointer',
								fontSize: 14
							}}
						>
							Plan Trip to {destination.name}
						</motion.button>
					</div>

					{/* Quick Facts */}
					<div style={{
						padding: '20px',
						background: '#f8fafc',
						borderRadius: 12,
						border: '1px solid rgba(15,23,42,0.06)'
					}}>
						<h4 style={{ margin: '0 0 16px 0', color: '#0f172a' }}>📋 Quick Facts</h4>
						<div style={{ display: 'grid', gap: 12 }}>
							<div>
								<div style={{ fontSize: 12, color: '#475569' }}>Country</div>
								<div style={{ fontWeight: 600, color: '#0f172a' }}>{destination.country}</div>
							</div>
							<div>
								<div style={{ fontSize: 12, color: '#475569' }}>Region</div>
								<div style={{ fontWeight: 600, color: '#0f172a' }}>{destination.region}</div>
							</div>
							<div>
								<div style={{ fontSize: 12, color: '#475569' }}>Landmark</div>
								<div style={{ fontWeight: 600, color: '#0f172a' }}>{destination.landmark}</div>
							</div>
						</div>
					</div>
				</motion.div>
			</div>
		</div>
	);
};

export default DestinationDetail;
