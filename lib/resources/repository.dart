import 'dart:async';
import 'package:app/models/esp_data_model.dart';
import 'package:app/models/timetable_model.dart';
import 'package:app/resources/counters_api_provider.dart';
import 'package:app/resources/timetable_api_provider.dart';
import 'sockets_states_api_provider.dart';
import 'esp_data_api_provider.dart';

class Repository {
  final _socketsStatesApiProvider = SocketsStatesApiProvider();
  final _countersApiProvider = CountersApiProvider();
  final _timetableApiProvider = TimetableApiProvider();
  final _espDataApiProvider = EspDataApiProvider();

  Future<EspDataModel> fetchEspData() => _espDataApiProvider.fetchEspData();
  Future<void> fetchPostOffSocket(int num) => _socketsStatesApiProvider.fetchPostOffSocket(num);
  Future<void> fetchPostOnSocket(int num) => _socketsStatesApiProvider.fetchPostOnSocket(num);
  Future<void> fetchPostOffAllSockets() => _socketsStatesApiProvider.fetchPostOffAllSockets();
  Future<void> fetchPostOnAllSockets() => _socketsStatesApiProvider.fetchPostOnAllSockets();

  Future<Map?> fetchPostCountdown(String json) => _countersApiProvider.fetchPostCountdown(json);
  Future<Map?> fetchPostRepeat(String json) => _countersApiProvider.fetchPostRepeat(json);

  Future<Map?> fetchTimetable() => _timetableApiProvider.fetchTimetable();
  Future<Map?> fetchSetTimetable(String json) => _timetableApiProvider.fetchPostTimetable(json);
}