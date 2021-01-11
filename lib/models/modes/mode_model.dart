/// Abstract class define sockets mode
abstract class ModeModel {
  late bool _state;
  late int _time;
  late bool _running;

  /// Class constructor
  /// @param _state define whether socket on/off
  /// @param _time contains time to end in seconds
  /// @param _running define whether mode is on/off
  ModeModel(bool state, int time, bool running) {
    this._state = state;
    this._time = time;
    this._running = running;
  }

  bool getState() => this._state;
  int getTime() => this._time;
  String getTimeString() {
    String val = "";
    int sec = _time;
    // Get hour
    int hour = (sec ~/ 3600).toInt();
    sec -= (hour * 3600);
    // Get min
    int min = (sec ~/ 60).toInt();
    sec -= min * 60;
    // Get sec
    if(hour < 10) val += "0";
    val += "$hour:";
    if(min < 10) val += "0";
    val += "$min:";
    if(sec < 10) val += "0";
    val += sec.toString();
    return val;
  }
  bool getRunning() => this._running;
  void setState(bool state) => this._state = state;
  void setTime(int time) => this._time = time;
  void setRunning(bool running) => this._running = running;
}