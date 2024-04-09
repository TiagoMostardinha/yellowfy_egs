import 'package:yellowfy/models/announcements.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class handleAnnouncements {
  Future<List<Announcement>> handleGetAnnouncements() async {
    final response = await http.get(Uri.parse("http://10.0.2.2:8080/v0/"));
    if (response.statusCode == 200) {
      List<Announcement> announcements = [];
      var data = jsonDecode(response.body);
      print(data);
      for (var i in data) {
        print("HEY");
        var id = i['id'] ?? '';
        var userId = i['userID'] ?? '';
        var category = i['category'] ?? '';
        var description = i['description'] ?? '';
        var latitude = double.tryParse(i['latitude'] ?? '') ?? 0.0;
        var longitude = double.tryParse(i['longitude'] ?? '') ?? 0.0;

        announcements.add(Announcement(
          id: id,
          userId: userId,
          category: category,
          description: description,
          coordinates: Coordinate(
            latitude: latitude,
            longitude: longitude,
          ),
        ));
      }
      for (var i in announcements) {
        print(i.userId);
      }
      return announcements;
    } else {
      throw Exception('Failed to load announcements: ${response.statusCode}');
    }
  }
}
