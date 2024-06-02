import 'package:yellowfy/models/announcements.dart';
import 'package:yellowfy/models/appointment.dart';
import 'package:yellowfy/models/authentication.dart';
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
    final response = await http.get(Uri.parse("http://$url/announcements/v1"));
    if (response.statusCode == 200) {
      List<Announcement> announcements = [];
      var data = jsonDecode(response.body);
      if (data == null) return announcements;
      for (var i in data) {
        var id = i['Id'] ?? '';
        var userId = i['userID'] ?? '';
        var category = i['category'] ?? '';
        var description = i['description'] ?? '';
        var name = i['name'] ?? '';
        var latitude = ((i['location']['lat'].toDouble()) ?? '') ?? 0.0;
        var longitude = (((i['location']['long'].toDouble()) ?? '') ?? 0.0);

        announcements.add(Announcement(
          id: id,
          userId: userId,
          category: category,
          description: description,
          name: name,
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

  Future<Announcement> handleGetAnnouncementsByUserId(String userId) async {
    String url = dotenv.get("URL", fallback: "");
    String port = dotenv.get("PORT_ANNOUNCEMENTS", fallback: "");
    final response =
        await http.get(Uri.parse("http://$url/announcements/v1/$userId"));
    if (response.statusCode == 200) {
      Announcement announcement;
      var data = jsonDecode(response.body);

      announcement = Announcement(
        id: data['Id'] ?? '',
        userId: data['userID'] ?? '',
        category: data['category'] ?? '',
        description: data['description'] ?? '',
        name: data['name'] ?? '',
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

  Future<List<Announcement>> handleGetAnnouncementsByGPS(
      double radius, double lat, double long) async {
    String url = dotenv.get("URL", fallback: "");
    String port = dotenv.get("PORT_ANNOUNCEMENTS", fallback: "");
    final response = await http.get(Uri.parse(
        "http://$url/announcements/v1/?radius=$radius&lat=$lat&long=$long"));
    if (response.statusCode == 200) {
      List<Announcement> announcements = [];
      var data = jsonDecode(response.body);
      if (data == null) return announcements;
      for (var i in data) {
        var id = i['Id'] ?? '';
        var userId = i['userID'] ?? '';
        var category = i['category'] ?? '';
        var name = i['name'] ?? '';
        var description = i['description'] ?? '';
        var latitude = ((i['location']['lat'].toDouble()) ?? '') ?? 0.0;
        var longitude = (((i['location']['long'].toDouble()) ?? '') ?? 0.0);

        announcements.add(Announcement(
          id: id,
          userId: userId,
          category: category,
          name: name,
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

  Future<void> handlePostAnnouncement(Announcement announcement) async {
    String url = dotenv.get("URL", fallback: "");
    String port = dotenv.get("PORT_ANNOUNCEMENTS", fallback: "");
    final response = await http.post(
      Uri.parse("http://$url/announcements/v1/"),
      body: jsonEncode(<String, dynamic>{
        'userID': announcement.userId,
        'name': announcement.name,
        'category': announcement.category,
        'description': announcement.description,
        'location': {
          'lat': announcement.coordinates.latitude,
          'long': announcement.coordinates.longitude,
        }
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to post announcement: ${response.statusCode}');
    }
  }

  /*
  * Appointements
  */

  // get appointments by contractor id

  Future<List<Appointment>> handleGetAvailableHours(
      int contractor_id, String date_time) async {
    String url = dotenv.get("URL", fallback: "");
    final response = await http.get(Uri.parse(
        "http://$url/booking/appointments/available_hours/$contractor_id/$date_time"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      // Check if data is empty
      if (data == null || data.isEmpty) {
        return []; // Return an empty list if no appointments are available
      }

      // Assuming the response is a list of appointments
      List<Appointment> appointments = (data as List)
          .map((item) => Appointment(
                item['date_time'] ?? '',
                item['client_id'] ?? '',
                item['contractor_id'] ?? '',
              ))
          .toList();

      return appointments;
    } else {
      // Log error details for debugging
      print('Failed to load available hours: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Handle different status codes
      if (response.statusCode == 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception(
            'Failed to load available hours: ${response.statusCode}');
      }
    }
  }

  Future<void> handlePostAppointment(Appointment appointment) async {
    String url = dotenv.get("URL", fallback: "");
    String port = dotenv.get("PORT_APPOITMENTS", fallback: "");
    final response = await http.post(
      Uri.parse("http://$url/booking/appointments/"),
      body: jsonEncode(<String, dynamic>{
        'date_time': appointment.date_time,
        'client_id': appointment.client_id,
        'contractor_id': appointment.contractor_id,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to post appointment: ${response.statusCode}');
    }
  }
}
