import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TimetableApiProvider {

    Future<bool> fetchSetTimetable(String json) async {
      print(json);
      final http.Response response = await http.post(
          'http://192.168.1.20:80/timetable/dayofweek',
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