import 'package:flutter/material.dart';
import 'package:yellowfy/common/Handlers.dart';
import 'package:yellowfy/models/announcements.dart';

class CreateAnnouncementPage extends StatelessWidget {
  const CreateAnnouncementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController userIdController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController latitudeController = TextEditingController();
    TextEditingController longitudeController = TextEditingController();

    Future<void> handlePostAnnouncement(BuildContext context) async {
      Announcement announcement = Announcement(
        userId: userIdController.text,
        category: categoryController.text,
        description: descriptionController.text,
        coordinates: Coordinate(
          latitude: double.parse(latitudeController.text),
          longitude: double.parse(longitudeController.text),
        ),
        id: '',
      );

      try {
        await handlePostAnnouncement(announcement as BuildContext);
        // Navigate back to the announcements page
        Navigator.pop(context);
      } catch (e) {
        print('Error posting announcement: $e');
        // Handle error
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Announcement'),
        backgroundColor: Colors.yellowAccent[700],
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: userIdController,
              decoration: InputDecoration(labelText: 'User ID'),
            ),
            TextFormField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: latitudeController,
              decoration: InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: longitudeController,
              decoration: InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                handlePostAnnouncement(context);
              },
              child: Text('Create Announcement'),
            ),
          ],
        ),
      ),
    );
  }
}
