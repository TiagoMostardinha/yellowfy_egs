import 'package:flutter/material.dart';
import 'package:yellowfy/views/main.dart';
import 'package:yellowfy/views/map.dart';
import 'package:http/http.dart' as http;
import 'package:yellowfy/models/post.dart';
import 'dart:convert';

class AnnouncemntsPage extends StatefulWidget {
  const AnnouncemntsPage({Key? key}) : super(key: key);

  @override
  _AnnouncementsPageState createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncemntsPage> {
  late Future<List<Announcement>> _announcementsFuture;
  List<Announcement>? announcements;

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
  }

  Future<List<Announcement>> _fetchAnnouncements() async {
    final response = await http.get(
      Uri.parse('https://yellowfy.herokuapp.com/announcements'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((announcement) => Announcement.fromJson(announcement))
          .toList();
    } else {
      throw Exception('Failed to load announcements');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        backgroundColor: Colors.yellowAccent[700],
        centerTitle: true,
      ),
      body: FutureBuilder<List<Announcement>>(
        future: _announcementsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Announcement announcement = snapshot.data![index];
                return _buildAnnouncementCard(
                  name: snapshot.data![index].name,
                  job: snapshot.data![index].job,
                  imagePath: snapshot.data![index].imagePath,
                  contactInfo: snapshot.data![index].contactInfo,
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
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnnouncemntsPage()),
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
  }) {
    return GestureDetector(
      onTap: () {
        // Handle onTap as needed
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
