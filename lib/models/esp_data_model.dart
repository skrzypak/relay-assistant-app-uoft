import 'package:app/models/timetable_model.dart';

import 'socket_state_model.dart';

/// Class define global data container
class EspDataModel {
  List<SocketStateModel> _socketsDataList = [];

  /// Class constructor
  EspDataModel() {
    this._socketsDataList.add(new SocketStateModel(0, "USB"));
    this._socketsDataList.add(new SocketStateModel(1, "FIRST"));
    this._socketsDataList.add(new SocketStateModel(2, "SECOND"));
    this._socketsDataList.add(new SocketStateModel(3, "THIRD"));
  }

  get socketsDataList => this._socketsDataList;

  SocketStateModel getSocketData(int num) => this._socketsDataList[num];

  SocketStateModel? getSocketDataByName(String name) {
    String val = name.toUpperCase();
    switch(val) {
      case "USB": return this._socketsDataList[0];
      case "FIRST": return this._socketsDataList[0];
      case "SECOND": return this._socketsDataList[0];
      case "THIRD": return this._socketsDataList[0];
      default: return null;
    }
  }


  void offSocket(int num)  => this._socketsDataList[num].setState(false);

  void onSocket(int num) => this._socketsDataList[num].setState(true);

  void offAllSockets() {
    for(int i = 0; i < this._socketsDataList.length; i++) {
      this._socketsDataList[i].setState(false);
    }
  }
  void onAllSockets() {
    for(int i = 0; i < this._socketsDataList.length; i++) {
      this._socketsDataList[i].setState(true);
    }
  }

  void addRepeat(int index, bool state, int time, bool running, int zone,  List<int> zones, int repeats)
  => this._socketsDataList[index].setRepeat(state, time, running, zone, zones, repeats);

  void addCountdown(int index, bool state, int time, bool running)
  => this._socketsDataList[index].setCountdown(state, time, running);

  void addTimetable(int socket, int day, String time, bool state) {
    this._socketsDataList[socket].addTimetable(day, time, state);
  }

  List<Timetable> getDayOfWeekTimetable(int socket, int day) => this._socketsDataList[socket].dayOfWeekTimetable[day];
}