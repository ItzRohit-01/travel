# YATRA Travel App - Testing Checklist

## ✅ Navigation Testing Checklist

### Authentication Flow
- [ ] Login with valid credentials → Navigate to Dashboard
- [ ] Login with invalid credentials → Show error message
- [ ] Click "Sign up" on Login → Navigate to Signup Page
- [ ] Fill signup form → Auto-login → Navigate to Dashboard
- [ ] Logout from Dashboard → Return to Login Page

### Dashboard Navigation
- [ ] Tap Calendar icon (top bar) → Open Calendar Screen
- [ ] Tap Community icon (top bar) → Open Community Screen
- [ ] Tap Menu ⋮ → Select Admin Panel → Open Admin Panel Screen
- [ ] Tap Search bar → Open Search Page
- [ ] Tap "Plan a trip" button → Open Plan Trip Page
- [ ] Tap Previous Trip card → Open Itinerary Edit Page
- [ ] Tap Regional Selection city → Show snackbar
- [ ] Pull to refresh → Reload trips and cities data

### Bottom Navigation
- [ ] Tap Home icon → Stay on Dashboard
- [ ] Tap Search icon → Navigate to Search Page
- [ ] Tap My Trips icon → Navigate to User Trip Listing
- [ ] Tap Profile icon → Navigate to User Profile Page
- [ ] Selected tab shows active color (blue)
- [ ] Unselected tabs show inactive color (grey)

### Trip Creation Flow
- [ ] Dashboard → Plan Trip → Fill form → Create Trip
- [ ] After create → Navigate to Build Itinerary Page
- [ ] Itinerary page shows correct trip name and dates
- [ ] Can add multiple sections
- [ ] Can edit section title, description, dates, budget
- [ ] Can remove sections (minimum 1 required)
- [ ] Save Itinerary → Show summary dialog
- [ ] Dialog "Keep Editing" → Close dialog, stay on page
- [ ] Dialog "Go to Dashboard" → Navigate to Dashboard
- [ ] New trip appears in Previous Trips on Dashboard

### My Trips Screen
- [ ] Navigate to My Trips from bottom nav
- [ ] See trips organized by: Ongoing, Upcoming, Completed
- [ ] Search bar filters trips by title/destination
- [ ] Filter by status: All, Ongoing, Upcoming, Completed
- [ ] Sort by: Date, Budget, Name
- [ ] Group by: Status, Destination
- [ ] Tap trip card → Navigate to Itinerary View Screen
- [ ] Long press trip card → Show trip details dialog
- [ ] Dialog "Close" → Dismiss dialog
- [ ] Dialog "View Itinerary" → Navigate to Itinerary View
- [ ] Dialog "Edit" → Navigate to Build Itinerary (edit mode)

### Itinerary View Screen (Read-Only)
- [ ] Shows destination and date range in header
- [ ] Displays day-by-day breakdown
- [ ] Shows activities with time, expense, category
- [ ] Can check/uncheck activity completion
- [ ] Shows day total expense
- [ ] Shows overall summary card (total days, activities, budget)
- [ ] Search filter works
- [ ] Category filter works
- [ ] Sort by time/expense works
- [ ] Back button returns to Trip Listing

### Calendar Screen
- [ ] Monthly calendar displays correctly
- [ ] Trip events overlay on calendar dates
- [ ] Start date shows "START" badge
- [ ] End date shows "END" badge
- [ ] Multi-day trips span correctly
- [ ] Previous/Next month navigation works
- [ ] Trip cards show destination, type, status, budget
- [ ] Tap trip card → Show trip detail modal
- [ ] Search/Filter/Sort controls work
- [ ] Back button returns to Dashboard

### Community Screen
- [ ] Community feed displays posts
- [ ] Post cards show user info, content, images
- [ ] Like button works (heart fills/unfills)
- [ ] Like count updates
- [ ] Popular badge shows on trending posts
- [ ] Category badges display correctly
- [ ] Filter by category works
- [ ] Sort by popular/recent works
- [ ] Search posts works
- [ ] Back button returns to Dashboard

### Admin Panel Screen
- [ ] Overview tab shows analytics
- [ ] Charts render correctly
- [ ] Popular destinations chart displays
- [ ] Popular activities chart displays
- [ ] Recent users table shows data
- [ ] User status badges display
- [ ] Search/Filter/Sort controls work
- [ ] Back button returns to Dashboard

### Search Page
- [ ] Search bar accepts input
- [ ] Search results display
- [ ] City cards show with images
- [ ] Filter/Sort options work
- [ ] Back button returns to previous screen

### User Profile Page
- [ ] Profile info displays (name, email, phone, bio)
- [ ] Avatar shows user initials
- [ ] Stats show (trips, countries, budget)
- [ ] Pre-planned trips grid displays
- [ ] Previous trips grid displays
- [ ] Tap trip card → View trip details
- [ ] Back button returns to Dashboard

## 🔥 Critical User Journeys

### Journey 1: New User Complete Flow
1. [ ] Open app → Login Page
2. [ ] Tap "Sign up" → Signup Page
3. [ ] Fill form → Register → Auto-login → Dashboard
4. [ ] Tap "Plan a trip" → Plan Trip Page
5. [ ] Fill details → Create Trip → Build Itinerary
6. [ ] Add 3 sections with dates and budgets
7. [ ] Save → "Go to Dashboard" → Dashboard
8. [ ] Verify trip appears in Previous Trips
9. [ ] Tap trip card → Opens Itinerary Edit
10. [ ] Back → Dashboard

### Journey 2: Existing User Views Trips
1. [ ] Login → Dashboard
2. [ ] Bottom Nav → My Trips
3. [ ] See trips in Ongoing/Upcoming/Completed
4. [ ] Tap a trip → Itinerary View (detailed)
5. [ ] Back → My Trips
6. [ ] Long press another trip → Dialog
7. [ ] Tap "Edit" → Build Itinerary (edit mode)
8. [ ] Modify section → Save → Dashboard

### Journey 3: Browse & Social
1. [ ] Dashboard → Calendar icon → Calendar View
2. [ ] Navigate months, view trips
3. [ ] Back → Dashboard
4. [ ] Community icon → Community Screen
5. [ ] Scroll feed, like posts
6. [ ] Back → Dashboard
7. [ ] Menu → Admin Panel → Admin Screen
8. [ ] View analytics
9. [ ] Back → Dashboard

### Journey 4: Search & Plan
1. [ ] Dashboard → Tap Search bar → Search Page
2. [ ] Search "Tokyo"
3. [ ] View results
4. [ ] Back → Dashboard
5. [ ] "Plan a trip" → Fill "Tokyo" details
6. [ ] Create → Build Itinerary
7. [ ] Add sections → Save → Dashboard

## 🎨 UI/UX Testing

### Visual Consistency
- [ ] All screens use YATRA branding
- [ ] Color scheme consistent (blue/purple gradient)
- [ ] Icons consistent across screens
- [ ] Font sizes and weights consistent
- [ ] Card shadows and borders consistent
- [ ] Status badges color-coded properly

### Animations
- [ ] Screen transitions smooth
- [ ] Card animations on list screens
- [ ] Button press feedback
- [ ] Loading indicators show during data fetch
- [ ] Fade-in animations on screen load

### Error Handling
- [ ] Network errors show proper messages
- [ ] Empty states display correctly
- [ ] Form validation errors display
- [ ] Pull-to-refresh on error states
- [ ] Retry buttons work

### Data Loading
- [ ] Loading spinners display while fetching
- [ ] Trips load from backend API
- [ ] Cities load from backend API
- [ ] Profile stats calculate correctly
- [ ] Trip status determined correctly (ongoing/upcoming/completed)

## 📱 Device Testing

### Android Device
- [ ] App runs on physical Android device
- [ ] Backend API accessible (use LAN IP)
- [ ] All navigation works
- [ ] Bottom nav bar displays properly
- [ ] Forms and inputs work with keyboard
- [ ] Date pickers work
- [ ] Image loading works

### iOS Simulator/Device
- [ ] App runs on iOS
- [ ] All navigation works
- [ ] Native iOS styling respected
- [ ] Keyboard behavior correct

## 🐛 Bug Checks

- [ ] No navigation stack issues (can't back to wrong screen)
- [ ] No duplicate screens in stack
- [ ] Logout clears stack properly
- [ ] No memory leaks from unclosed controllers
- [ ] No crashes on null data
- [ ] Trip dates validate correctly (end >= start)
- [ ] Budget calculations accurate
- [ ] Search filters don't crash on empty results

## ✨ Feature Completeness

### Implemented ✓
- [x] Login & Signup with Firebase Auth
- [x] Dashboard with trips and cities
- [x] Calendar view with trip overlay
- [x] Community feed
- [x] Admin panel with analytics
- [x] Search functionality
- [x] Trip creation flow
- [x] Itinerary builder with sections
- [x] Itinerary view (read-only)
- [x] User trip listing by status
- [x] User profile with stats
- [x] Bottom navigation
- [x] All screens linked
- [x] Backend integration

### Future Enhancements
- [ ] Real-time chat in community
- [ ] Photo upload for trips
- [ ] Map integration
- [ ] Weather integration
- [ ] Currency converter
- [ ] Travel recommendations AI
- [ ] Offline mode
- [ ] Push notifications
- [ ] Social sharing

---

## ✅ Test Result Summary

Total Tests: **XX**  
Passed: **XX**  
Failed: **XX**  
Blocked: **XX**  

---

**Tester**: _______________  
**Date**: _______________  
**Device**: _______________  
**OS Version**: _______________  
**App Version**: _______________  

---

**Notes**:
