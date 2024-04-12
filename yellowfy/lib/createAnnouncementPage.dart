import 'package:flutter/material.dart';
import 'package:yellowfy/models/announcements.dart';

class CreateAnnouncementPage extends StatelessWidget {
  const CreateAnnouncementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Announcement'),
        backgroundColor: Colors.yellowAccent[700],
        centerTitle: true,
      ),
      body: const CreateAnnouncementPage(),
    );
  }
}
