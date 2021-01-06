import 'dart:async';
import 'dart:math';
import 'package:app/models/esp_data_model.dart';

class EspDataApiProvider {
  Future<EspDataModel> fetchEspData() async {
    final _espDataModel = EspDataModel();
    // TODO send request to esp32

    // FOR TESTING
    bool state = Random().nextBool();
    int time = Random().nextInt(250);
    _espDataModel.getSocketDataByName("USB")!.setCountdown(state, time, true);
    state = Random().nextBool();
    time = Random().nextInt(250);
    int zone = Random().nextInt(5);
    List<int> zones = [5, 10, 15];
    int repeats = Random().nextInt(250);
    _espDataModel.getSocketDataByName("SECOND")!.setRepeat(state, time, true, zone, zones, repeats);

    return _espDataModel;
  }
}