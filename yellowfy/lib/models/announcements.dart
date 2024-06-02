class Coordinate {
  final double latitude;
  final double longitude;
  Coordinate({required this.latitude, required this.longitude});
}

class Announcement {
  final String id;
  final String userId;
  final String category;
  final String description;
  final Coordinate coordinates;
  final String name;
  Announcement({
    required this.id,
    required this.userId,
    required this.category,
    required this.description,
    required this.coordinates,
    required this.name,
  });
}
