import 'package:yellowfy/models/announcements.dart';
import 'package:yellowfy/models/appointment.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class Handlers {
  /*
  * Announcements
  */
  Future<List<Announcement>> handleGetAnnouncements() async {
    String url = dotenv.get("URL", fallback: "");
    String port = dotenv.get("PORT_ANNOUNCEMENTS", fallback: "");
    final response = await http.get(Uri.parse("http://$url:$port/v0/"));
    if (response.statusCode == 200) {
      List<Announcement> announcements = [];
      var data = jsonDecode(response.body);
      print(data);
      for (var i in data) {
        var id = i['Id'] ?? '';
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
      return announcements;
    } else {
      throw Exception('Failed to load announcements: ${response.statusCode}');
    }
  }

  Future<Announcement> handleGetAnnouncementsById(String id) async {
    String url = dotenv.get("URL", fallback: "");
    String port = dotenv.get("PORT_ANNOUNCEMENTS", fallback: "");
    final response = await http.get(Uri.parse("http://$url:$port/v0/$id"));
    if (response.statusCode == 200) {
      Announcement announcement;
      var data = jsonDecode(response.body);

      announcement = Announcement(
        id: data['Id'] ?? '',
        userId: data['userID'] ?? '',
        category: data['category'] ?? '',
        description: data['description'] ?? '',
        coordinates: Coordinate(
          latitude: double.tryParse(data['latitude'] ?? '') ?? 0.0,
          longitude: double.tryParse(data['longitude'] ?? '') ?? 0.0,
        ),
      );
      return announcement;
    } else {
      throw Exception('Failed to load announcements: ${response.statusCode}');
    }
  }

  /*
  * Appointements
  */
  Future<List<Appointment>> handleGetAppointments() async {
    String url = dotenv.get("URL", fallback: "");
    String port = dotenv.get("PORT_APPOITMENTS", fallback: "");
    final response = await http.get(Uri.parse("http://$url:$port/"));
    if (response.statusCode == 200) {
      List<Appointment> appointments = [];
      var data = jsonDecode(response.body);
      print(data);
      for (var i in data) {
        appointments.add(Appointment(
          i['id'] ?? '',
          i['announcement_id'] ?? '',
          i['service'] ?? '',
          i['date_time'] ?? '',
          i['client_id'] ?? '',
          i['client_name'] ?? '',
          i['contractor_name'] ?? '',
          i['contractor_contact'] ?? '',
          i['contractor_id'] ?? '',
          i['details'] ?? '',
        ));
      }
      return appointments;
    } else {
      throw Exception('Failed to load appointments: ${response.statusCode}');
    }
  }

  /*
  * Authentication
  */
}
