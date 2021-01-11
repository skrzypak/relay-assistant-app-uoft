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

    Future<void> fetchDeleteCountdown(int num) async {
      var request = http.Request('DELETE', Uri.parse('http://192.168.1.20/countdown'));
      request.bodyFields = {
        'socket': '$num'
      };
      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      }
      else {
        print(response.reasonPhrase);
        Exception("Can't fetch countdown POST DELETE");
      }
  }

  Future<void> fetchDeleteRepeat(int num) async {
    var request = http.Request('DELETE', Uri.parse('http://192.168.1.20/stop-and-go'));
    request.bodyFields = {
      'socket': '$num'
    };
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
      Exception("Can't fetch repeat POST DELETE");
    }
  }

}