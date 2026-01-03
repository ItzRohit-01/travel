import React from 'react';
import { RouterProvider } from 'react-router-dom';
import router from './routes';

const appShellStyle = {
	fontFamily: "'Segoe UI', 'Helvetica Neue', Arial, sans-serif",
	background: 'linear-gradient(145deg, #f8fbff 0%, #eef3ff 50%, #fefefe 100%)',
	color: '#0f172a',
	minHeight: '100vh',
};

function App() {
	return (
		<div style={appShellStyle}>
			<RouterProvider router={router} />
		</div>
	);
}

export default App;
