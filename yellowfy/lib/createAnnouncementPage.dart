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
      debugPrint('CONTEXTTTTTTTTTTTTTTTTT: $context');
      Announcement announcement = Announcement(
        userId: userName,
        category: categoryController.text,
        description: descriptionController.text,
        coordinates: Coordinate(
          latitude: double.parse(latitudeController.text),
          longitude: double.parse(longitudeController.text),
        ),
        id: '',
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
      backgroundColor: Colors.black, // Set the background color of the Scaffold
      body: Container(
        color: Colors.black, // Ensure the Container has a black background
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Creating announcement for: $userName',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                controller: categoryController,
                label: 'Category',
                icon: Icons.build,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                controller: descriptionController,
                label: 'Description',
                icon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                controller: latitudeController,
                label: 'Latitude',
                icon: Icons.map,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                controller: longitudeController,
                label: 'Longitude',
                icon: Icons.map,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    postAnnouncement(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellowAccent[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 15.0),
                  ),
                  child: const Text(
                    'Create Announcement',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.yellowAccent[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.grey[900], // Dark grey for the input fields
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
    );
  }
}
