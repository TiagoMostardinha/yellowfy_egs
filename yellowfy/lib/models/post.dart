import "dart:convert";

List<Announcement> postFromJson(String str) => List<Announcement>.from(
    json.decode(str).map((x) => Announcement.fromJson(x)));

String postToJson(List<Announcement> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Announcement {
  final String name;
  final String job;
  final String imagePath;
  final String contactInfo;

  Announcement({
    required this.name,
    required this.job,
    required this.imagePath,
    required this.contactInfo,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      name: json['name'],
      job: json['job'],
      imagePath: json['imagePath'],
      contactInfo: json['contactInfo'],
    );
  }
}
