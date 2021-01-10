import 'dart:convert';

import 'package:app/models/timetable_model.dart';

class TimetableForm extends Timetable {

  TimetableForm(int index, int socket, int day, String time, bool state) :
        super(index, socket, day, time, state, null);

  void setSocket(int socket) {
    this.socket = socket;
  }

  void setDay(int day) {
    this.day = day;
  }

  void setTime(String time) {
    this.time = time;
  }

  void toggleState() {
    if(this.state == null || this.state == true)
      this.state = false;
    else this.state = true;
  }

  Map<String, dynamic> _toJson() =>
      {
        "0": {
          "socket": this.socket,
          "day": this.day,
          "time": this.time,
          "state": this.state! ? 1 : 0
        }
      };

  String toJson() {
    String val = "";
    var json = _toJson();
    val = jsonEncode(json);
    return val;
  }

}