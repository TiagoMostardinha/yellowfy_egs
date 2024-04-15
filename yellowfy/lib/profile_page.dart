import 'package:flutter/material.dart';
import 'package:yellowfy/announcements.dart';
import 'package:yellowfy/contactspage.dart';
import 'package:yellowfy/common/Handlers.dart';
import 'package:yellowfy/models/authentication.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late Authentication _auth;
  final storage = FlutterSecureStorage();
  String _fname = "";
  String _mobile_number = "";

  @override
  void initState() {
    super.initState();
    fetchAuthentication('google_token');
  }

  Future<void> fetchAuthentication(String google_token) async {
    final String tokenKey = 'token';
    final String? token = await storage.read(key: tokenKey);

    if (token != null) {
      final String url = 'http://127.0.0.1:5000/authentication/$google_token';
    }
    try {
      Authentication auth = await Handlers().handleGetAuthentication();
      setState(() {
        _auth = auth;
      });
    } catch (e) {
      print('Erro fetching ID: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'YellowProfile',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellowAccent[700],
      ),
      body:
          // this is the page where im getting the information when the persons logs in
          Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage('assets/ye.jpg'), // Placeholder photo
          ),
          const SizedBox(height: 16),
          Text(
            'Name',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Job',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
