import 'package:flutter/material.dart';
import 'package:yellowfy/announcements.dart';
import 'package:yellowfy/login.dart';
import 'package:yellowfy/map.dart';
import 'package:yellowfy/booking.dart';
import 'package:yellowfy/profile_page.dart';

class ContactInfoPage extends StatelessWidget {
  final String contactInfo;
  final int  userID;
  final String name;
  final String job;
  final String announcement_id;
  final String coordinates;
  final String description;

  const ContactInfoPage({
    Key? key,
    required this.contactInfo,
    required this.userID,
    required this.name,
    required this.job,
    required this.announcement_id,
    required this.coordinates,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yellow Worker'),
        backgroundColor:
            Colors.yellowAccent[700], // Match the color with AnnouncementsPage
        centerTitle: true,
      ),
      backgroundColor: Colors.black, // Set background color to blackS
      body: Container(
        color: Colors.black, // Set background color to black
        child: SingleChildScrollView(
          child: Container(
            // Wrap SingleChildScrollView with Container
            color: Colors.black, // Set background color to black
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/images.jpg'),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color:
                        Colors.white, // Match text color with AnnouncementsPage
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  job,
                  style: TextStyle(
                    fontSize: 18,
                    color:
                        Colors.white, // Match text color with AnnouncementsPage
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      coordinates,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors
                              .white), // Match text color with AnnouncementsPage
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      contactInfo,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors
                              .white), // Match text color with AnnouncementsPage
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingPage(
                            contractor_id: userID,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellowAccent[
                          700], // Match button color with AnnouncementsPage
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Book Now',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
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
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AnnouncementsPage()),
            );
          } else if (index == 2) {
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
