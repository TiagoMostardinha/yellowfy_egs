import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'login.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'YellowFy',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: LoginPage(), // Set LoginPage as the home screen
        routes: {
          '/login': (context) => LoginPage(),
        });
  }
}
