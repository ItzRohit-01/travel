import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../models/trip_model.dart';

class TripService {
  TripService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  // Override at build time with: flutter run --dart-define=TRAVEL_API_BASE_URL=http://localhost:8000/api
  static const String _envBaseUrl = String.fromEnvironment(
    'TRAVEL_API_BASE_URL',
    defaultValue: '',
  );

  static String get _baseUrl {
    if (_envBaseUrl.isNotEmpty) return _envBaseUrl;
    return kIsWeb ? 'http://localhost:8000/api' : 'http://10.0.2.2:8000/api';
  }

  Uri _uri(String path, [Map<String, String>? queryParameters]) {
    return Uri.parse('$_baseUrl$path').replace(queryParameters: queryParameters);
  }

  Future<List<Trip>> fetchTrips(String userId) async {
    final response = await _client.get(
      _uri('/trips/', {'userId': userId}),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load trips (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded.map((item) => Trip.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<List<PopularCity>> fetchPopularCities() async {
    final response = await _client.get(
      _uri('/popular-cities/'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load popular cities (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => PopularCity.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Trip> createTrip({
    required String userId,
    required String title,
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    String imageUrl = '',
    String status = 'Planned',
  }) async {
    final payload = {
      'user_id': userId,
      'title': title,
      'destination': destination,
      'start_date': startDate.toIso8601String().split('T').first,
      'end_date': endDate.toIso8601String().split('T').first,
      'image_url': imageUrl,
      'status': status,
    };

    final response = await _client.post(
      _uri('/trips/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create trip (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return Trip.fromJson(decoded);
  }
}
