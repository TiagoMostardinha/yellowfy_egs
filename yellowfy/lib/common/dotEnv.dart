import 'package:flutter_dotenv/flutter_dotenv.dart';

class dotEnv {
  loadUrl() async {
    await dotenv.load(fileName: "assets/.env");

    return dotenv.get("NGROK_URL");
  }

  loadUrlAnnouncements() async {
    await dotenv.load(fileName: "assets/.env");
    String url = loadUrl();
    String port = dotenv.get("PORT_ANNOUNCEMENTS");

    return url + ":" + port;
  }

  loadUrlAppointments() async {
    await dotenv.load(fileName: "assets/.env");
    String url = loadUrl();
    String port = dotenv.get("PORT_APPOINTMENTS");

    return url + ":" + port;
  }

  loadUrlAuthentication() async {
    await dotenv.load(fileName: "assets/.env");
    String url = loadUrl();
    String port = dotenv.get("PORT_AUTHENTICATION");

    return url + ":" + port;
  }
}
