import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yellowfy/createAnnouncementPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _storage = FlutterSecureStorage();

  String _id = "";
  String _name = "";
  String _email = "";
  String _phone = "";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    debugPrint("Fetching user data...");
    final String tokenKey = "access_token";
    final String? token = await _storage.read(key: tokenKey);

    if (token != null) {
      final String url = 'http://grupo6-egs-deti.ua.pt/auth/userinfo';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        setState(() {
          _id = responseJson['id'].toString();
          _name = responseJson['name'];
          _email = responseJson['email'];
          _phone = responseJson['mobile_number'];
        });
        debugPrint("ID: $_id");
        debugPrint("Name: $_name");
        debugPrint("Email: $_email");
        debugPrint("Phone: $_phone");
        debugPrint("User data fetched successfully");
      } else {
        debugPrint("Failed to fetch user data: ${response.statusCode}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yellow Profile'),
        backgroundColor: Colors.yellowAccent[700],
        centerTitle: true,
      ),
      backgroundColor: Colors.black, // Set the background color of the Scaffold
      body: Container(
        color: Colors.black, // Ensure the Container has a black background
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage('assets/images.jpg'),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 20),
                Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildProfileInfo('ID', _id),
                        _buildProfileInfo('Name', _name),
                        _buildProfileInfo('Email', _email),
                        _buildProfileInfo('Phone', _phone),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateAnnouncementPage(
                          userId: _id,
                          userName: _name,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellowAccent[700],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Create Announcement',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}
