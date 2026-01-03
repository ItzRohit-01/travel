class Trip {
  final String id;
  final String userId;
  final String title;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;
  final String status;

  Trip({
    required this.id,
    required this.userId,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.status,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      title: json['title'] ?? '',
      destination: json['destination'] ?? '',
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date'] ?? '') ?? DateTime.now(),
      imageUrl: json['image_url'] ?? '',
      status: json['status'] ?? 'Planned',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'destination': destination,
      'start_date': startDate.toIso8601String().split('T').first,
      'end_date': endDate.toIso8601String().split('T').first,
      'image_url': imageUrl,
      'status': status,
    };
  }
}

class PopularCity {
  final int id;
  final String name;
  final String country;
  final String imageUrl;
  final double rating;
  final int reviews;

  PopularCity({
    required this.id,
    required this.name,
    required this.country,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
  });

  factory PopularCity.fromJson(Map<String, dynamic> json) {
    return PopularCity(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id'] ?? 0}') ?? 0,
      name: json['name'] ?? '',
      country: json['country'] ?? '',
        imageUrl: json['image_url'] ?? '',
      rating: double.tryParse('${json['rating'] ?? 0}') ?? 0,
      reviews: json['reviews'] is int
          ? json['reviews']
          : int.tryParse('${json['reviews'] ?? 0}') ?? 0,
    );
  }
}
