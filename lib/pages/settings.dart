import 'package:app/blocs/esp_data_bloc.dart';
import 'package:flutter/material.dart';

import './special/storage.dart';

class SettingsPage extends StatefulWidget {
  final Storage _storage = Storage();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {

  String _currentIp = "";
  var _ipController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  late List<bool> _isSwitched = this._isSwitched = List.generate(4, (index) => false);

  _SettingsPage()  {
    _fetchSocketsStateStartup();
  }

  void _fetchSocketsStateStartup() {
    bloc.fetchGetStartupSocketsStates().then((Map? value) {
      if(value != null && value.length > 0) {
        for(int i = 0; i < 4; i++) {
          String state = value[i.toString()]["state"];
          if(state.compareTo("1") == 0) {
            setState(() {
              this._isSwitched[i] = true;
            });
          }
        }
      } else {
        var snackBar = SnackBar(
          content: Text("Can't fetch startup sockets states"),
          duration: Duration(seconds: 3),
        );
        this.scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
      }
    });
  }

  void setIpAndReconnect(String ip) async {
    await widget._storage.writeEspIp(ip).then((value) => {
          setState(() {
            _currentIp = ip;
          }),
        });

    widget._refreshIndicatorKey.currentState!.show();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScaffoldMessenger(
        key: this.scaffoldMessengerKey,
        child: Scaffold(
          body: RefreshIndicator(
            key: widget._refreshIndicatorKey,
            onRefresh: () async {
              await bloc.reconnect();
              _fetchSocketsStateStartup();
            },
            child: Stack(
              children: [
                ListView(),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Card(
                          child: TextField(
                            controller: _ipController,
                            onSubmitted: (text) => this.setIpAndReconnect(text),
                            autofocus: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: _currentIp,
                              prefixIcon: Icon(
                                Icons.developer_board,
                                size: 28.0,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () => _ipController.clear(),
                                icon: Icon(
                                  Icons.clear,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(top: 16, bottom: 4),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text("SOCKET STATE ON STARTUP")),
                          ),
                        ),
                      ),
                      Container(
                        child: Table(
                          children: _buildSettingsSwitch(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _buildSettingsSwitch() {
    var _build = <TableRow>[];

    for (int i = 0; i < bloc.espDataModel.socketsDataList.length; i += 2) {
      _build.add(TableRow(
        children: [
          _buildSwitchCard(i, bloc.espDataModel.socketsDataList[i].name),
          _buildSwitchCard(i+1, bloc.espDataModel.socketsDataList[i+1].name),
        ],
      ));
    }

    return _build;
  }

  Widget _buildSwitchCard(int index, String name) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(name.toUpperCase()),
            Switch(
              value: this._isSwitched[index],
              onChanged: (value) async {
                bool result = await bloc.fetchPutStartupSocketStates(index, value);
                if(result == true) {
                  setState(() {
                    this._isSwitched[index] = value;
                  });
                } else {
                  var snackBar = SnackBar(
                    content: Text("Can't update startup state, check connection"),
                    duration: Duration(seconds: 3),
                  );
                  this.scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
                }
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget._storage.readEspIp().then((String value) {
      print(value);
      setState(() {
        _currentIp = value;
      });
    });
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }
}

