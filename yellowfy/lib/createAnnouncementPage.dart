import 'package:flutter/material.dart';
import 'package:yellowfy/common/Handlers.dart';
import 'package:yellowfy/models/announcements.dart';

class CreateAnnouncementPage extends StatelessWidget {
  final String userId;
  final String userName;

  const CreateAnnouncementPage(
      {Key? key, required this.userId, required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController categoryController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController latitudeController = TextEditingController();
    TextEditingController longitudeController = TextEditingController();

    Future<void> postAnnouncement(BuildContext context) async {
      Announcement announcement = Announcement(
        userId: userName,
        category: categoryController.text,
        description: descriptionController.text,
        coordinates: Coordinate(
          latitude: double.parse(latitudeController.text),
          longitude: double.parse(longitudeController.text),
        ),
        id: userId,
      );

      try {
        await Handlers().handlePostAnnouncement(announcement);
        Navigator.pop(context);
      } catch (e) {
        print('Error posting announcement: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error posting announcement: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Announcement'),
        backgroundColor: Colors.yellowAccent[700],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Creating announcement for: $userName',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: latitudeController,
              decoration: const InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: longitudeController,
              decoration: const InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                postAnnouncement(context);
              },
              child: const Text('Create Announcement'),
            ),
          ],
        ),
      ),
    );
  }
}
