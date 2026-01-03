class Trip {
  final String id;
  final String title;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String image;
  final String status;

  Trip({
    required this.id,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.image,
    required this.status,
  });
}

class PopularCity {
  final String name;
  final String country;
  final String image;
  final double rating;
  final int reviews;

  PopularCity({
    required this.name,
    required this.country,
    required this.image,
    required this.rating,
    required this.reviews,
  });
}
