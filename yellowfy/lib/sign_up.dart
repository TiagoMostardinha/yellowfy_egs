import 'package:flutter/material.dart';
import 'package:yellowfy/login.dart';
import 'package:yellowfy/main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isYellowWorker = false;
  String _selectedRole = 'Role'; // Default value for the dropdown

  // Define a list of roles
  final List<String> _roles = [
    'Role',
    'Role 1',
    'Role 2',
    'Role 3',
    // Add more roles as needed
  ];

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                Icons.person_add,
                size: 70,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
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
            CheckboxListTile(
              title: const Text("Are you a Yellow Worker?"),
              value: _isYellowWorker,
              onChanged: (bool? value) {
                setState(() {
                  _isYellowWorker = value!;
                });
              },
            ),
            const SizedBox(height: 10.0),
            // DropdownButton for selecting roles
            SizedBox(
              width: double.infinity,
              child: DropdownButton<String>(
                value: _selectedRole,
                items: _roles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
            ),

            ElevatedButton(
              onPressed: () {
                // Sign Up button action
                String name = nameController.text.trim();
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                // Use _selectedRole to get the selected role
                // Use _isYellowWorker to determine if the user is a yellow worker
                // Implement your sign-up logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellowAccent[700]!,
                textStyle: const TextStyle(
                  color: Colors.black,
                ),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate back to the login page
                Navigator.pop(context);
              },
              child: const Text(
                "Already have an account? Log In",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
