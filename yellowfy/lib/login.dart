import 'package:flutter/material.dart';
import 'package:yellowfy/announcements.dart';
import 'package:yellowfy/sign_up.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  Future<void> _login(String email, String password) async {
    final url = ''; // TODO : espetar o url endpoint do castanheira
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {'email': email, 'password': password},
        ),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print('Login Successful');
        // Navigate to the announcements page
      } else {
        print('Login Failed');
      }
    } catch (error) {
      print('Erro: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellowAccent[700]!,
              ),
              child: const Icon(
                Icons.build,
                size: 70,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Login button action
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                _login(email, password);
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
            TextButton(
              onPressed: () {
                // Navigate to the sign-up page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text(
                "Don't have an account? Sign Up",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
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
            // Navigate to the announcements page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AnnouncementsPage(),
              ),
            );
          }
        },
      ),
    );
  }
}