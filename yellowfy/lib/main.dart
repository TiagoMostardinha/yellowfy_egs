import 'package:flutter/material.dart';
import 'login.dart'; // Import the login page file

void main() {
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
      home: const LoginPage(), // Set LoginPage as the home screen
    );
  }
}
