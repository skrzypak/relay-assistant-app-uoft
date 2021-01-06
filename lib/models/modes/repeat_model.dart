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
  int getRepeats() => this._repeats;
  void setCurrentZone(int zone) => this._zone = zone;
  void setZones(List<int> zones) => this._zones = zones;
  void setRepeats(int repeats) => this._repeats = repeats;
}