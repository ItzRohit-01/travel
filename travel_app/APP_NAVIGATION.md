# YATRA Travel App - Complete Navigation Guide

## App Structure & Navigation Flow

### 🔐 Authentication Flow
**Login Screen** → **Dashboard**
- `LoginPage` → Input email/password → Navigate to `DashboardPage`
- Sign up link → Navigate to `SignupPage`

**Signup Screen** → **Dashboard**
- `SignupPage` → Fill registration form → Auto-login → Navigate to `DashboardPage`
- Already have account → Navigate back to `LoginPage`

---

### 🏠 Main Dashboard (Home Screen)
**Location**: `lib/screens/dashboard_page.dart`

#### Top Bar Actions:
- **Calendar Icon** → Navigate to `CalendarScreen`
- **Community Icon** → Navigate to `CommunityScreen`
- **Menu (⋮)**:
  - Admin Panel → Navigate to `AdminPanelScreen`
  - Logout → Return to `LoginPage`

#### Main Content:
- **Banner Image**: Welcome section with trip emoji decorations
- **Search Bar (Read-only)**: Tap → Navigate to `SearchPage`
- **Filter Buttons**: Group by, Filter, Sort by (placeholder actions)
- **Top Regional Selections**: Horizontal scrollable city cards (tap shows snackbar)
- **Previous Trips**: Horizontal scrollable trip cards
  - Tap card → Navigate to `ItineraryPage` (edit mode)
- **Plan a Trip Button** → Navigate to `PlanTripPage`

#### Bottom Navigation Bar (4 tabs):
1. **Home** (index 0): Current Dashboard view
2. **Search** (index 1): Navigate to `SearchPage`
3. **My Trips** (index 2): Navigate to `UserTripListingPage`
4. **Profile** (index 3): Navigate to `UserProfilePage`

---

### 🗓️ Calendar View Screen
**Location**: `lib/screens/calander.dart`

**Features**:
- Monthly calendar view with trip events overlaid
- Month navigation (previous/next)
- Search, Filter, Sort, Group by controls
- Color-coded trip cards showing:
  - Trip dates with visual indicators (start/end badges)
  - Destination, type, status
  - Budget and accommodation info
  - Transportation mode
- Tap trip card → View detailed trip modal

**Navigation**: Back button returns to Dashboard

---

### 👥 Community Screen
**Location**: `lib/screens/community.dart`

**Features**:
- Social feed of travel posts from community members
- Post cards showing:
  - User avatar, name, location
  - Post title, content, category badge
  - Like, comment, share counts
  - Multiple images per post
  - Popular badge for trending posts
- Like button (heart icon) with animation
- Search, Filter, Sort, Group by controls
- Category filters: All, Tips, Reviews, Questions, Photos

**Navigation**: Back button returns to Dashboard

---

### 🔍 Search / City Search Page
**Location**: `lib/screens/search_page.dart`

**Features**:
- Search bar for destinations/cities
- Search results with city cards
- Filter, sort options
- Tap city → Show city details

**Navigation**: Back button returns to previous screen

---

### ✈️ Plan a Trip Screen
**Location**: `lib/screens/plan_trip_page.dart`

**Input Fields**:
- Trip name
- Destination
- Start date (date picker)
- End date (date picker)
- Budget (optional)
- Additional suggestions (text area)

**Actions**:
- **Cancel**: Go back to Dashboard
- **Create Trip**: 
  - Save trip to backend
  - Navigate to `ItineraryPage` (build itinerary)

---

### 📋 Build Itinerary Screen
**Location**: `lib/screens/itenary_page.dart`

**Features**:
- Trip header with name and date range
- **Itinerary Sections** (expandable list):
  - Section title (editable)
  - Description (editable)
  - Date range picker (within trip bounds)
  - Budget field (editable)
  - Remove section button (minimum 1 section required)
- **Add Section Button**: Creates new empty section
- **Save Itinerary Button**: 
  - Shows summary dialog with:
    - Total sections count
    - Total budget
  - Actions in dialog:
    - "Keep Editing" → Close dialog, stay on page
    - "Go to Dashboard" → Navigate to Dashboard

**Navigation**: AppBar back button returns to Dashboard

---

### 📱 My Trips / User Trip Listing Screen
**Location**: `lib/screens/user_tripping_list_page.dart`

**Features**:
- Search bar for filtering trips
- Filter by status: All, Ongoing, Upcoming, Completed
- Sort by: Date, Budget, Name
- Group by: Status, Destination

**Trip Cards** (organized by status):
- **Ongoing**: Currently active trips
- **Upcoming**: Future planned trips
- **Completed**: Past trips

**Card Interactions**:
- **Tap**: Navigate to `ItineraryViewScreen` (read-only detailed view)
- **Long Press**: Show trip details dialog with:
  - Destination, dates, budget, title
  - Actions:
    - "Close" → Dismiss dialog
    - "View Itinerary" → Navigate to `ItineraryViewScreen`
    - "Edit" → Navigate to `ItineraryPage` (edit mode)

**Navigation**: Back button returns to Dashboard

---

### 📖 Itinerary View Screen (Read-Only)
**Location**: `lib/screens/itenary_view_screen.dart`

**Features**:
- Destination header with date range
- Day-by-day itinerary breakdown
- **Each Day Shows**:
  - Day number and date
  - List of activities with:
    - Activity name
    - Time
    - Expense
    - Category badge
    - Completion checkbox
  - Day total expense
  - Notes section
- **Summary Card** (sticky at bottom):
  - Total days
  - Total activities
  - Total budget
  - Average daily spending
- Search, Filter (category), Sort (time/expense), Group by (day/category) controls

**Navigation**: Back button returns to trip listing page

---

### 👤 User Profile Screen
**Location**: `lib/screens/user_profile_pages.dart`

**Features**:
- User avatar (initials)
- Profile information:
  - Name
  - Email
  - Phone
  - Bio
- Profile stats:
  - Total trips
  - Countries visited
  - Total budget spent
- **Pre-planned Trips Section**: Grid of upcoming trip cards
- **Previous Trips Section**: Grid of completed trip cards
- Tap trip card → View trip details

**Navigation**: Back button returns to Dashboard

---

### 🔧 Admin Panel Screen
**Location**: `lib/screens/Control_panel_enhanced.dart`

**Features**:
- **Overview Tab**:
  - Analytics charts (users, trips, revenue trends)
  - Popular destinations bar chart
  - Popular activities bar chart
  - Recent users table
- **Statistics Cards**:
  - Total Users
  - Total Trips
  - Total Revenue
  - Active Now
- Search, Filter, Sort, Group by controls
- **Recent Users List** with:
  - User details (name, email, avatar)
  - Trip count, spending
  - Join date, status badge
  - Action buttons per user

**Navigation**: Back button or menu returns to Dashboard

---

## 🎯 Complete User Journey Examples

### Journey 1: New User Registration → Create First Trip
1. Open app → `LoginPage`
2. Tap "Don't have an account? Sign up" → `SignupPage`
3. Fill form → Tap "Register User" → Auto-login → `DashboardPage`
4. Tap "Plan a trip" button → `PlanTripPage`
5. Fill trip details → Tap "Create Trip" → `ItineraryPage`
6. Add sections, dates, budgets → Tap "Save Itinerary"
7. In dialog, tap "Go to Dashboard" → `DashboardPage`

### Journey 2: Existing User Checks Trips
1. Login → `DashboardPage`
2. Tap "My Trips" in bottom nav → `UserTripListingPage`
3. See trips organized by status (Ongoing/Upcoming/Completed)
4. Tap a trip card → `ItineraryViewScreen` (detailed view)
5. Back → `UserTripListingPage`
6. Long-press another trip → Dialog appears
7. Tap "Edit" → `ItineraryPage` (edit mode)

### Journey 3: Browse Community & Calendar
1. Dashboard → Tap calendar icon → `CalendarScreen`
2. View trips in monthly calendar format
3. Back → Dashboard
4. Tap community icon → `CommunityScreen`
5. Scroll feed, like posts, view content
6. Back → Dashboard

### Journey 4: Search & Plan Trip
1. Dashboard → Tap search bar → `SearchPage`
2. Search for "Paris"
3. View results, select city
4. Back → Dashboard → "Plan a trip"
5. Fill with "Paris" destination → Create → Build itinerary

---

## 🎨 UI/UX Features

### Color Scheme:
- Primary Blue: `#667EEA`
- Primary Purple: `#764BA2`
- Success Green: `#6BCB77`
- Error Red: `#FF6B6B`
- Text Dark: `#2C3E50`
- Text Light: `#95A3B3`

### Animations:
- Fade-in animations on screen load
- Slide animations for cards
- Scale animations on button taps
- Progress indicators for loading states

### Consistent Elements:
- AppBar with "YATRA" title (custom styled)
- Gradient containers (blue to purple)
- Rounded cards with shadows
- Icon badges for categories/status
- Bottom navigation bar (4 tabs)
- Pull-to-refresh on list screens

---

## 📱 Bottom Navigation Tabs Summary

| Index | Icon | Label | Destination |
|-------|------|-------|-------------|
| 0 | 🏠 | Home | DashboardPage |
| 1 | 🔍 | Search | SearchPage |
| 2 | 📋 | My Trips | UserTripListingPage |
| 3 | 👤 | Profile | UserProfilePage |

---

## 🚀 Quick Access from Dashboard

| Feature | Access Method | Destination |
|---------|---------------|-------------|
| Calendar | Top bar icon | CalendarScreen |
| Community | Top bar icon | CommunityScreen |
| Admin Panel | Menu → Admin Panel | AdminPanelScreen |
| Search | Search bar tap | SearchPage |
| Plan Trip | "Plan a trip" button | PlanTripPage |
| Previous Trips | Tap trip card | ItineraryPage (edit) |
| My Trips | Bottom nav | UserTripListingPage |
| Profile | Bottom nav | UserProfilePage |
| Logout | Menu → Logout | LoginPage |

---

## 🔄 Navigation Methods Used

1. **Navigator.push**: Standard forward navigation
2. **Navigator.pushReplacement**: Replace current screen (login → dashboard)
3. **Navigator.pushNamedAndRemoveUntil**: Clear stack and go to route
4. **Navigator.pop**: Go back to previous screen
5. **MaterialPageRoute**: Define screen transitions
6. **Named routes**: Defined in main.dart for common screens

---

## ✅ All Screens Linked

✓ Login → Dashboard  
✓ Signup → Dashboard  
✓ Dashboard → Calendar  
✓ Dashboard → Community  
✓ Dashboard → Admin Panel  
✓ Dashboard → Search  
✓ Dashboard → Plan Trip  
✓ Dashboard → Previous Trip Cards → Itinerary Edit  
✓ Dashboard → My Trips (bottom nav)  
✓ Dashboard → Profile (bottom nav)  
✓ Plan Trip → Itinerary Builder  
✓ Itinerary Builder → Dashboard  
✓ My Trips → Itinerary View (tap)  
✓ My Trips → Itinerary Edit (long press → Edit)  
✓ My Trips → Trip Details Dialog (long press)  

**All screens are fully connected! 🎉**
