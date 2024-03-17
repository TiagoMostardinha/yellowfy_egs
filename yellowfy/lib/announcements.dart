import 'package:flutter/material.dart';
import 'package:yellowfy/main.dart';
import 'package:yellowfy/map.dart';
import 'package:yellowfy/contactspage.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        backgroundColor: Colors.yellowAccent[700],
        centerTitle: true,
      ),
      body: ListView(
        scrollDirection: Axis.vertical, // Vertical scrolling
        children: [
          _buildAnnouncementCard(
            name: 'John Doe',
            job: 'Plumber',
            imagePath: 'assets/ye.jpg',
            contactInfo: 'Phone: 123-456-7890',
            context: context,
          ),
          // Add more announcement cards here as needed
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

  Widget _buildAnnouncementCard({
    required String name,
    required String job,
    required String imagePath,
    required String contactInfo,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ContactInfoPage(contactInfo: contactInfo, name: name, job: job),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 350, // Adjust card width as needed
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(imagePath),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    job,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
