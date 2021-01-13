import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Timetable {
  int? _index;
  String? _id;
  int? _socket;
  int? _day;
  String? _time;
  bool? _state;

  Timetable(int? index, int socket, int day, String time, bool state, String? id) {
    this._index = index;
    this._socket = socket;
    this._day = day;
    this._time = time;
    this._state = state;
    this._id = id;
  }

  get id => this._id;
  int? get index => this._index;
  int? get socket => this._socket;
  int? get day => this._day;
  String? get time => this._time;
  bool? get state => this._state;

  @protected
  set index(int? idx) => this._index = idx;

  @protected
  set socket(int? socket) => this._socket = socket;

  @protected
  set day(int? day) => this._day = day;

  @protected
  set time(String? time) => this._time = time;

  @protected
  set state(bool? val) => this._state = val;

}