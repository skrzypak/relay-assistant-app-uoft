import 'dart:async';
import 'dart:convert';
import 'package:app/blocs/esp_data_bloc.dart';
import 'package:http/http.dart' as http;

class SettingsApiProvider {
  Future<Map?> fetchGetStartupSocketsStates() async {
    final http.Response response = await http.get(
        'http://${bloc.currentPowerStripIp}:80/startup/sockets'
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    Exception("Can't fetch startup socket state GET");
  }

  Future<void> fetchPutStartupSocketStates(int index, bool state) async {
    final http.Response response = await http.put(
        state ? 'http://${bloc.currentPowerStripIp}:80/startup/socket/on' : 'http://${bloc.currentPowerStripIp}:80/startup/socket/off',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: "socket=$index"
    );
    if (response.statusCode == 200) {
      return;
    } else {
      print(response.body.toString());
      Exception("Fetch error set startup socket state");
    }
  }
}