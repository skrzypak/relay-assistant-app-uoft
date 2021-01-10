import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CountersApiProvider {

    Future<Map?> fetchPostCountdown(String json) async {
      print(json);
      final http.Response response = await http.post(
          'http://192.168.1.20:80/countdown',
          headers: {
            'Content-Type': 'application/json'
          },
          body: json
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      Exception("Can't fetch countdown POST");
    }

    Future<Map?> fetchPostRepeat(String json) async {
      print(json);
      final http.Response response = await http.post(
          'http://192.168.1.20:80/stop-and-go',
          headers: {
            'Content-Type': 'application/json'
          },
          body: json
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      Exception("Can't fetch repeat POST");
    }
}