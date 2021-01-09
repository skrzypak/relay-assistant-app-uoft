import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SocketsStatesApiProvider {

  Future<bool> fetchSetOffSocket(int num) async {
    final http.Response response = await http.put(
        'http://192.168.1.20:80/off',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: "socket=$num"
    );
    if (response.statusCode == 200 && jsonDecode(response.body).toString() == "null")
      return true;
    return false;
  }

  Future<bool> fetchSetOnSocket(int num) async {
    final http.Response response = await http.put(
        'http://192.168.1.20:80/on',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: "socket=$num"
    );
    if (response.statusCode == 200 && jsonDecode(response.body).toString() == "null")
      return true;
    return false;
  }

  Future<bool> fetchSetOffAllSockets() async {
    final http.Response response = await http.put(
        'http://192.168.1.20:80/off',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: "socket=0&socket=1&socket=2&socket=3"
    );
    if (response.statusCode == 200 && jsonDecode(response.body).toString() == "null")
      return true;
    return false;
  }

  Future<bool> fetchSetOnAllSockets() async {
    final http.Response response = await http.put(
        'http://192.168.1.20:80/on',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: "socket=0&socket=1&socket=2&socket=3"
    );
    if (response.statusCode == 200 && jsonDecode(response.body).toString() == "null")
      return true;
    return false;
  }
}