import React, { useState } from 'react';
import { motion } from 'framer-motion';

const containerStyle = {
	display: 'grid',
	placeItems: 'center',
	minHeight: '70vh',
};

const cardStyle = {
	width: '100%',
	maxWidth: 460,
	padding: '32px 30px',
	borderRadius: 18,
	background: '#ffffff',
	boxShadow: '0 30px 80px rgba(15,23,42,0.12)',
	border: '1px solid rgba(15,23,42,0.06)',
};

function Login() {
	const [email, setEmail] = useState('');
	const [password, setPassword] = useState('');
	const [errors, setErrors] = useState({});
	const [loading, setLoading] = useState(false);
	const [message, setMessage] = useState('');

	const validate = () => {
		const next = {};
		if (!email.includes('@')) next.email = 'Enter a valid email';
		if (password.length < 6) next.password = 'Password must be 6+ characters';
		setErrors(next);
		return Object.keys(next).length === 0;
	};

	const handleSubmit = (e) => {
		e.preventDefault();
		setMessage('');
		if (!validate()) return;
		setLoading(true);
		setTimeout(() => {
			setLoading(false);
			setMessage('Login successful. Welcome back, explorer!');
		}, 1200);
	};

	return (
		<div style={containerStyle}>
			<motion.div
				initial={{ y: 24, opacity: 0 }}
				animate={{ y: 0, opacity: 1 }}
				transition={{ duration: 0.5, ease: 'easeOut' }}
				style={cardStyle}
			>
				<div style={{ marginBottom: 18 }}>
					<div style={{ fontWeight: 800, fontSize: 14, color: '#06b6d4', letterSpacing: '0.5px' }}>PREMIUM ACCESS</div>
					<h1 style={{ margin: '6px 0 4px', fontSize: 26, color: '#0f172a' }}>Sign in to travel</h1>
					<p style={{ color: '#475569' }}>Plan, track, and elevate every journey.</p>
				</div>

				<form onSubmit={handleSubmit} style={{ display: 'grid', gap: 14 }}>
					<label style={{ display: 'grid', gap: 6 }}>
						<span style={{ color: '#0f172a', fontWeight: 600 }}>Email</span>
						<input
							type="email"
							value={email}
							onChange={(e) => setEmail(e.target.value)}
							placeholder="you@example.com"
							style={{ padding: '12px 14px', borderRadius: 12, border: `1px solid ${errors.email ? '#ef4444' : '#cbd5e1'}`, outline: 'none', fontSize: 15, transition: 'all 0.2s ease' }}
						/>
						{errors.email && <span style={{ color: '#ef4444', fontSize: 13 }}>{errors.email}</span>}
					</label>

					<label style={{ display: 'grid', gap: 6 }}>
						<span style={{ color: '#0f172a', fontWeight: 600 }}>Password</span>
						<input
							type="password"
							value={password}
							onChange={(e) => setPassword(e.target.value)}
							placeholder="••••••••"
							style={{ padding: '12px 14px', borderRadius: 12, border: `1px solid ${errors.password ? '#ef4444' : '#cbd5e1'}`, outline: 'none', fontSize: 15, transition: 'all 0.2s ease' }}
						/>
						{errors.password && <span style={{ color: '#ef4444', fontSize: 13 }}>{errors.password}</span>}
					</label>

					<motion.button
						type="submit"
						whileHover={{ y: -2 }}
						whileTap={{ scale: 0.99 }}
						style={{ marginTop: 6, padding: '12px 16px', borderRadius: 12, border: 'none', background: 'linear-gradient(135deg, #06b6d4 0%, #2563eb 100%)', color: '#fff', fontWeight: 700, cursor: 'pointer', boxShadow: '0 18px 40px rgba(37,99,235,0.25)', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10 }}
						disabled={loading}
					>
						{loading ? (
							<motion.div animate={{ rotate: 360 }} transition={{ repeat: Infinity, duration: 1, ease: 'linear' }} style={{ width: 16, height: 16, border: '3px solid rgba(255,255,255,0.4)', borderTopColor: '#fff', borderRadius: '50%' }} />
						) : (
							'Login'
						)}
					</motion.button>
				</form>

				{message && (
					<motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} style={{ marginTop: 14, padding: '10px 12px', borderRadius: 10, background: 'rgba(16,185,129,0.1)', color: '#0f172a', fontWeight: 600 }}>
						{message}
					</motion.div>
				)}
			</motion.div>
		</div>
	);
}

export default Login;
