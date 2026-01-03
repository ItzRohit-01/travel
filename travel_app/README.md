# GlobalTrotter - AI-Powered Travel Planning App

<div align="center">

**A modern, intelligent travel planning application built with Flutter and Django**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Django](https://img.shields.io/badge/Django-5.1-092E20?logo=django)](https://www.djangoproject.com)
[![Firebase](https://img.shields.io/badge/Firebase-Auth-FFCA28?logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

## 📖 Overview

GlobalTrotter is a comprehensive travel planning application that combines modern mobile design with artificial intelligence to help users plan, organize, and manage their travel experiences. The app features an intelligent AI travel assistant powered by multiple AI providers (Gemini, OpenAI), Firebase authentication, and a robust Django REST API backend.

## ✨ Key Features

### 🤖 AI Travel Assistant
- **Intelligent Chatbot** with multi-provider support (Gemini, OpenAI, Fallback)
- Contextual conversation memory
- Quick question suggestions for common travel queries
- Real-time typing indicators and smooth animations
- Travel-specific recommendations and assistance

### 🗺️ Trip Management
- Create and manage multiple trips
- Detailed itinerary planning with day-by-day scheduling
- Trip status tracking (Planned, Active, Completed)
- Image uploads and destination management
- Calendar integration for trip dates

### 🔍 Search & Discovery
- Search trips by destination or title
- Browse popular cities with ratings and reviews
- Advanced filtering and sorting options
- Real-time search results

### 👤 User Features
- Firebase Authentication (Email/Password)
- User profile management
- Trip history and statistics
- Personalized dashboard with quick actions
- Community features for sharing experiences

### 🎨 Modern UI/UX
- Material Design 3 principles
- Gradient-based color schemes
- Smooth animations and transitions
- Responsive layouts for all screen sizes
- Dark mode support (coming soon)

## 🏗️ Architecture

### Frontend (Flutter)
```
lib/
├── main.dart                 # App entry point & routing
├── screens/                  # All UI screens
│   ├── login_page.dart
│   ├── signup_page.dart
│   ├── dashboard_page.dart
│   ├── plan_trip_page.dart
│   ├── itenary_page.dart
│   ├── search_page.dart
│   ├── chatbot_screen.dart
│   └── ...
├── services/                 # Business logic & API
│   ├── auth_service.dart    # Firebase authentication
│   ├── trip_service.dart    # Trip CRUD operations
│   └── ai_chat_service.dart # Multi-provider AI service
└── models/                   # Data models
```

### Backend (Django REST API)
```
travel_api/
├── manage.py
├── travel_api/              # Project settings
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
└── trips/                   # Trip management app
    ├── models.py           # Trip & PopularCity models
    ├── views.py            # API endpoints
    ├── serializers.py      # Data serialization
    └── urls.py             # Route configuration
```

## 🚀 Getting Started

### Prerequisites

**Frontend Requirements:**
- Flutter SDK 3.0 or higher
- Dart SDK (comes with Flutter)
- Android Studio / VS Code with Flutter extensions
- iOS development tools (macOS only)

**Backend Requirements:**
- Python 3.8 or higher
- pip (Python package manager)
- PostgreSQL 12+ (or SQLite for development)
- Virtual environment (recommended)

### Installation

#### 1. Clone the Repository
```bash
git clone <repository-url>
cd travel_app
```

#### 2. Frontend Setup (Flutter)

```bash
# Install Flutter dependencies
flutter pub get

# Configure Firebase
# - Create a Firebase project at https://console.firebase.google.com
# - Download google-services.json (Android) and GoogleService-Info.plist (iOS)
# - Place files in android/app/ and ios/Runner/ respectively
# - Update lib/firebase_options.dart with your config

# Run the app
flutter run
```

#### 3. Backend Setup (Django)

```bash
# Navigate to backend directory
cd travel_api

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Set up environment variables
# Create a .env file with:
# - SECRET_KEY=your-secret-key
# - DEBUG=True
# - DATABASE_URL=your-database-url

# Run migrations
python manage.py migrate

# Create superuser (optional)
python manage.py createsuperuser

# Run development server
python manage.py runserver
```

#### 4. Configure API Endpoints

Update the API base URL in Flutter app:
```dart
// lib/services/trip_service.dart
static const String baseUrl = 'http://localhost:8000/api';

// For physical device testing, use your computer's IP:
// static const String baseUrl = 'http://192.168.1.x:8000/api';
```

## 🔧 Configuration

### AI Chatbot Configuration

The chatbot supports three modes (configured in `lib/screens/chatbot_screen.dart`):

#### Mode 1: Intelligent Fallback (Default - No API Key Required)
```dart
_aiService = AIChatService(
  apiKey: '',
  provider: AIProvider.fallback,
);
```
- Uses pattern matching and contextual responses
- Fully functional without API keys
- Perfect for development and testing

#### Mode 2: Google Gemini AI (Recommended)
```dart
_aiService = AIChatService(
  apiKey: 'YOUR_GEMINI_API_KEY',
  provider: AIProvider.gemini,
);
```
- Free tier available at https://makersuite.google.com/app/apikey
- Advanced natural language understanding
- Context-aware conversations

#### Mode 3: OpenAI ChatGPT
```dart
_aiService = AIChatService(
  apiKey: 'YOUR_OPENAI_API_KEY',
  provider: AIProvider.openai,
);
```
- Requires paid API key from https://platform.openai.com/api-keys
- Premium conversation quality

### Firebase Setup

1. Create a Firebase project
2. Enable Email/Password authentication
3. Download configuration files:
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`
4. Run Firebase CLI configuration:
   ```bash
   flutter pub global activate flutterfire_cli
   flutterfire configure
   ```

## 📱 Screens & Navigation

### Authentication Flow
- **Login Page** - Email/password authentication
- **Signup Page** - New user registration
- Auto-navigation to dashboard on success

### Main Application
- **Dashboard** - Trip overview, quick actions, AI assistant button
- **Plan Trip** - Create new trips with destinations and dates
- **Itinerary** - Day-by-day trip planning
- **Search** - Find trips and popular destinations
- **Chatbot** - AI travel assistant conversation
- **Profile** - User account management
- **Community** - Share and discover travel experiences

### Navigation Routes
```dart
'/login'              → LoginPage
'/signup'             → SignupPage
'/dashboard'          → DashboardPage
'/plan-trip'          → PlanTripPage
'/itinerary'          → ItenaryPage
'/search'             → SearchPage
'/chatbot'            → ChatBotScreen
'/user-profile'       → UserProfilePages
'/trip-list'          → UserTrippingListPage
```

## 🔌 API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login

### Trips
- `GET /api/trips/` - List all trips (filtered by user)
- `POST /api/trips/` - Create new trip
- `GET /api/trips/{id}/` - Get trip details
- `PUT /api/trips/{id}/` - Update trip
- `DELETE /api/trips/{id}/` - Delete trip

### Popular Cities
- `GET /api/cities/` - List popular destinations
- `GET /api/cities/{id}/` - Get city details

## 🗃️ Database Models

### Trip Model
```python
- id: UUID (Primary Key)
- user_id: String (Firebase UID)
- title: String
- destination: String
- start_date: Date
- end_date: Date
- image_url: URL
- status: String (Planned/Active/Completed)
- created_at: DateTime
- updated_at: DateTime
```

### PopularCity Model
```python
- id: Integer (Primary Key)
- name: String
- country: String
- image_url: URL
- rating: Decimal (0.0 - 5.0)
- reviews: Integer
- created_at: DateTime
- updated_at: DateTime
```

## 🧪 Testing

### Run Flutter Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Run Django Tests
```bash
cd travel_api
python manage.py test
```

## 📦 Dependencies

### Flutter Dependencies
```yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.8
  http: ^1.2.2
  firebase_core: ^3.8.1
  firebase_auth: ^5.3.4
  intl: ^0.18.0
```

### Django Dependencies
```
Django==5.1.4
djangorestframework==3.15.2
psycopg2-binary==2.9.11
python-dotenv==1.0.1
django-cors-headers==4.4.0
```

## 🚢 Deployment

### Flutter (Mobile)

#### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

#### iOS
```bash
# Build for App Store
flutter build ios --release
```

### Django API

#### Production Checklist
- [ ] Set `DEBUG = False`
- [ ] Configure allowed hosts
- [ ] Set up production database (PostgreSQL)
- [ ] Configure static files serving
- [ ] Set up HTTPS/SSL
- [ ] Configure CORS properly
- [ ] Set up environment variables
- [ ] Enable Django security settings

#### Deployment Options
- **Heroku**: Easy deployment with PostgreSQL addon
- **AWS EC2**: Full control over server configuration
- **DigitalOcean App Platform**: Simplified PaaS deployment
- **Google Cloud Run**: Containerized serverless deployment

## 🔒 Security

- Firebase Authentication for secure user management
- JWT token-based API authentication (recommended for production)
- CORS configuration for API security
- Environment variables for sensitive data
- HTTPS enforcement in production
- Input validation on both client and server

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Coding Standards
- Follow Flutter style guide for Dart code
- Use PEP 8 for Python code
- Write meaningful commit messages
- Add tests for new features
- Update documentation as needed

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Authors

- Your Team Name - Initial work

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for authentication services
- Google Gemini for AI capabilities
- Django REST framework for backend API
- Material Design team for UI components

## 📞 Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Email: support@globaltrotter.com
- Documentation: [Wiki](./docs)

## 🗺️ Roadmap

### Version 1.1 (Coming Soon)
- [ ] Dark mode support
- [ ] Offline mode with local caching
- [ ] Push notifications for trip reminders
- [ ] Social sharing features
- [ ] Multi-language support

### Version 1.2
- [ ] Trip collaboration (invite friends)
- [ ] Budget tracking and expense management
- [ ] Weather integration
- [ ] Flight and hotel booking integration
- [ ] Map view with markers

### Version 2.0
- [ ] AR features for destination exploration
- [ ] Voice-based AI assistant
- [ ] Travel blog publishing
- [ ] Gamification and achievements
- [ ] Premium subscription features

---

<div align="center">

**Made with ❤️ by the GlobalTrotter Team**

[Website](https://globaltrotter.com) • [Documentation](./docs) • [Report Bug](issues) • [Request Feature](issues)

</div>
