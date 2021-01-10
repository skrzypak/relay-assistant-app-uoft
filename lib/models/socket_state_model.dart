import 'package:app/models/timetable_model.dart';

import './modes/mode_model.dart';
import './modes/countdown_model.dart';
import './modes/repeat_model.dart';
/// Class contain sockets data
class SocketStateModel {
  late int _index;
  late String _name;
  late bool _state;
  ModeModel? _mode;
  Map<int, List<Timetable>> _dayOfWeekTimetable = new Map();

  /// Class constructor
  /// @param index socket index
  /// @param name socket name
  SocketStateModel(int index, String name) {
    this._index = index;
    this._name = name;
    this._state = false;
    this._mode = null;
  }

  SocketStateModel.fromJson(Map<String, dynamic> parsedJson){
    print(parsedJson);
  }

  void setState(bool state) => this._state = state;

  void setRepeat(bool state, int time, bool running, int zone,  List<int> zones, int repeats)
  => this._mode = new RepeatModel(state, time, running, zone, zones, repeats);

  void setCountdown(bool state, int time, bool running)
  => this._mode = new CountdownModel(state, time, running);

  void removeMode() => this._mode = null;

  ModeModel? getMode() => this._mode;

  get index => this._index;

  get name => this._name;

  get state => this._state;

  get dayOfWeekTimetable => this._dayOfWeekTimetable;

  void addTimetable(int day, String time, bool state, String id) {
    if(this._dayOfWeekTimetable.containsKey(day) == false) {
      this._dayOfWeekTimetable[day] = [];
    }
    int idx = this._dayOfWeekTimetable[day]!.length;
    this._dayOfWeekTimetable[day]!.add(Timetable(idx, _index, day, time, state, id));
  }

  void initTimetable(int day, String time, bool state) {
    if(this._dayOfWeekTimetable.containsKey(day) == false) {
      this._dayOfWeekTimetable[day] = [];
    }
    int idx = this._dayOfWeekTimetable[day]!.length;
    this._dayOfWeekTimetable[day]!.add(Timetable(idx, _index, day, time, state, null));
  }
}