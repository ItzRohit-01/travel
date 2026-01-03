# API Documentation

## Base URL
```
Development: http://localhost:8000/api
Production: https://your-domain.com/api
```

## Authentication

All authenticated endpoints require a Firebase ID token in the Authorization header:
```
Authorization: Bearer <firebase-id-token>
```

---

## Endpoints

### 1. Authentication

#### Register User
```http
POST /api/auth/register
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securePassword123",
  "displayName": "John Doe"
}
```

**Response (201 Created):**
```json
{
  "uid": "firebase-user-id",
  "email": "user@example.com",
  "displayName": "John Doe",
  "token": "firebase-id-token"
}
```

**Errors:**
- `400 Bad Request` - Invalid email or weak password
- `409 Conflict` - Email already exists

---

#### Login User
```http
POST /api/auth/login
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

**Response (200 OK):**
```json
{
  "uid": "firebase-user-id",
  "email": "user@example.com",
  "displayName": "John Doe",
  "token": "firebase-id-token"
}
```

**Errors:**
- `400 Bad Request` - Missing credentials
- `401 Unauthorized` - Invalid credentials

---

### 2. Trips

#### List All Trips
```http
GET /api/trips/
```

**Query Parameters:**
- `user_id` (optional) - Filter by user ID
- `status` (optional) - Filter by status (Planned, Active, Completed)
- `destination` (optional) - Search by destination

**Response (200 OK):**
```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "user_id": "firebase-user-id",
    "title": "Summer Vacation in Paris",
    "destination": "Paris, France",
    "start_date": "2026-07-15",
    "end_date": "2026-07-22",
    "image_url": "https://example.com/paris.jpg",
    "status": "Planned",
    "created_at": "2026-01-03T10:30:00Z",
    "updated_at": "2026-01-03T10:30:00Z"
  }
]
```

---

#### Create Trip
```http
POST /api/trips/
```

**Request Body:**
```json
{
  "user_id": "firebase-user-id",
  "title": "Summer Vacation in Paris",
  "destination": "Paris, France",
  "start_date": "2026-07-15",
  "end_date": "2026-07-22",
  "image_url": "https://example.com/paris.jpg",
  "status": "Planned"
}
```

**Response (201 Created):**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "user_id": "firebase-user-id",
  "title": "Summer Vacation in Paris",
  "destination": "Paris, France",
  "start_date": "2026-07-15",
  "end_date": "2026-07-22",
  "image_url": "https://example.com/paris.jpg",
  "status": "Planned",
  "created_at": "2026-01-03T10:30:00Z",
  "updated_at": "2026-01-03T10:30:00Z"
}
```

**Errors:**
- `400 Bad Request` - Invalid data or missing required fields
- `401 Unauthorized` - Not authenticated

---

#### Get Trip Details
```http
GET /api/trips/{trip_id}/
```

**Response (200 OK):**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "user_id": "firebase-user-id",
  "title": "Summer Vacation in Paris",
  "destination": "Paris, France",
  "start_date": "2026-07-15",
  "end_date": "2026-07-22",
  "image_url": "https://example.com/paris.jpg",
  "status": "Planned",
  "created_at": "2026-01-03T10:30:00Z",
  "updated_at": "2026-01-03T10:30:00Z"
}
```

**Errors:**
- `404 Not Found` - Trip does not exist

---

#### Update Trip
```http
PUT /api/trips/{trip_id}/
```

**Request Body:**
```json
{
  "title": "Updated Trip Title",
  "destination": "Paris, France",
  "start_date": "2026-07-20",
  "end_date": "2026-07-27",
  "status": "Active"
}
```

**Response (200 OK):**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "user_id": "firebase-user-id",
  "title": "Updated Trip Title",
  "destination": "Paris, France",
  "start_date": "2026-07-20",
  "end_date": "2026-07-27",
  "image_url": "https://example.com/paris.jpg",
  "status": "Active",
  "created_at": "2026-01-03T10:30:00Z",
  "updated_at": "2026-01-03T15:45:00Z"
}
```

**Errors:**
- `400 Bad Request` - Invalid data
- `404 Not Found` - Trip does not exist
- `403 Forbidden` - Not authorized to update this trip

---

#### Delete Trip
```http
DELETE /api/trips/{trip_id}/
```

**Response (204 No Content)**

**Errors:**
- `404 Not Found` - Trip does not exist
- `403 Forbidden` - Not authorized to delete this trip

---

### 3. Popular Cities

#### List Popular Cities
```http
GET /api/cities/
```

**Query Parameters:**
- `country` (optional) - Filter by country
- `min_rating` (optional) - Minimum rating filter (0.0 - 5.0)

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "name": "Paris",
    "country": "France",
    "image_url": "https://example.com/paris.jpg",
    "rating": 4.8,
    "reviews": 15234,
    "created_at": "2026-01-01T00:00:00Z",
    "updated_at": "2026-01-01T00:00:00Z"
  },
  {
    "id": 2,
    "name": "Tokyo",
    "country": "Japan",
    "image_url": "https://example.com/tokyo.jpg",
    "rating": 4.9,
    "reviews": 18567,
    "created_at": "2026-01-01T00:00:00Z",
    "updated_at": "2026-01-01T00:00:00Z"
  }
]
```

---

#### Get City Details
```http
GET /api/cities/{city_id}/
```

**Response (200 OK):**
```json
{
  "id": 1,
  "name": "Paris",
  "country": "France",
  "image_url": "https://example.com/paris.jpg",
  "rating": 4.8,
  "reviews": 15234,
  "created_at": "2026-01-01T00:00:00Z",
  "updated_at": "2026-01-01T00:00:00Z"
}
```

**Errors:**
- `404 Not Found` - City does not exist

---

## Error Responses

All error responses follow this format:

```json
{
  "error": "Error message describing what went wrong",
  "code": "ERROR_CODE",
  "details": {
    "field": ["Field-specific error message"]
  }
}
```

### Common Error Codes

| Status Code | Description |
|-------------|-------------|
| 400 | Bad Request - Invalid input data |
| 401 | Unauthorized - Authentication required |
| 403 | Forbidden - Insufficient permissions |
| 404 | Not Found - Resource does not exist |
| 409 | Conflict - Resource already exists |
| 500 | Internal Server Error |

---

## Rate Limiting

API requests are limited to:
- **Unauthenticated**: 100 requests per hour
- **Authenticated**: 1000 requests per hour

Rate limit headers are included in all responses:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 995
X-RateLimit-Reset: 1640000000
```

---

## CORS

The API supports CORS for the following origins:
- `http://localhost:*` (Development)
- `https://your-domain.com` (Production)

Allowed methods: GET, POST, PUT, DELETE, OPTIONS

---

## Testing the API

### Using cURL

```bash
# Create a trip
curl -X POST http://localhost:8000/api/trips/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer your-firebase-token" \
  -d '{
    "user_id": "firebase-user-id",
    "title": "Trip to Tokyo",
    "destination": "Tokyo, Japan",
    "start_date": "2026-08-01",
    "end_date": "2026-08-10",
    "status": "Planned"
  }'

# Get all trips
curl -X GET "http://localhost:8000/api/trips/?user_id=firebase-user-id" \
  -H "Authorization: Bearer your-firebase-token"
```

### Using Postman

1. Import the Postman collection (coming soon)
2. Set environment variables:
   - `base_url`: http://localhost:8000/api
   - `firebase_token`: Your Firebase ID token
3. Run requests from the collection

---

## Changelog

### Version 1.0.0 (2026-01-03)
- Initial API release
- Trip CRUD operations
- Popular cities endpoint
- Firebase authentication integration
- Basic filtering and search capabilities
