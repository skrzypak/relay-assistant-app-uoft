import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountersScreen extends StatefulWidget {
  CountersScreen({Key key}) : super(key: key);
  @override
  _CountersScreen createState() => _CountersScreen();
}

/// Abstract class define sockets mode
abstract class Mode {
  bool _state;
  int _time;
  bool _running;

  /// Class constructor
  /// @param _state define whether socket on/off
  /// @param _time contains time to end in seconds
  /// @param _running define whether mode is on/off
  Mode(bool state, int time, bool running) {
    this._state = state;
    this._time = time;
    this._running = running;
  }

  bool getState() => this._state;
  int getTime() => this._time;
  String getTimeString() {
    String res = "";
    res = _time.toString();
    return res;
  }
  bool getRunning() => this._running;
  void setState(bool state) => this._state = state;
  void setTime(int time) => this._time = time;
  void setRunning(bool running) => this._running = running;
}

class Countdown extends Mode {

  /// Class constructor
  /// @param state define whether socket on/off
  /// @param time contains time to end in seconds
  /// @param running define whether mode is on/off
  Countdown(bool state, int time, bool running) : super(state, time, running);
}

class Repeat extends Mode {

  int _zone;
  List<int> _zones;
  int _repeats;
  /// Class constructor
  /// @param state define whether socket on/off
  /// @param time contains time to end in seconds
  /// @param running define whether mode is on/off
  /// @param zone current zone
  /// @param zones list of zones (each zone contains seconds)
  /// @param repeats number repeats to end
  Repeat(bool state, int time, bool running, int zone,  List<int> zones, int repeats) : super(state, time, running) {
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

/// Class contain sockets data
class SocketData {
  int _index;
  String _name;
  Mode _mode;

  /// Class constructor
  /// @param _index socket index
  /// @param _name socket name
  SocketData(int _index, String _name) {
    this._index = _index;
    this._name = _name;
    this._mode = null;
  }

  void setRepeat(bool state, int time, bool running, int zone,  List<int> zones, int repeats)
    => this._mode = new Repeat(state, time, running, zone, zones, repeats);
  void setCountdown(bool state, int time, bool running)
    => this._mode = new Countdown(state, time, running);
  void removeMode() => this._mode = null;
  Mode getMode() => this._mode;
  int getIndex() => this._index;
  String getName() => this._name;
}

class _CountersScreen extends State<CountersScreen> {
  List<SocketData> _socketData = [
    SocketData(0, "USB"),
    SocketData(1, "FIRST"),
    SocketData(2, "SECOND"),
    SocketData(3, "THIRD"),
  ];

  @override
  Widget build(BuildContext context) {
    setState(() => this._socketData[0].setCountdown(true, 100, true));
    setState(() => this._socketData[1].setRepeat(false, 1000, true, 1, [10, 20, 30], 3));
    setState(() => this._socketData[3].setCountdown(false, 1000, true));
    return Scaffold(
      body: Container (
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: this._socketData.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Mode mode = this._socketData[index].getMode();
                    if(mode == null)
                      return _buildCardInitSocket(index);
                    else return _buildCardReadySockets(index);
                  },
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                setState(() => this._socketData[0].removeMode());
                print("TODO:// send all new counters");
              },
              child: Text(
                "SEND ALL UPDATES TO ESP32",
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget _buildCardTop(int index) {
    return Container(
        child: Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            this._socketData[index].getName().toUpperCase(),
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Center(
                  child: Icon(
                    ((){
                      Mode m = this._socketData[index].getMode();
                      if(m == null) {
                        return Icons.power;
                      } else {
                        return m.getState() ? Icons.power : Icons.power_off;
                      }
                    }()),
                    size: 45,
                    color: ((){
                      Mode m = this._socketData[index].getMode();
                      if(m == null) {
                        return Colors.black;
                      } else {
                        return m.getState() ? Colors.green : Colors.red;
                      }
                    }()),
                  ),
                ),
                Center(
                  child: Text(
                    ((){
                      Mode m = this._socketData[index].getMode();
                      if(m == null) {
                        return "00:00";
                      } else return m.getTimeString();
                    }()),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ));
  }

  Widget _buildCardBottomStatistic(int index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  Center(
                    child: Text(
                      "REMAINING REPEATS",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  Center(
                    child: Text(
                      "100",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Center(
                    child: Text(
                      "CURRENT ZONE",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  Center(
                    child: Text(
                      "1",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  Center(child: Text("ZONE")),
                  Center(child: Text("COUNTDOWN")),
                ],
              ),
              TableRow(
                children: [
                  Center(child: Text("1")),
                  Center(child: Text("00:50")),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardReadySockets(int index) {
    return Card(
        child: InkWell(
      onLongPress: () {
        print("TODO:// delete confirmation, send request to esp32");
        setState(() => this._socketData[index].removeMode());
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildCardTop(index),
            // REPEAT TABLE DATA
            this._socketData[index].getMode() is Repeat
                ? _buildCardBottomStatistic(index) : Text(""),
          ],
        ),
      ),
    ));
  }

  Widget _buildCardInitSocket(int index) {
    return Opacity(
      opacity: 0.5,
      child: new Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildCardTop(index),
              // EXTRA
              _buildCardBottomForm(index),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardBottomForm(int index) {
    return Container(
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // REPEATS
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                  decoration: new InputDecoration(
                    hintText: "REPEATS".toUpperCase(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onSubmitted: (int) {
                    print("TODO:// get repeats $int");
                  },
                ),
              ),
              //TODO
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        Center(child: Text("ZONE")),
                        Center(child: Text("COUNTDOWN")),
                      ],
                    ),
                    TableRow(
                      children: [
                        Center(child: Text("1")),
                        Center(
                          child: TextField(
                            decoration: new InputDecoration(
                              hintText: "00:00".toUpperCase(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onSubmitted: (int) {
                              print("TODO:// get repeats $int");
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          MaterialButton(
            onPressed: () {
              print("TODO:// send new counters");
            },
            child: Text(
              "SEND REQUEST TO ESP32",
            ),
          ),
        ],
      ),
    );
  }
}
