import 'mode_model.dart';

class RepeatModel extends ModeModel {

  late int _zone;
  late List<int> _zones;
  late int _repeats;

  /// Class constructor
  /// @param state define whether socket on/off
  /// @param time contains time to end in seconds
  /// @param running define whether mode is on/off
  /// @param zone current zone
  /// @param zones list of zones (each zone contains seconds)
  /// @param repeats number repeats to end
  RepeatModel(bool state, int time, bool running, int zone,  List<int> zones, int repeats) : super(state, time, running) {
    this._zone = zone;
    this._zones = zones;
    this._repeats = repeats;
  }

  int getCurrentZone() => this._zone;
  List<int> getZones() => this._zones;
  String getStringTimeZone(int zone) {
    String val = "";
    int sec = this._zones[zone];
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
  int getRepeats() => this._repeats;
  void setCurrentZone(int zone) => this._zone = zone;
  void setZones(List<int> zones) => this._zones = zones;
  bool setRepeats(int repeats) {
    if(repeats > 0) {
      this._repeats = repeats;
      return true;
    }
    return false;
  }
}