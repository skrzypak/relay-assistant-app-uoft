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
  get socket => this._socket;
  get day => this._day;
  get time => this._time;
  get state => this._state;
  get initialize => this._initialize;

}