import 'dart:async';
import 'package:app/models/esp_data_model.dart';
import 'sockets_states_api_provider.dart';
import 'esp_data_api_provider.dart';

class Repository {
  final _socketsStatesApiProvider = SocketsStatesApiProvider();
  final _espDataApiProvider = EspDataApiProvider();
  Future<EspDataModel> fetchEspData() => _espDataApiProvider.fetchEspData();
  Future<bool> fetchSetOffSocket(int num) => _socketsStatesApiProvider.fetchSetOffSocket(num);
  Future<bool> fetchSetOnSocket(int num) => _socketsStatesApiProvider.fetchSetOnSocket(num);
  Future<bool> fetchSetOffAllSockets() => _socketsStatesApiProvider.fetchSetOffAllSockets();
  Future<bool> fetchSetOnAllSockets() => _socketsStatesApiProvider.fetchSetOnAllSockets();
}