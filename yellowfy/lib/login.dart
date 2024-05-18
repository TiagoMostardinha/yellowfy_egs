import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yellowfy/announcements.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _url = 'http://10.0.2.2:5000/';
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
            if (url != null && url.contains("callback")) {
              final statusPage = await _controller.currentUrl();
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
                final jsonString = await _controller
                    .runJavascriptReturningResult('document.body.innerText');
                final jsonData = jsonDecode(jsonString);

                final res = jsonData.toString();
                final out = res.split(" ");
                final token = out[3]
                    .replaceAll('"', '')
                    .replaceAll('}', '')
                    .replaceAll('\n', '');
                debugPrint("Token -> " + token, wrapWidth: 1024);
                await _storage.write(key: 'token', value: token);
                Navigator.of(context).pop();
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
                final String url = 'http://10.0.2.2:5000/additional_info';
                final Map<String, String> headers = {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  'x-access-token': token,
                };
                final response =
                    await http.post(Uri.parse(url), headers: headers);

                if (response.statusCode == 200) {
                  debugPrint("User logged in successfully", wrapWidth: 1024);
                } else {
                  debugPrint("User login failed : ${response.statusCode}",
                      wrapWidth: 1024);
                }
              }
            }
          }),
    );
  }
}
