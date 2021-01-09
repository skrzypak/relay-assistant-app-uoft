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
    _espDataModel.addCountdown(0, state, time, true);
    state = Random().nextBool();
    time = Random().nextInt(250);
    int zone = Random().nextInt(5);
    List<int> zones = [5, 10, 15];
    int repeats = Random().nextInt(250);
    _espDataModel.addRepeat(1, state, time, true, zone, zones, repeats);

    _espDataModel.addTimetable(0, 0, "01:00", false);
    _espDataModel.addTimetable(0, 0, "10:00", false);
    _espDataModel.addTimetable(0, 1, "03:00", false);
    _espDataModel.addTimetable(0, 3, "12:00", true);
    _espDataModel.addTimetable(1, 3, "12:00", true);

    return _espDataModel;
  }
}