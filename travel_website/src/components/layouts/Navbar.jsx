import React, { useState } from 'react';
import { NavLink, Link } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';

const shellStyle = {
	position: 'sticky',
	top: 0,
	zIndex: 20,
	backdropFilter: 'blur(12px)',
	background: 'rgba(255, 255, 255, 0.92)',
	borderBottom: '1px solid rgba(15,23,42,0.06)',
};

const barStyle = {
	maxWidth: '1200px',
	margin: '0 auto',
	padding: '14px 20px',
	display: 'flex',
	alignItems: 'center',
	justifyContent: 'space-between',
};

const navLinks = [
	{ to: '/', label: 'Home' },
	{ to: '/dashboard', label: 'Dashboard' },
	{ to: '/trips/list', label: 'Trips' },
	{ to: '/trips/create', label: 'Create Trip' },
	{ to: '/explore/countries', label: 'Explore' },
	{ to: '/community', label: 'Community' },
	{ to: '/calendar', label: 'Calendar' },
	{ to: '/profile', label: 'Profile' },
];

const linkStyle = (isActive) => ({
	padding: '8px 12px',
	borderRadius: '10px',
	color: isActive ? '#0f172a' : '#475569',
	background: isActive ? 'linear-gradient(90deg, #c2e9fb 0%, #a1c4fd 100%)' : 'transparent',
	textDecoration: 'none',
	fontWeight: 600,
	transition: 'all 0.25s ease',
});

function Navbar() {
	const [open, setOpen] = useState(false);

	return (
		<header style={shellStyle}>
			<div style={barStyle}>
				<Link to="/" style={{ display: 'flex', alignItems: 'center', gap: '10px', textDecoration: 'none' }}>
					<div style={{ width: 38, height: 38, borderRadius: '12px', background: 'linear-gradient(135deg, #0ea5e9 0%, #6366f1 100%)', display: 'grid', placeItems: 'center', color: '#fff', fontWeight: 800 }}>
						GT
					</div>
					<div style={{ fontWeight: 800, color: '#0f172a', letterSpacing: '0.5px' }}>GlobeTrotter</div>
				</Link>

				<nav style={{ display: 'flex', gap: '6px', alignItems: 'center', flexWrap: 'wrap' }}>
					{navLinks.map((item) => (
						<NavLink key={item.to} to={item.to} style={({ isActive }) => linkStyle(isActive)}>
							{item.label}
						</NavLink>
					))}
				</nav>

				<div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
					<Link to="/login" style={{ color: '#0f172a', fontWeight: 600, textDecoration: 'none' }}>Login</Link>
					<Link to="/register" style={{ padding: '10px 14px', borderRadius: '10px', background: 'linear-gradient(135deg, #06b6d4 0%, #3b82f6 100%)', color: '#fff', fontWeight: 700, textDecoration: 'none', boxShadow: '0 10px 30px rgba(59,130,246,0.35)' }}>
						Sign Up
					</Link>
					<button aria-label="Toggle menu" onClick={() => setOpen((v) => !v)} style={{ display: 'inline-flex', alignItems: 'center', justifyContent: 'center', width: 40, height: 40, borderRadius: '12px', border: '1px solid rgba(15,23,42,0.1)', background: '#fff' }}>
						<span style={{ width: 18, height: 2, background: '#0f172a', display: 'block', boxShadow: '0 6px 0 #0f172a, 0 -6px 0 #0f172a' }} />
					</button>
				</div>
			</div>

			<AnimatePresence>
				{open && (
					<motion.div
						initial={{ height: 0, opacity: 0 }}
						animate={{ height: 'auto', opacity: 1 }}
						exit={{ height: 0, opacity: 0 }}
						transition={{ duration: 0.25 }}
						style={{ overflow: 'hidden', borderTop: '1px solid rgba(15,23,42,0.06)', background: '#fff' }}
					>
						<div style={{ padding: '14px 20px', display: 'grid', gap: '8px' }}>
							{navLinks.map((item) => (
								<NavLink
									key={item.to}
									to={item.to}
									style={({ isActive }) => ({ ...linkStyle(isActive), display: 'block' })}
									onClick={() => setOpen(false)}
								>
									{item.label}
								</NavLink>
							))}
						</div>
					</motion.div>
				)}
			</AnimatePresence>
		</header>
	);
}

export default Navbar;
