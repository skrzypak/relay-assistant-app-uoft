import 'package:flutter/material.dart';

class ControllerScreen extends StatefulWidget {
  ControllerScreen({Key key}) : super(key: key);
  final Map<String, int> _sockets = {
    "USB": 0,
    "FIRST": 1,
    "SECOND": 2,
    "THIRD": 3
  };
  @override
  _ControllerScreen createState() => _ControllerScreen();
}

class _ControllerScreen extends State<ControllerScreen> {
  List<bool> _socketState = List.generate(4, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: GridView.count(
        primary: true,
        padding: const EdgeInsets.all(15.0),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        crossAxisCount: 2,
        children: _buildHomeSocketsButtons(),
      ),
    );
  }

  List<Widget> _buildHomeSocketsButtons() {
    var _build = <Widget>[];
    widget._sockets.forEach((key, value) {
      return _build.add(
          _buildButton(key, value, () {
            print("Click socket $value");
            // TODO TEST ONLY
            setState(() {
              _socketState[value] = ! _socketState[value];
            });
          }));
    });
    // DISABLE ALL
    _build.add(
        _buildButton("DISABLE", -1, () {
          print("Click disable");
          // TODO TEST ONLY
          setState(() {
            for(int i = 0; i < _socketState.length; i++)
              _socketState[i] = false;
          });
        })
    );
    // ENABLE ALL
    _build.add(
        _buildButton("ENABLE", -1, () {
          print("Click enable");
          // TODO TEST ONLY
          setState(() {
            for(int i = 0; i < _socketState.length; i++)
              _socketState[i] = true;
          });
        })
    );
    return _build;
  }


  Widget _buildButton(String name, int index, Function func) =>
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: (() {
              if(name == "ENABLE")
                return Border.all(width: 1.0, color: Colors.green);
              else if(name == "DISABLE")
                return Border.all(width: 1.0, color: Colors.red);
              else return Border.all(width: 1.0, color: Colors.black12);
            }()),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 0),
              ),
            ]
        ),
        child: InkWell(
          onTap: () => func(),
          onDoubleTap: () => print("TODO:// Set counters"),
          onLongPress: () => print("TODO:// Set timetable"),
          borderRadius: BorderRadius.circular(90),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: () {
                  if((index >= 0 && _socketState[index]) || name == "ENABLE") {
                    return Icon(
                      Icons.power,
                      size: 45,
                      color: Colors.green,
                    );
                  } else {
                    return Icon(
                      Icons.power_off,
                      size: 45,
                      color: Colors.red,
                    );
                  }
                }(),
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
