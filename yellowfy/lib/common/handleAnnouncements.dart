import 'package:yellowfy/models/announcements.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class handleAnnouncements {
  Future<List<Announcement>> handleGetAnnouncements() async {
    final response = await http.get(Uri.parse('http://172.24.24.1:8080/v0/'));
    if (response.statusCode == 200) {
      List<Announcement> announcements = [];
      var data = jsonDecode(response.body);
      for (var i in data) {
        announcements.add(Announcement(
          id: i['id'],
          userId: i['userID'],
          category: i['category'],
          description: i['description'],
          coordinates: Coordinate(
            latitude: i['location']['lat'],
            longitude: i['location']['long'],
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
