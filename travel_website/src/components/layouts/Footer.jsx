import React from 'react';

const footerStyle = {
	padding: '16px 20px 32px',
	textAlign: 'center',
	color: '#64748b',
	borderTop: '1px solid rgba(15,23,42,0.05)',
	background: 'rgba(255,255,255,0.85)',
};

function Footer() {
	return (
		<footer style={footerStyle}>
			Built for explorers • Travel Planner Demo UI
		</footer>
	);
}

export default Footer;
