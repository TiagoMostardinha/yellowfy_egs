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
        var latitude = ((i['location']['lat'].toDouble()) ?? '') ?? 0.0;
        var longitude = (((i['location']['long'].toDouble()) ?? '') ?? 0.0);

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
    final response =
        await http.get(Uri.parse("http://$url/announcements/v1/$id"));
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
    Future<List<Announcement>> handleGetAnnouncementsByGPS(double radius, double lat, double long) async {
    String url = dotenv.get("URL", fallback: "");
    String port = dotenv.get("PORT_ANNOUNCEMENTS", fallback: "");
    final response = await http.get(Uri.parse("http://$url/announcements/v1/?radius=$radius&lat=$lat&long=$long"));
    if (response.statusCode == 200) {
      List<Announcement> announcements = [];
      var data = jsonDecode(response.body);
      if (data == null) return announcements;
      for (var i in data) {
        var id = i['Id'] ?? '';
        var userId = i['userID'] ?? '';
        var category = i['category'] ?? '';
        var description = i['description'] ?? '';
        var latitude = ((i['location']['lat'].toDouble()) ?? '') ?? 0.0;
        var longitude = (((i['location']['long'].toDouble()) ?? '') ?? 0.0);

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

  Future<void> handlePostAnnouncement(Announcement announcement) async {
    String url = dotenv.get("URL", fallback: "");
    String port = dotenv.get("PORT_ANNOUNCEMENTS", fallback: "");
    final response = await http.post(
      Uri.parse("http://$url/announcements/v1/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userID': announcement.userId,
        'category': announcement.category,
        'description': announcement.description,
        'latitude': announcement.coordinates.latitude,
        'longitude': announcement.coordinates.longitude,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to post announcement: ${response.statusCode}');
    }
  }

  /*
  * Appointements
  */
  Future<List<Appointment>> handleGetAppointments() async {
    String url = dotenv.get("URL", fallback: "");
    String port = dotenv.get("PORT_APPOITMENTS", fallback: "");
    final response =
        await http.get(Uri.parse("http://$url:$port/appointments/"));
    if (response.statusCode == 200) {
      List<Appointment> appointments = [];
      var data = jsonDecode(response.body);
      print(data);
      for (var i in data) {
        appointments.add(Appointment(
          i['announcement_id'] ?? '',
          i['date_time'] ?? '',
          i['client_id'] ?? '',
          i['contractor_id'] ?? '',
          i['duration'] ?? '',
        ));
      }
      return appointments;
    } else {
      throw Exception('Failed to load appointments: ${response.statusCode}');
    }
  }

  // get appointments by contractor id

  Future<Appointment> handleGetPostByCID(String id) async {
    String url = dotenv.get("URL", fallback: "");
    String port = dotenv.get("PORT_APPOITMENTS", fallback: "");
    final response =
        await http.get(Uri.parse("http://$url:$port/appointments/$id"));
    if (response.statusCode == 200) {
      Appointment appointment;

      var data = jsonDecode(response.body);

      appointment = Appointment(
        data['announcement_id'] ?? '',
        data['date_time'] ?? '',
        data['client_id'] ?? '',
        data['contractor_id'] ?? '',
        data['duration'] ?? '',
      );
      return appointment;
    } else {
      throw Exception('Failed to load appointments: ${response.statusCode}');
    }
  }

  Future<void> handlePostAppointment(Appointment appointment) async {
    String url = dotenv.get("URL", fallback: "");
    String port = dotenv.get("PORT_APPOITMENTS", fallback: "");
    final response = await http.post(
      Uri.parse("http://$url:$port/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'announcement_id': appointment.announcement_id,
        'date_time': appointment.date_time,
        'client_id': appointment.client_id,
        'contractor_id': appointment.contractor_id,
        'duration': appointment.duration,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to post appointment: ${response.statusCode}');
    }
  }

  /*
  * Authentication
  */

  Future<Authentication> handleGetAuthentication() async {
    String url = dotenv.get("URL", fallback: "");
    String port = dotenv.get("PORT_AUTHENTICATION", fallback: "");

    final response = await http.get(Uri.parse("http://$url/auth/login/"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return Authentication(
        data['id'] ?? '',
        data['name'] ?? '',
        data['email'] ?? '',
        data['password'] ?? '',
        data['looking_for_work'] ?? '',
        data['mobile_number'] ?? '',
      );
    } else {
      throw Exception(
          'Failed to load authentication for user : ${response.statusCode}');
    }
  }

  Future<void> handlePostAuthentication(Authentication authentication) async {
    String url = dotenv.get("URL", fallback: "");
    String port = dotenv.get("PORT_AUTHENTICATION", fallback: "");
    final response = await http.post(
      Uri.parse("http://$url:$port/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': authentication.name,
        'email': authentication.email,
        'password': authentication.password,
        'looking_for_work': authentication.looking_for_work,
        'mobile_number': authentication.mobile_number,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to post authentication: ${response.statusCode}');
    }
  }
}
