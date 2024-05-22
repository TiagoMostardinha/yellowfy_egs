import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yellowfy/announcements.dart';
import 'package:yellowfy/map.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String _loginUrl =
      'http://localhost:5000/'; // Replace with your actual login URL
  final String _callbackUrl =
      'http://localhost:5000/auth/login'; // Replace with your actual callback URL

  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchURL() async {
    final Uri loginUri = Uri.parse(_loginUrl);
    final Uri callbackUri = Uri.parse(
        'http://localhost:5000/auth/login'); // Replace with your actual callback URL

    if (await canLaunchUrl(loginUri)) {
      await launchUrl(loginUri);
    } else {
      throw 'Could not launch $_loginUrl';
    }
    if (ModalRoute.of(context)!.settings.name != '/announcements') {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AnnouncementsPage()),
      );
    }
  }

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
      body: Container(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.build, // Wrench icon
                  size: 100,
                  color: Colors.yellowAccent[700],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your trusted platform for hiring professional contractors. '
                  'Connect with experienced and reliable contractors for all your project needs. '
                  'Join our community and make your projects come to life!',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellowAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                    height: 50), // Added space between text and button
                ElevatedButton(
                  onPressed: _launchURL,
                  child: const Text('Join Us!'),
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
