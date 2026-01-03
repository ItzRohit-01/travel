import React, { useState } from 'react';
import { motion } from 'framer-motion';

const formGrid = {
	display: 'grid',
	gap: 12,
	gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))',
};

const shell = {
	maxWidth: 820,
	margin: '0 auto',
	background: '#ffffff',
	padding: '28px 30px',
	borderRadius: 18,
	border: '1px solid rgba(15,23,42,0.06)',
	boxShadow: '0 30px 80px rgba(15,23,42,0.1)',
};

function Register() {
	const [form, setForm] = useState({ first: '', last: '', email: '', phone: '', country: '', password: '' });
	const [errors, setErrors] = useState({});
	const [success, setSuccess] = useState(false);

	const handleChange = (field, value) => {
		setForm((prev) => ({ ...prev, [field]: value }));
	};

	const validate = () => {
		const next = {};
		if (!form.first) next.first = 'Required';
		if (!form.last) next.last = 'Required';
		if (!form.email.includes('@')) next.email = 'Valid email required';
		if (form.phone.length < 6) next.phone = 'Phone seems too short';
		if (!form.country) next.country = 'Select a country';
		if (form.password.length < 6) next.password = '6+ characters needed';
		setErrors(next);
		return Object.keys(next).length === 0;
	};

	const handleSubmit = (e) => {
		e.preventDefault();
		setSuccess(false);
		if (!validate()) return;
		setSuccess(true);
	};

	const inputStyle = (field) => ({
		padding: '12px 14px',
		borderRadius: 12,
		border: `1px solid ${errors[field] ? '#ef4444' : '#cbd5e1'}`,
		outline: 'none',
		transition: 'all 0.2s ease',
		fontSize: 15,
	});

	return (
		<motion.div initial={{ opacity: 0, y: 22 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.45 }} style={shell}>
			<div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 12, flexWrap: 'wrap', marginBottom: 14 }}>
				<div>
					<div style={{ fontWeight: 800, fontSize: 14, color: '#06b6d4', letterSpacing: '0.5px' }}>JOIN THE CREW</div>
					<h2 style={{ margin: '6px 0 4px', fontSize: 26, color: '#0f172a' }}>Create your travel identity</h2>
					<p style={{ color: '#475569' }}>Inline validation keeps you on track.</p>
				</div>
			</div>

			<form onSubmit={handleSubmit} style={{ display: 'grid', gap: 16 }}>
				<div style={formGrid}>
					{['first', 'last', 'email', 'phone', 'country', 'password'].map((field) => (
						<label key={field} style={{ display: 'grid', gap: 6 }}>
							<span style={{ color: '#0f172a', fontWeight: 600 }}>{field === 'first' ? 'First name' : field === 'last' ? 'Last name' : field.charAt(0).toUpperCase() + field.slice(1)}</span>
							<input
								type={field === 'password' ? 'password' : 'text'}
								value={form[field]}
								onChange={(e) => handleChange(field, e.target.value)}
								placeholder={field === 'country' ? 'Country of residence' : ''}
								style={{ ...inputStyle(field), boxShadow: errors[field] ? '0 0 0 3px rgba(239,68,68,0.1)' : '0 8px 18px rgba(15,23,42,0.04)' }}
							/>
							{errors[field] && <span style={{ color: '#ef4444', fontSize: 13 }}>{errors[field]}</span>}
						</label>
					))}
				</div>

				<motion.button
					type="submit"
					whileHover={{ y: -2 }}
					whileTap={{ scale: 0.99 }}
					style={{ padding: '13px 16px', borderRadius: 12, border: 'none', background: 'linear-gradient(135deg, #22d3ee 0%, #6366f1 100%)', color: '#fff', fontWeight: 800, cursor: 'pointer', boxShadow: '0 18px 40px rgba(79,70,229,0.28)' }}
				>
					Create account
				</motion.button>
			</form>

			{success && (
				<motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} style={{ marginTop: 14, padding: '12px 14px', borderRadius: 12, background: 'rgba(34,211,238,0.12)', color: '#0f172a', fontWeight: 600 }}>
					Profile created. You are ready to explore.
				</motion.div>
			)}
		</motion.div>
	);
}

export default Register;
