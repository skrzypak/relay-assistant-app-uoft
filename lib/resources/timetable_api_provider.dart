import 'dart:async';
import 'dart:convert';
import 'package:app/blocs/esp_data_bloc.dart';
import 'package:http/http.dart' as http;

class TimetableApiProvider {

    Future<Map?> fetchGetTimetable() async {
      final http.Response response = await http.get(
          'http://${bloc.currentPowerStripIp}:80/timetable/dayofweek'
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      Exception("Can't fetch timetable GET");
    }

    Future<Map?> fetchPostTimetable(String json) async {
      print(json);
      final http.Response response = await http.post(
          'http://${bloc.currentPowerStripIp}:80/timetable/dayofweek',
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

    Future<void> fetchDeleteTimetable(String id) async {
      var request = http.Request('DELETE', Uri.parse('http://${bloc.currentPowerStripIp}/timetable/dayofweek'));
      request.bodyFields = {
        'id': '$id'
      };
      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print("fetchDeleteTimetable response: ${await response.stream.bytesToString()}");
      }
      else {
        print(response.reasonPhrase);
        Exception("Can't fetch timetable POST DELETE");
      }
    }
}