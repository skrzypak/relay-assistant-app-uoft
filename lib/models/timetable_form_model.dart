import 'package:app/models/timetable_model.dart';
import 'package:flutter/material.dart';

class TimetableForm extends Timetable {

  TimetableForm(int index, int socket, int day, String time, bool state) :
        super(index, socket, day, time, state, false);

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

}