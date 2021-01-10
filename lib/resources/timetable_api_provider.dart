import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:app/models/esp_data_model.dart';
import 'package:app/models/timetable_model.dart';
import 'package:http/http.dart' as http;

class TimetableApiProvider {

    Future<Map?> fetchTimetable() async {
      final http.Response response = await http.get(
          'http://192.168.1.20:80/timetable/dayofweek'
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      Exception("Can't fetch timetable GET");
    }

    Future<Map?> fetchPostTimetable(String json) async {
      print(json);
      final http.Response response = await http.post(
          'http://192.168.1.20:80/timetable/dayofweek',
          headers: {
            'Content-Type': 'application/json'
          },
          body: json
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      Exception("Can't fetch timetable POST");
    }
}