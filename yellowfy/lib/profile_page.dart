import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final storage = FlutterSecureStorage();
  String _fname = "";
  String _job = ""; // Assuming you will retrieve the user's job as well
  String _phoneNumber =
      ""; // Assuming you will retrieve the user's phone number
  bool _isLoading = true; // Indicates whether data is being loaded or not

  @override
  void initState() {
    super.initState();
    // Fetch user data here
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    // Simulating data fetching from storage or API
    // Replace this with actual data fetching logic
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      // Update _fname, _job, and _phoneNumber with fetched data
      _fname = "Guilherme Claro"; // Example data
      _job = ""; // Example data
      _phoneNumber = "964377079"; // Example data
      _isLoading = false; // Data loading is complete
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'YellowProfile',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellowAccent[700],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Loading indicator
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage('assets/images.jpg'),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      _fname,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      _job,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      _phoneNumber,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
