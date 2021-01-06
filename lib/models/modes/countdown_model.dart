import 'mode_model.dart';

class CountdownModel extends ModeModel {

  /// Class constructor
  /// @param state define whether socket on/off
  /// @param time contains time to end in seconds
  /// @param running define whether mode is on/off
  CountdownModel(bool state, int time, bool running) : super(state, time, running);
}