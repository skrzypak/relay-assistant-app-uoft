import 'package:app/models/esp_data_model.dart';
import 'package:app/models/socket_state_model.dart';
import 'package:flutter/material.dart';

import '../blocs/esp_data_bloc.dart';

class ControllerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: bloc.controllerFetcher,
              builder: (context, AsyncSnapshot<EspDataModel> snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  return GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(15.0),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    crossAxisCount: 2,
                    children: _buildHomeSocketsButtons(snapshot),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  bloc.fetchController();
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHomeSocketsButtons(AsyncSnapshot<EspDataModel> snapshot) {
    var _build = <Widget>[];

    for (int i = 0; i < 4; i++) {
      _build.add(_buildButton(snapshot.data!.getSocketData(i)));
    }

    _build.add(_buildButtonStatic("DISABLE",  () => bloc.fetchPostOffAllSockets()));
    _build.add(_buildButtonStatic("ENABLE", () => bloc.fetchPostOnAllSockets()));

    return _build;
  }

  Widget _buildButton(SocketStateModel socketStateModel) =>
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 1.0, color: Colors.black12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                ),
              ]),
          child: InkWell(
            onTap: () {
              var index = socketStateModel.index;
              socketStateModel.state ?
                bloc.fetchPostOffSocket(index) : bloc.fetchPostOnSocket(index);
            },
            onDoubleTap: () => print("TODO:// Set counters"),
            onLongPress: () => print("TODO:// Set timetable"),
            borderRadius: BorderRadius.circular(90),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: socketStateModel.state ?
                  Icon(
                    Icons.power,
                    size: 45,
                    color: Colors.green,
                  ) : Icon(
                    Icons.power_off,
                    size: 45,
                    color: Colors.red,
                  ),
                ),
                Text(
                  socketStateModel.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildButtonStatic(String name, Function func) =>
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: name == "ENABLE" ?
                Border.all(width: 1.0, color: Colors.green) :
                Border.all(width: 1.0, color: Colors.red),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                ),
              ]),
          child: InkWell(
            onTap: () {
              func();
            },
            onDoubleTap: () => print("TODO:// Set counters"),
            onLongPress: () => print("TODO:// Set timetable"),
            borderRadius: BorderRadius.circular(90),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: name == "ENABLE" ?
                  Icon(
                    Icons.power,
                    size: 45,
                    color: Colors.green,
                  ) : Icon(
                    Icons.power_off,
                    size: 45,
                    color: Colors.red,
                  ),
                ),
                Text(
                  name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
