import React from 'react';
import { Outlet } from 'react-router-dom';
import Navbar from './Navbar';
import Footer from './Footer';

const wrapperStyle = {
	minHeight: '100vh',
	display: 'flex',
	flexDirection: 'column',
};

const mainStyle = {
	flex: 1,
	width: '100%',
	maxWidth: '1200px',
	margin: '0 auto',
	padding: '24px 20px 48px',
	boxSizing: 'border-box',
};

function PageWrapper({ children }) {
	return (
		<div style={wrapperStyle}>
			<Navbar />
			<main style={mainStyle}>
				{children || <Outlet />}
			</main>
			<Footer />
		</div>
	);
}

export default PageWrapper;
