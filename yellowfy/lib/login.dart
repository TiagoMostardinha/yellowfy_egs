import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yellowfy/announcements.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _url = 'http://grupo6-egs-deti.ua.pt/auth/login';
  final _storage = FlutterSecureStorage();

  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Join the Yellow Community!',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellowAccent[700],
      ),
      body: WebView(
        initialUrl: _url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
        onPageFinished: (url) async {
          // Ensure the URL is valid and contains expected patterns
          if (url != null &&
              (url.contains("google/callback") ||
                  url.contains("/auth/login"))) {
            final statusPage = await _controller.currentUrl();

            // Check for an error in the URL before proceeding
            if (statusPage != null && statusPage.contains("error")) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Login failed. Please try again.',
                    style: TextStyle(color: Colors.white),
                  ),
                  duration: Duration(seconds: 5),
                ),
              );
            } else {
              // Attempt to parse the JSON response from the WebView
              try {
                final jsonString = await _controller
                    .runJavascriptReturningResult('document.body.innerText');
                final jsonData = jsonDecode(jsonDecode(jsonString));

                // Validate the parsed data
                if (jsonData['access_token'] != null &&
                    jsonData['refresh_token'] != null) {
                  final token = jsonData['access_token']
                      .toString()
                      .replaceAll('"', '')
                      .replaceAll('}', '')
                      .replaceAll('\n', '');
                  debugPrint("Token -> " + token, wrapWidth: 1024);
                  await _storage.write(key: 'access_token', value: token);

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => AnnouncementsPage(),
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Login successful!',
                        style: TextStyle(color: Colors.white),
                      ),
                      duration: Duration(seconds: 5),
                      backgroundColor: Colors.green,
                    ),
                  );

                  final String url = 'http://grupo6-egs-deti.ua.pt/auth/login';
                  final Map<String, String> headers = {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'access-token': token,
                  };

                  final response =
                      await http.post(Uri.parse(url), headers: headers);
                  debugPrint("Response -> " + response.body, wrapWidth: 1024);

                  if (response.statusCode == 200) {
                    final responseJson = json.decode(response.body);
                    debugPrint("User logged in successfully", wrapWidth: 1024);
                  } else {
                    debugPrint("User login failed : ${response.statusCode}",
                        wrapWidth: 1024);
                  }
                } else {
                  throw Exception("Invalid token data");
                }
              } catch (e) {
                debugPrint("Error during login process: $e", wrapWidth: 1024);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Login failed. Please try again.',
                      style: TextStyle(color: Colors.white),
                    ),
                    duration: Duration(seconds: 5),
                  ),
                );
              }
            }
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.yellowAccent[700],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => AnnouncementsPage(),
                  ),
                );
              },
              child: Text(
                'Skip Login',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Montserrat',
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
