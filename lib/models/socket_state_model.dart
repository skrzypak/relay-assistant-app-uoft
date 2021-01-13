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

  void truncateDayOfWeekTimetable() => this._dayOfWeekTimetable = new Map();

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

  void addTimetable(int day, String time, bool state, String? id) {

    if(this._dayOfWeekTimetable.containsKey(day) == false) {
      this._dayOfWeekTimetable[day] = [Timetable(0, _index, day, time, state, id)];
      return;
    }

    int idx = this._dayOfWeekTimetable[day]!.length;
    var timetable = Timetable(idx, _index, day, time, state, id);

    int genIdx = 0;

    for(int i = 0; i < this._dayOfWeekTimetable[day]!.length; i++) {
      Timetable item = this._dayOfWeekTimetable[day]![i];
      if(time.compareTo(item.time!) > -1)
        genIdx++;
      else break;
    }

    print(genIdx);

    this._dayOfWeekTimetable[day]!.insert(genIdx, timetable);
  }
}