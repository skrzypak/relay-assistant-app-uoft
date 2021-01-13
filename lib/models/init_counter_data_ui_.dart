import 'dart:convert';

class InitCounterDataUi {
  int? _index;
  String? _name;

  List<DateTime> _zonesLastExtra = [DateTime(2000, 1, 1, 0, 0, 0)];
  bool _state = false;
  int _repeats = 1;

  InitCounterDataUi(int index, String name) {
    this._index = index;
    this._name = name;
  }

  get index => this._index;

  get name => this._name;

  get zones => this._zonesLastExtra;

  get state => this._state;

  get repeats => this._repeats;

  get length => this._zonesLastExtra.length;

  get numOfValidZones => this._zonesLastExtra.length - 1;

  void addZone(DateTime val) => this._zonesLastExtra.add(val);

  DateTime getZone(int index) => this._zonesLastExtra[index];

  void updateZone(int index, DateTime val) => this._zonesLastExtra[index] = val;

  void toggleState() => this._state = !this._state;

  void setRepeat(int val) => this._repeats = val;

  void removeZone(int index) => this._zonesLastExtra.removeAt(index);

  Map<String, dynamic> _toCountdownJson(int second) =>
      {
        "0": {
          "socket": _index,
          "countdown": second,
          "state": _state ? 1 : 0
        }
      };

  Map<String, dynamic> _toRepeatJson(List<int> seconds) =>
      {
        "0": {
          "socket": _index,
          "zones": seconds,
          "state": _state ? 1 : 0,
          "repeats": _repeats > 0 ? _repeats : 1
        }
      };

  String toJson() {
    String val = "";
    var json;
    if(this._zonesLastExtra.length == 1) {
      // Countdown
      var item = this._zonesLastExtra.first;
      int sec = item.hour * 3600 + item.minute * 60 + item.second;
      json = _toCountdownJson(sec);
    } else {
      // Repeat
      this._zonesLastExtra.removeLast();
      List<int> seconds = [];
      for(int i = 0; i < _zonesLastExtra.length; i++) {
        var item = this._zonesLastExtra[i];
        int sec = item.hour * 3600 + item.minute * 60 + item.second;
        seconds.add(sec);
      }
      json = _toRepeatJson(seconds);
    }
    val = jsonEncode(json);
    return val;
  }

}