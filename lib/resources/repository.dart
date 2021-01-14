import 'dart:async';
import 'package:app/resources/counters_api_provider.dart';
import 'package:app/resources/settings_api_provider.dart';
import 'package:app/resources/timetable_api_provider.dart';
import 'sockets_states_api_provider.dart';

class Repository {
  final _socketsStatesApiProvider = SocketsStatesApiProvider();
  final _countersApiProvider = CountersApiProvider();
  final _timetableApiProvider = TimetableApiProvider();
  final _settingsApiProvider = SettingsApiProvider();

  Future<void> fetchPostOffSocket(int num) => _socketsStatesApiProvider.fetchPostOffSocket(num);
  Future<void> fetchPostOnSocket(int num) => _socketsStatesApiProvider.fetchPostOnSocket(num);
  Future<void> fetchPostOffAllSockets() => _socketsStatesApiProvider.fetchPostOffAllSockets();
  Future<void> fetchPostOnAllSockets() => _socketsStatesApiProvider.fetchPostOnAllSockets();

  Future<void> fetchDeleteCountdown(int num) => _countersApiProvider.fetchDeleteCountdown(num);
  Future<Map?> fetchPostCountdown(String json) => _countersApiProvider.fetchPostCountdown(json);
  Future<void> fetchDeleteRepeat(int num) => _countersApiProvider.fetchDeleteRepeat(num);
  Future<Map?> fetchPostRepeat(String json) => _countersApiProvider.fetchPostRepeat(json);

  Future<Map?> fetchGetTimetable() => _timetableApiProvider.fetchGetTimetable();
  Future<Map?> fetchPostTimetable(String json) => _timetableApiProvider.fetchPostTimetable(json);
  Future<void> fetchDeleteTimetable(String id) => _timetableApiProvider.fetchDeleteTimetable(id);

  Future<Map?> fetchGetStartupSocketsStates() => _settingsApiProvider.fetchGetStartupSocketsStates();
  Future<void> fetchPutStartupSocketStates(int index, bool state) => _settingsApiProvider.fetchPutStartupSocketStates(index, state);
}