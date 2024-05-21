import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yellowfy/announcements.dart';
import 'package:yellowfy/login.dart';

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
        home: LoginPage(),
        routes: {
          '/login': (context) => LoginPage(),
        });
  }
}
