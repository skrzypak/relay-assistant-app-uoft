import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SocketsStatesApiProvider {

  Future<void> fetchPostOffSocket(int num) async {
    final http.Response response = await http.put(
        'http://192.168.1.20:80/off',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: "socket=$num"
    );
    if (response.statusCode != 200 || jsonDecode(response.body).toString() != "null")
      Exception("Fetch error turn off socket");
  }

  Future<void> fetchPostOnSocket(int num) async {
    final http.Response response = await http.put(
        'http://192.168.1.20:80/on',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: "socket=$num"
    );
    if (response.statusCode != 200 || jsonDecode(response.body).toString() != "null")
      Exception("Fetch error turn on socket");
  }

  Future<void> fetchPostOffAllSockets() async {
    final http.Response response = await http.put(
        'http://192.168.1.20:80/off',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: "socket=0&socket=1&socket=2&socket=3"
    );
    if (response.statusCode != 200 || jsonDecode(response.body).toString() != "null")
      Exception("Fetch error turn off all socket");
  }

  Future<void> fetchPostOnAllSockets() async {
    final http.Response response = await http.put(
        'http://192.168.1.20:80/on',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: "socket=0&socket=1&socket=2&socket=3"
    );
    if (response.statusCode != 200 || jsonDecode(response.body).toString() != "null")
      Exception("Fetch error turn on all socket");
  }
}