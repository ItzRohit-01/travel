import React, { lazy, Suspense } from 'react';
import { createBrowserRouter, Navigate } from 'react-router-dom';
import PageWrapper from './components/layouts/Pagewrapper';

const Home = lazy(() => import('./pages/Home'));
const Login = lazy(() => import('./pages/Login'));
const Register = lazy(() => import('./pages/Register'));
const Dashboard = lazy(() => import('./pages/Dashboard/Dashboard'));
const DestinationDetail = lazy(() => import('./pages/DestinationDetail'));
const CreateTrip = lazy(() => import('./pages/Trips/CreateTrip'));
const BuildItinerary = lazy(() => import('./pages/Trips/BuildItinerary'));
const TripList = lazy(() => import('./pages/Trips/TripList'));
const ItineraryView = lazy(() => import('./pages/Trips/ItineraryView'));
const Countries = lazy(() => import('./pages/Explore/Countries'));
const Community = lazy(() => import('./pages/Community/Community'));
const CalendarView = lazy(() => import('./pages/Calendar/CalendarView'));
const Profile = lazy(() => import('./pages/Profile/Profile'));

const suspenseFallback = (
	<div style={{ display: 'grid', placeItems: 'center', minHeight: '60vh' }}>
		<div style={{ padding: '16px 24px', borderRadius: '12px', background: '#fff', boxShadow: '0 10px 40px rgba(15,23,42,0.1)' }}>
			Loading travel experience...
		</div>
	</div>
);

const router = createBrowserRouter([
	{
		path: '/',
		element: <PageWrapper />,
		children: [
			{ index: true, element: <Suspense fallback={suspenseFallback}><Home /></Suspense> },
			{ path: 'login', element: <Suspense fallback={suspenseFallback}><Login /></Suspense> },
			{ path: 'register', element: <Suspense fallback={suspenseFallback}><Register /></Suspense> },
			{ path: 'dashboard', element: <Suspense fallback={suspenseFallback}><Dashboard /></Suspense> },
			{ path: 'destination/:id', element: <Suspense fallback={suspenseFallback}><DestinationDetail /></Suspense> },
			{ path: 'trips/create', element: <Suspense fallback={suspenseFallback}><CreateTrip /></Suspense> },
			{ path: 'trips/build', element: <Suspense fallback={suspenseFallback}><BuildItinerary /></Suspense> },
			{ path: 'trips/list', element: <Suspense fallback={suspenseFallback}><TripList /></Suspense> },
			{ path: 'trips/itinerary', element: <Suspense fallback={suspenseFallback}><ItineraryView /></Suspense> },
			{ path: 'explore/countries', element: <Suspense fallback={suspenseFallback}><Countries /></Suspense> },
			{ path: 'community', element: <Suspense fallback={suspenseFallback}><Community /></Suspense> },
			{ path: 'calendar', element: <Suspense fallback={suspenseFallback}><CalendarView /></Suspense> },
			{ path: 'profile', element: <Suspense fallback={suspenseFallback}><Profile /></Suspense> },
			{ path: '*', element: <Navigate to="/dashboard" replace /> },
		],
	},
]);

export default router;
