import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yellowfy/announcements.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  // Function to handle login with Yellowfy
  void _loginYellowfy(BuildContext context) async {
    final Uri url = Uri.parse('http://10.0.2.2:5000');
    try {
      if (await canLaunch(url.toString())) {
        await launch(url.toString());
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'YellowFy',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat', // Specify your desired font here
            fontSize: 24, // Adjust font size as needed
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellowAccent[700],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellowAccent[700]!,
                ),
                child: const Icon(
                  Icons.build,
                  size: 70,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30.0),
              GestureDetector(
                onTap: () => _loginYellowfy(context),
                child: Container(
                  width: 200.0,
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent[700],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Login with Yellowfy',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
            icon: Icon(Icons.person),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
        ],
        onTap: (int index) {
          if (index == 1) {
            // Navigate to the announcements page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AnnouncementsPage(),
              ),
            );
          }
        },
      ),
    );
  }
}
