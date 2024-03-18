import 'package:http/http.dart' as http;
import 'package:yellowfy/models/post.dart';

class RemoteService {
  var client = http.Client();
  Future<List<Announcement>?> getAnnouncements() async {
    var client = http.Client();
    var uri = Uri.parse('https://yellowfy.herokuapp.com/announcements');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return postFromJson(json);
    }
  }
}
