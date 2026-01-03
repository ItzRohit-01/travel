# Architecture Overview

## System Architecture

GlobalTrotter follows a client-server architecture with a Flutter mobile frontend and Django REST API backend.

```
┌─────────────────────────────────────────────────────────────────┐
│                        Mobile Client (Flutter)                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │  UI Layer    │  │   Services   │  │  State Management    │  │
│  │  (Screens)   │→ │   (API)      │→ │   (setState)         │  │
│  └──────────────┘  └──────────────┘  └──────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              ↓ HTTP/HTTPS
┌─────────────────────────────────────────────────────────────────┐
│                    Firebase Authentication                       │
│                     (User Management)                            │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                   Django REST API Backend                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │   Views      │  │  Serializers │  │      Models          │  │
│  │  (Endpoints) │→ │   (Data)     │→ │   (Database)         │  │
│  └──────────────┘  └──────────────┘  └──────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                      PostgreSQL Database                         │
│              (Trips, Cities, User Data)                          │
└─────────────────────────────────────────────────────────────────┘

                              ↔
┌─────────────────────────────────────────────────────────────────┐
│                    External AI Services                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │ Google Gemini│  │   OpenAI     │  │  Fallback System     │  │
│  └──────────────┘  └──────────────┘  └──────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Frontend Architecture (Flutter)

### Layered Architecture

```
┌───────────────────────────────────────────────────────┐
│                  Presentation Layer                    │
│                   (UI Screens)                         │
│  • login_page.dart                                    │
│  • dashboard_page.dart                                │
│  • chatbot_screen.dart                                │
│  • plan_trip_page.dart                                │
└───────────────────────────────────────────────────────┘
                        ↓
┌───────────────────────────────────────────────────────┐
│                  Business Logic Layer                  │
│                    (Services)                          │
│  • auth_service.dart      → Firebase Auth             │
│  • trip_service.dart      → REST API calls            │
│  • ai_chat_service.dart   → AI provider management    │
└───────────────────────────────────────────────────────┘
                        ↓
┌───────────────────────────────────────────────────────┐
│                    Data Layer                          │
│                 (Models & API)                         │
│  • Trip model                                         │
│  • User model                                         │
│  • HTTP client                                        │
└───────────────────────────────────────────────────────┘
```

### Key Design Patterns

#### 1. Service Pattern
Services encapsulate business logic and API interactions:

```dart
class TripService {
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Single responsibility: Trip CRUD operations
  Future<List<Trip>> getTrips(String userId) async {}
  Future<Trip> createTrip(Trip trip) async {}
  Future<Trip> updateTrip(String id, Trip trip) async {}
  Future<void> deleteTrip(String id) async {}
}
```

**Benefits:**
- Separation of concerns
- Reusable across multiple screens
- Easy to test and mock
- Centralized error handling

#### 2. Repository Pattern (AI Service)
Multi-provider abstraction for AI services:

```dart
enum AIProvider { fallback, gemini, openai }

class AIChatService {
  final AIProvider provider;
  final String apiKey;
  
  Future<String> sendMessage(String message, List context) async {
    switch (provider) {
      case AIProvider.gemini:
        return _sendGeminiRequest(message, context);
      case AIProvider.openai:
        return _sendOpenAIRequest(message, context);
      case AIProvider.fallback:
        return _handleFallback(message, context);
    }
  }
}
```

**Benefits:**
- Easy to swap AI providers
- Graceful fallback mechanism
- Consistent interface
- Configuration flexibility

#### 3. Stateful Widget Pattern
State management using StatefulWidget:

```dart
class ChatBotScreen extends StatefulWidget {
  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  
  void _sendMessage(String text) {
    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _isTyping = true;
    });
    
    // Process message...
    
    setState(() {
      _isTyping = false;
    });
  }
}
```

**Benefits:**
- Simple and effective for small/medium apps
- Built into Flutter framework
- Easy to understand
- Good performance with proper optimization

---

## Backend Architecture (Django)

### MVT Architecture

Django follows the Model-View-Template (MVT) pattern, adapted for REST API:

```
┌───────────────────────────────────────────────────────┐
│                   API Layer (Views)                    │
│                                                        │
│  • TripViewSet        → CRUD for trips                │
│  • CityViewSet        → Popular cities                │
│  • AuthViewSet        → User authentication           │
└───────────────────────────────────────────────────────┘
                        ↓
┌───────────────────────────────────────────────────────┐
│              Serialization Layer                       │
│                                                        │
│  • TripSerializer     → Trip data conversion          │
│  • CitySerializer     → City data conversion          │
│  • UserSerializer     → User data conversion          │
└───────────────────────────────────────────────────────┘
                        ↓
┌───────────────────────────────────────────────────────┐
│                  Business Logic Layer                  │
│                    (Models)                            │
│  • Trip model         → Trip data & methods           │
│  • PopularCity model  → City data & methods           │
└───────────────────────────────────────────────────────┘
                        ↓
┌───────────────────────────────────────────────────────┐
│                    Data Layer                          │
│                 (PostgreSQL/SQLite)                    │
│  • trips_trip table                                   │
│  • trips_popularcity table                            │
└───────────────────────────────────────────────────────┘
```

### Key Components

#### 1. Models (Data Layer)

```python
class Trip(models.Model):
    """Domain model representing a travel trip."""
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4)
    user_id = models.CharField(max_length=128, db_index=True)
    title = models.CharField(max_length=255)
    destination = models.CharField(max_length=255)
    start_date = models.DateField()
    end_date = models.DateField()
    status = models.CharField(max_length=64, default="Planned")
    
    class Meta:
        ordering = ["-start_date"]
        indexes = [
            models.Index(fields=['user_id']),
            models.Index(fields=['status']),
        ]
    
    def duration_days(self):
        """Calculate trip duration in days."""
        return (self.end_date - self.start_date).days
```

**Design Principles:**
- Single responsibility (one model per entity)
- Database indexing for performance
- Business logic in model methods
- Validation at model level

#### 2. Serializers (Data Transformation)

```python
class TripSerializer(serializers.ModelSerializer):
    """Converts Trip model to/from JSON."""
    
    duration = serializers.SerializerMethodField()
    
    class Meta:
        model = Trip
        fields = '__all__'
    
    def get_duration(self, obj):
        return obj.duration_days()
    
    def validate_end_date(self, value):
        """Ensure end_date is after start_date."""
        if value < self.initial_data.get('start_date'):
            raise serializers.ValidationError(
                "End date must be after start date"
            )
        return value
```

**Responsibilities:**
- JSON serialization/deserialization
- Data validation
- Field customization
- Related data handling

#### 3. ViewSets (API Endpoints)

```python
class TripViewSet(viewsets.ModelViewSet):
    """REST API endpoints for Trip operations."""
    
    queryset = Trip.objects.all()
    serializer_class = TripSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        """Filter trips by authenticated user."""
        user_id = self.request.query_params.get('user_id')
        if user_id:
            return self.queryset.filter(user_id=user_id)
        return self.queryset
    
    @action(detail=True, methods=['post'])
    def complete(self, request, pk=None):
        """Custom action to mark trip as completed."""
        trip = self.get_object()
        trip.status = 'Completed'
        trip.save()
        return Response({'status': 'completed'})
```

**Features:**
- CRUD operations automatically generated
- Custom actions via @action decorator
- Built-in pagination
- Permission handling
- Query parameter filtering

---

## Data Flow

### 1. Trip Creation Flow

```
User Input (Flutter)
       ↓
[PlanTripPage]
  - Validate form
  - Create Trip object
       ↓
[TripService.createTrip()]
  - Prepare HTTP request
  - Add authentication headers
  - Send POST request
       ↓
Django API Server
       ↓
[TripViewSet.create()]
  - Authenticate user
  - Validate request data
       ↓
[TripSerializer]
  - Deserialize JSON
  - Validate fields
  - Check business rules
       ↓
[Trip Model]
  - Save to database
  - Generate UUID
  - Set timestamps
       ↓
PostgreSQL Database
       ↓
[TripSerializer]
  - Serialize saved trip
  - Add computed fields
       ↓
HTTP Response (JSON)
       ↓
[TripService]
  - Parse response
  - Convert to Trip object
  - Handle errors
       ↓
[PlanTripPage]
  - Update UI
  - Show success message
  - Navigate to dashboard
```

### 2. Chatbot Conversation Flow

```
User Message (Flutter)
       ↓
[ChatBotScreen]
  - Add message to UI
  - Show typing indicator
       ↓
[AIChatService.sendMessage()]
  - Select provider (Gemini/OpenAI/Fallback)
  - Build context from history
  - Add system prompt
       ↓
AI Provider API (or Fallback)
       ↓
[Provider-specific Request]
  - Format request for provider
  - Send HTTP request
  - Handle rate limits
       ↓
AI Response
       ↓
[AIChatService]
  - Parse response
  - Extract message text
  - Handle errors gracefully
       ↓
[ChatBotScreen]
  - Add AI message to UI
  - Hide typing indicator
  - Save to conversation history
  - Scroll to bottom
```

---

## Security Architecture

### 1. Authentication Flow

```
User Login Request
       ↓
[Firebase Authentication]
  - Verify email/password
  - Generate ID token (JWT)
  - Return user data
       ↓
Flutter App
  - Store token securely
  - Include in API requests
       ↓
Django API Request
  - Extract Authorization header
       ↓
[Authentication Middleware]
  - Verify Firebase token
  - Decode user information
  - Attach to request.user
       ↓
[ViewSet Permission Check]
  - Verify user has access
  - Check object-level permissions
       ↓
Process Request
```

### 2. Security Layers

**Layer 1: Network Security**
- HTTPS/TLS encryption
- CORS policy enforcement
- Rate limiting

**Layer 2: Authentication**
- Firebase JWT tokens
- Token expiration handling
- Secure token storage

**Layer 3: Authorization**
- Per-endpoint permissions
- Object-level permissions
- User data isolation

**Layer 4: Data Validation**
- Input sanitization
- SQL injection prevention
- XSS protection

**Layer 5: Error Handling**
- No sensitive data in errors
- Generic error messages
- Detailed logging (server-side only)

---

## Scalability Considerations

### Horizontal Scaling

**Frontend:**
- Static Flutter web build can be served via CDN
- Mobile apps distributed through app stores
- No server-side state in Flutter

**Backend:**
- Stateless API design enables load balancing
- Database connection pooling
- Redis caching for frequently accessed data

### Database Optimization

**Indexing Strategy:**
```python
class Trip(models.Model):
    class Meta:
        indexes = [
            models.Index(fields=['user_id']),      # Filter by user
            models.Index(fields=['status']),        # Filter by status
            models.Index(fields=['-start_date']),  # Sort by date
        ]
```

**Query Optimization:**
```python
# Use select_related for foreign keys
trips = Trip.objects.select_related('user').all()

# Use prefetch_related for many-to-many
cities = City.objects.prefetch_related('reviews').all()

# Pagination to limit results
trips = Trip.objects.all()[:50]
```

### Caching Strategy

**Level 1: Application Cache (Redis)**
- Popular cities list
- User sessions
- API rate limiting

**Level 2: Database Query Cache**
- Frequently accessed trips
- User profile data

**Level 3: CDN Cache**
- Static assets
- Profile images
- City images

---

## Technology Stack Rationale

### Frontend: Flutter/Dart

**Why Flutter?**
- ✅ Single codebase for iOS, Android, Web
- ✅ Fast development with hot reload
- ✅ Beautiful Material Design components
- ✅ Excellent performance (AOT compilation)
- ✅ Growing ecosystem and community

**Alternatives Considered:**
- React Native: Chose Flutter for better performance
- Native (Swift/Kotlin): Chose Flutter to reduce development time

### Backend: Django REST Framework

**Why Django?**
- ✅ "Batteries included" framework
- ✅ Excellent ORM for database operations
- ✅ Built-in admin panel
- ✅ Django REST Framework for APIs
- ✅ Strong security defaults
- ✅ Mature ecosystem

**Alternatives Considered:**
- FastAPI: Chose Django for maturity and ORM
- Node.js/Express: Chose Django for rapid development
- Flask: Chose Django for built-in features

### Database: PostgreSQL

**Why PostgreSQL?**
- ✅ ACID compliance
- ✅ JSON field support
- ✅ Full-text search
- ✅ Geographic data support (future use)
- ✅ Excellent Django integration

**Alternatives Considered:**
- MongoDB: Chose PostgreSQL for relational data
- MySQL: Chose PostgreSQL for advanced features

### Authentication: Firebase

**Why Firebase Auth?**
- ✅ Easy integration with Flutter
- ✅ Multiple authentication methods
- ✅ Secure token management
- ✅ Free tier generous enough
- ✅ Email verification built-in

---

## Future Architecture Enhancements

### Phase 1: Performance Optimization
- Implement Redis caching
- Add CDN for static assets
- Database read replicas
- API response compression

### Phase 2: Advanced Features
- WebSocket for real-time updates
- Background job processing (Celery)
- Push notification service
- File upload service (S3)

### Phase 3: Microservices (if needed)
- Separate AI service
- Separate notification service
- API gateway pattern
- Service mesh

### Phase 4: Observability
- Distributed tracing
- Centralized logging (ELK stack)
- Application Performance Monitoring (APM)
- Real-time alerting

---

## Design Principles

### 1. Separation of Concerns
Each layer has a single, well-defined responsibility.

### 2. DRY (Don't Repeat Yourself)
Reusable services, components, and utilities.

### 3. SOLID Principles
- Single Responsibility
- Open/Closed
- Liskov Substitution
- Interface Segregation
- Dependency Inversion

### 4. RESTful API Design
Standard HTTP methods, status codes, and resource naming.

### 5. Security by Default
Authentication required, input validation, HTTPS enforced.

### 6. Fail Gracefully
Comprehensive error handling, fallback mechanisms, user-friendly messages.

---

## Related Documentation

- [Development Guide](DEVELOPMENT.md) - Setup and coding standards
- [API Documentation](API.md) - Endpoint specifications
- [Deployment Guide](DEPLOYMENT.md) - Production deployment
- [README](../README.md) - Project overview
