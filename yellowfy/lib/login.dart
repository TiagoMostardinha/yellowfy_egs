import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yellowfy/announcements.dart';
import 'package:yellowfy/map.dart';

class LoginPage extends StatelessWidget {
  final String _loginUrl =
      'http://localhost:5000/'; // Replace with your actual login URL
  final _storage = FlutterSecureStorage();

  Future<void> _launchURL() async {
    final Uri loginUri = Uri.parse(_loginUrl);
    final Uri callbackUri = Uri.parse(
        'http://localhost:5000/callback'); // Replace with your actual callback URL

    // Listen for URL changes
    _urlListener(callbackUri);

    if (await canLaunch(loginUri.toString())) {
      await launch(loginUri.toString());
    } else {
      throw 'Could not launch $_loginUrl';
    }
  }

  void _urlListener(Uri callbackUri) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Join the Yellow Community!',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellowAccent[700],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Your trusted platform for hiring professional contractors. '
                'Connect with experienced and reliable contractors for all your project needs. '
                'Join our community and make your projects come to life!',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _launchURL,
                child: const Text('Go to Login Page'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellowAccent[700],
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.yellowAccent[700],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Finder',
          ),
        ],
        onTap: (index) {
          // Handle bottom navigation bar taps here
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AnnouncementsPage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapPage()),
            );
          }
        },
      ),
    );
  }
}
