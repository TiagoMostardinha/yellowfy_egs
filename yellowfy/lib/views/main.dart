import 'package:flutter/material.dart';
import 'announcements.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YellowFy',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isWorker = true; // Assume user is a worker for demonstration

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'YellowFy',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat', // Specify your desired font here
              fontSize: 24, // Adjust font size as needed
            ),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.yellowAccent[700]!, Colors.yellowAccent[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.yellowAccent[700]!,
            ),
            child: const Icon(
              Icons.build,
              size: 80,
              color: Colors.black,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'PhoneNumber',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          if (isWorker)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Worker Capabilitys',
                  border: OutlineInputBorder(),
                ),
                items: <String>[
                  'Contractor',
                  'Plumber',
                  'Electrician',
                  // Add more options as needed
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // Handle dropdown value change here
                },
              ),
            ),
          ElevatedButton(
            onPressed: () {
              // Login button action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent[700]!,
              textStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Register button action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent[700],
            ),
            child: const Text(
              'Sign up',
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
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
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
        ],
        onTap: (int index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnnouncemntsPage()),
            );
          }
        },
      ),
    );
  }
}

class Montserrat {
  static const String fontName = 'Montserrat';
}
