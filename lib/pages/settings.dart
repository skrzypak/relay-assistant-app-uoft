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

  void setIpAndReconnect(String ip) async {
    await widget._storage.writeEspIp(ip).then((value) =>
    {
      setState(() {
        _currentIp = ip;
      }),
    });

    widget._refreshIndicatorKey.currentState!.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: widget._refreshIndicatorKey,
        onRefresh: () => bloc.reconnect(),
        child: Stack(
          children: [
            ListView(),
            Container(
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.95,
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
                ),
              ),
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

