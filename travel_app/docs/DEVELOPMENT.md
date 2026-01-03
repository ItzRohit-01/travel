# Development Guide

## Table of Contents
1. [Environment Setup](#environment-setup)
2. [Project Structure](#project-structure)
3. [Coding Standards](#coding-standards)
4. [Development Workflow](#development-workflow)
5. [Testing](#testing)
6. [Debugging](#debugging)
7. [Common Issues](#common-issues)

---

## Environment Setup

### Flutter Development Environment

#### 1. Install Flutter SDK

**Windows:**
```powershell
# Download Flutter SDK
# Extract to C:\flutter
# Add to PATH: C:\flutter\bin

# Verify installation
flutter doctor
```

**macOS:**
```bash
# Using Homebrew
brew install --cask flutter

# Verify installation
flutter doctor
```

**Linux:**
```bash
# Download and extract Flutter SDK
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.x.x-stable.tar.xz
tar xf flutter_linux_3.x.x-stable.tar.xz

# Add to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

#### 2. Install IDE Extensions

**VS Code:**
- Flutter extension
- Dart extension
- Firebase extension (optional)

**Android Studio:**
- Flutter plugin
- Dart plugin

#### 3. Set up Android Development

```bash
# Install Android Studio
# Install Android SDK (API 21 or higher)
# Accept licenses
flutter doctor --android-licenses

# Configure emulator
flutter emulators --create
```

#### 4. Set up iOS Development (macOS only)

```bash
# Install Xcode from App Store
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch

# Install CocoaPods
sudo gem install cocoapods

# Verify setup
flutter doctor
```

---

### Django Backend Environment

#### 1. Install Python

```bash
# Windows (using Chocolatey)
choco install python

# macOS (using Homebrew)
brew install python@3.11

# Linux
sudo apt-get update
sudo apt-get install python3.11 python3-pip
```

#### 2. Set up Virtual Environment

```bash
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
```

#### 3. Database Setup

**PostgreSQL (Production-like):**
```bash
# Install PostgreSQL
# Windows: Download from postgresql.org
# macOS: brew install postgresql
# Linux: sudo apt-get install postgresql

# Create database
psql -U postgres
CREATE DATABASE travel_db;
CREATE USER travel_user WITH PASSWORD 'secure_password';
GRANT ALL PRIVILEGES ON DATABASE travel_db TO travel_user;
\q

# Update .env file
DATABASE_URL=postgresql://travel_user:secure_password@localhost:5432/travel_db
```

**SQLite (Development):**
```bash
# SQLite is built into Python - no installation needed
# Just run migrations
python manage.py migrate
```

---

## Project Structure

### Flutter Application Structure

```
lib/
├── main.dart                      # App entry point
│
├── models/                        # Data models
│   ├── trip.dart
│   ├── user.dart
│   └── city.dart
│
├── screens/                       # UI screens
│   ├── auth/
│   │   ├── login_page.dart
│   │   └── signup_page.dart
│   ├── dashboard/
│   │   └── dashboard_page.dart
│   ├── trips/
│   │   ├── plan_trip_page.dart
│   │   ├── itenary_page.dart
│   │   └── search_page.dart
│   └── chatbot/
│       └── chatbot_screen.dart
│
├── services/                      # Business logic
│   ├── auth_service.dart         # Authentication
│   ├── trip_service.dart         # Trip operations
│   └── ai_chat_service.dart      # AI chatbot
│
├── widgets/                       # Reusable components
│   ├── custom_button.dart
│   ├── trip_card.dart
│   └── loading_indicator.dart
│
└── utils/                         # Utilities
    ├── constants.dart
    ├── validators.dart
    └── helpers.dart
```

### Django Backend Structure

```
travel_api/
├── manage.py
├── requirements.txt
├── .env                          # Environment variables
│
├── travel_api/                   # Project configuration
│   ├── settings.py              # Django settings
│   ├── urls.py                  # Root URL config
│   └── wsgi.py                  # WSGI config
│
└── trips/                        # Trips app
    ├── models.py                # Data models
    ├── views.py                 # API views
    ├── serializers.py           # Data serialization
    ├── urls.py                  # App URLs
    ├── admin.py                 # Admin panel
    └── tests.py                 # Unit tests
```

---

## Coding Standards

### Dart/Flutter Standards

#### 1. File Naming
- Use lowercase with underscores: `trip_service.dart`
- Widget files match class name: `DashboardPage` → `dashboard_page.dart`

#### 2. Class Naming
```dart
// Classes: PascalCase
class TripService {}
class DashboardPage extends StatefulWidget {}

// Constants: lowerCamelCase with k prefix
const kPrimaryColor = Color(0xFF667EEA);
const kApiBaseUrl = 'http://localhost:8000/api';

// Variables: lowerCamelCase
String userName = 'John';
int tripCount = 5;
```

#### 3. Widget Structure
```dart
class MyWidget extends StatefulWidget {
  // 1. Constructor parameters (required first, then optional)
  const MyWidget({
    Key? key,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  // 2. Final properties
  final String title;
  final String? subtitle;

  // 3. createState
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // 1. State variables
  bool _isLoading = false;
  
  // 2. Lifecycle methods
  @override
  void initState() {
    super.initState();
  }
  
  // 3. Custom methods
  void _handleSubmit() {}
  
  // 4. Build method (last)
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

#### 4. Code Documentation
```dart
/// Authenticates user with Firebase.
///
/// Returns [User] object on success, throws [AuthException] on failure.
///
/// Example:
/// ```dart
/// final user = await authService.signIn('email@test.com', 'password');
/// ```
Future<User> signIn(String email, String password) async {
  // Implementation
}
```

---

### Python/Django Standards

#### 1. PEP 8 Compliance
```python
# Imports: standard library, third-party, local
import os
import sys

from django.db import models
from rest_framework import serializers

from .utils import helper_function

# Class naming: PascalCase
class TripSerializer(serializers.ModelSerializer):
    pass

# Function naming: snake_case
def get_user_trips(user_id):
    pass

# Constants: UPPER_CASE
API_VERSION = 'v1'
MAX_TRIPS_PER_USER = 100
```

#### 2. Django Model Standards
```python
class Trip(models.Model):
    """Represents a user's travel trip."""
    
    # 1. Database fields
    id = models.UUIDField(primary_key=True, default=uuid.uuid4)
    title = models.CharField(max_length=255)
    
    # 2. Meta class
    class Meta:
        ordering = ['-created_at']
        verbose_name = 'Trip'
        verbose_name_plural = 'Trips'
    
    # 3. String representation
    def __str__(self):
        return self.title
    
    # 4. Custom methods
    def is_active(self):
        return self.status == 'Active'
```

#### 3. API View Standards
```python
from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

class TripViewSet(viewsets.ModelViewSet):
    """
    API endpoint for trip management.
    
    list: Get all trips for user
    create: Create a new trip
    retrieve: Get trip details
    update: Update trip
    destroy: Delete trip
    """
    
    queryset = Trip.objects.all()
    serializer_class = TripSerializer
    
    def get_queryset(self):
        """Filter trips by authenticated user."""
        return self.queryset.filter(user_id=self.request.user.uid)
    
    @action(detail=True, methods=['post'])
    def complete(self, request, pk=None):
        """Mark trip as completed."""
        trip = self.get_object()
        trip.status = 'Completed'
        trip.save()
        return Response({'status': 'completed'})
```

---

## Development Workflow

### 1. Starting Development

```bash
# Terminal 1: Start Django backend
cd travel_api
source venv/bin/activate  # or venv\Scripts\activate on Windows
python manage.py runserver

# Terminal 2: Start Flutter app
cd ..
flutter run

# Terminal 3: Watch for changes (optional)
flutter pub run build_runner watch
```

### 2. Feature Development Workflow

```bash
# 1. Create feature branch
git checkout -b feature/new-feature

# 2. Make changes
# - Write code
# - Add tests
# - Update documentation

# 3. Test changes
flutter test
cd travel_api && python manage.py test

# 4. Commit changes
git add .
git commit -m "feat: Add new feature description"

# 5. Push and create PR
git push origin feature/new-feature
```

### 3. Commit Message Format

Follow conventional commits:
```
feat: Add trip sharing feature
fix: Resolve login authentication bug
docs: Update API documentation
style: Format code with dartfmt
refactor: Simplify trip service logic
test: Add unit tests for auth service
chore: Update dependencies
```

---

## Testing

### Flutter Testing

#### 1. Unit Tests
```dart
// test/services/auth_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/services/auth_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;
    
    setUp(() {
      authService = AuthService();
    });
    
    test('validates email format', () {
      expect(authService.isValidEmail('test@example.com'), true);
      expect(authService.isValidEmail('invalid-email'), false);
    });
    
    test('validates password strength', () {
      expect(authService.isStrongPassword('Pass123!'), true);
      expect(authService.isStrongPassword('weak'), false);
    });
  });
}
```

#### 2. Widget Tests
```dart
// test/screens/login_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_app/screens/login_page.dart';

void main() {
  testWidgets('Login page displays email and password fields', 
    (WidgetTester tester) async {
    
    await tester.pumpWidget(MaterialApp(home: LoginPage()));
    
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
```

#### 3. Run Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/auth_service_test.dart

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

### Django Testing

#### 1. Model Tests
```python
# trips/tests/test_models.py
from django.test import TestCase
from trips.models import Trip
from datetime import date

class TripModelTest(TestCase):
    def setUp(self):
        self.trip = Trip.objects.create(
            user_id='test-user-123',
            title='Test Trip',
            destination='Paris',
            start_date=date(2026, 7, 1),
            end_date=date(2026, 7, 10),
        )
    
    def test_trip_creation(self):
        self.assertEqual(self.trip.title, 'Test Trip')
        self.assertEqual(self.trip.status, 'Planned')
    
    def test_trip_string_representation(self):
        expected = 'Test Trip (Paris)'
        self.assertEqual(str(self.trip), expected)
```

#### 2. API Tests
```python
# trips/tests/test_api.py
from rest_framework.test import APITestCase
from rest_framework import status
from trips.models import Trip

class TripAPITest(APITestCase):
    def setUp(self):
        self.trip_data = {
            'user_id': 'test-user-123',
            'title': 'Paris Trip',
            'destination': 'Paris, France',
            'start_date': '2026-07-01',
            'end_date': '2026-07-10',
        }
    
    def test_create_trip(self):
        response = self.client.post('/api/trips/', self.trip_data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Trip.objects.count(), 1)
    
    def test_list_trips(self):
        Trip.objects.create(**self.trip_data)
        response = self.client.get('/api/trips/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
```

#### 3. Run Tests
```bash
# Run all tests
python manage.py test

# Run specific app tests
python manage.py test trips

# Run with coverage
pip install coverage
coverage run --source='.' manage.py test
coverage report
coverage html  # Generate HTML report
```

---

## Debugging

### Flutter Debugging

#### 1. Print Debugging
```dart
print('User ID: ${user.id}');
debugPrint('Loading trips...'); // Handles large outputs better

// Pretty print objects
import 'dart:developer' as developer;
developer.log('Trip data', name: 'TripService', error: tripData);
```

#### 2. Debugger
```dart
import 'dart:developer';

void fetchTrips() async {
  debugger(); // Pause execution here
  final trips = await tripService.getTrips();
}
```

#### 3. Flutter DevTools
```bash
# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools

# Run app with DevTools
flutter run --observatory-port=9100
```

---

### Django Debugging

#### 1. Print Debugging
```python
print(f"User ID: {user_id}")
import pdb; pdb.set_trace()  # Breakpoint
```

#### 2. Django Debug Toolbar
```python
# Install
pip install django-debug-toolbar

# Add to settings.py
INSTALLED_APPS += ['debug_toolbar']
MIDDLEWARE += ['debug_toolbar.middleware.DebugToolbarMiddleware']
INTERNAL_IPS = ['127.0.0.1']
```

#### 3. Logging
```python
import logging
logger = logging.getLogger(__name__)

def get_trips(user_id):
    logger.info(f'Fetching trips for user: {user_id}')
    logger.error(f'Error occurred: {error}')
```

---

## Common Issues

### Flutter Issues

#### 1. Gradle Build Failures
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

#### 2. iOS Build Failures
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter run
```

#### 3. Package Conflicts
```bash
flutter pub cache repair
flutter pub get
```

---

### Django Issues

#### 1. Migration Conflicts
```bash
# Reset migrations
python manage.py migrate --fake trips zero
python manage.py migrate trips

# Or delete db and migrations
rm db.sqlite3
rm trips/migrations/00*.py
python manage.py makemigrations
python manage.py migrate
```

#### 2. CORS Issues
```python
# settings.py
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
]
CORS_ALLOW_CREDENTIALS = True
```

---

## Performance Tips

### Flutter Performance

1. **Use const widgets** where possible
2. **Avoid rebuilding entire widget tree**
3. **Use ListView.builder** for long lists
4. **Implement pagination** for large datasets
5. **Cache network images**
6. **Profile with DevTools**

### Django Performance

1. **Use select_related/prefetch_related** for queries
2. **Add database indexes** on frequently queried fields
3. **Implement caching** with Redis
4. **Use pagination** for list endpoints
5. **Optimize serializers** to avoid N+1 queries
6. **Profile with Django Debug Toolbar**

---

## Next Steps

- Review [API Documentation](API.md)
- Check [Deployment Guide](DEPLOYMENT.md)
- Read [Architecture Overview](ARCHITECTURE.md)
- Contribute via [Contributing Guidelines](../CONTRIBUTING.md)
