import 'package:flutter/material.dart';
import 'package:yellowfy/announcements.dart';
import 'package:yellowfy/login.dart';
import 'package:yellowfy/map.dart';
import 'package:yellowfy/booking.dart';

class ContactInfoPage extends StatelessWidget {
  final String contactInfo;
  final String name;
  final String job;
  final String announcement_id;

  const ContactInfoPage({
    Key? key,
    required this.contactInfo,
    required this.name,
    required this.job,
    required this.announcement_id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yellow Worker'),
        backgroundColor: Colors.yellowAccent[700],
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage('assets/ye.jpg'), // Placeholder photo
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            job,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.phone, color: Colors.green),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.message, color: Colors.blue),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 200, // Adjust width according to your needs
            height: 50,
            child: TextButton(
              onPressed: () {
                print(announcement_id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BookingPage(announcement_id: announcement_id)),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.yellowAccent[700],
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
          // Handle bottom navigation bar taps here
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AnnouncementsPage()),
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
