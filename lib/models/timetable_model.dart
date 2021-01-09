import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Timetable {
  int? _index;
  int? _socket;
  int? _day;
  String? _time;
  bool? _state;
  bool? _initialize;

  Timetable(int index, int socket, int day, String time, bool state, bool initialize) {
    this._index = index;
    this._socket = socket;
    this._day = day;
    this._time = time;
    this._state = state;
    this._initialize = initialize;
  }

  get index => this._index;
  int? get socket => this._socket;
  int? get day => this._day;
  String? get time => this._time;
  bool? get state => this._state;
  get initialize => this._initialize;

  @protected
  set socket(int? socket) => this._socket = socket;

  @protected
  set day(int? day) => this._day = day;

  @protected
  set time(String? time) => this._time = time;

  @protected
  set state(bool? val) => this._state = val;

}