import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CountersApiProvider {

    Future<bool> fetchSetCountdown(String json) async {
      print(json);
      final http.Response response = await http.post(
          'http://192.168.1.20:80/countdown',
          headers: {
            'Content-Type': 'application/json'
          },
          body: json
      );
      if (response.statusCode == 200) {
        print(jsonDecode(response.body).toString());
        return true;
      }
      return false;
    }

    Future<bool> fetchSetRepeat(String json) async {
      print(json);
      final http.Response response = await http.post(
          'http://192.168.1.20:80/stop-and-go',
          headers: {
            'Content-Type': 'application/json'
          },
          body: json
      );
      if (response.statusCode == 200) {
        print(jsonDecode(response.body).toString());
        return true;
      }
      return false;
    }
}