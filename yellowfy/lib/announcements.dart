import 'package:flutter/material.dart';
import 'package:yellowfy/createAnnouncementPage.dart';
import 'package:yellowfy/map.dart';
import 'package:yellowfy/contactspage.dart';
import 'package:yellowfy/common/Handlers.dart';
import 'package:yellowfy/models/announcements.dart';
import 'package:yellowfy/profile_page.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        backgroundColor: Colors.yellowAccent[700],
        centerTitle: true,
        // add a button to create a new announcement
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to the announcement creation page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateAnnouncementPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Announcement>>(
        future: Handlers().handleGetAnnouncements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Announcement>? announcements = snapshot.data;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: announcements!.length,
              itemBuilder: (context, index) {
                return _buildAnnouncementCard(
                  name: announcements[index].userId,
                  job: announcements[index].category,
                  imagePath: 'assets/ye.jpg',
                  contactInfo: announcements[index].description,
                  coordinates: "" +
                      announcements[index].coordinates.latitude.toString() +
                      " " +
                      announcements[index].coordinates.longitude.toString(),
                  description: announcements[index].description,
                  id: announcements[index].id,
                  context: context,
                );
              },
            );
          }
        },
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
              MaterialPageRoute(builder: (context) => ProfilePage()),
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
    required String coordinates,
    required String description,
    required String id,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactInfoPage(
                contactInfo: contactInfo,
                name: name,
                job: job,
                announcement_id: id,
                coordinates: coordinates,
                description: description),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 350, // Adjust card width as needed
          height: 225, // Adjust card height as needed
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120, // Adjust image height
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
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
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey[600],
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      coordinates,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
