import 'package:flutter/material.dart';

class ControllerScreen extends StatefulWidget {
  ControllerScreen({Key key}) : super(key: key);
  @override
  _ControllerScreen createState() => _ControllerScreen();
}

class _ControllerScreen extends State<ControllerScreen> {
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
    List<String> _names = ['usb', 'first', 'second', 'third'];
    var _build = <Widget>[];
    _names.asMap().forEach((index, name) {
      return _build.add(
          _buildButton(name, () => (print("Click socket $index")))
      );
    });
    // ENABLE ALL
    _build.add(
        _buildButton("ENABLE", () => (print("Click enable")))
    );
    // DISABLE ALL
    _build.add(
        _buildButton("DISABLE", () => (print("Click disable")))
    );
    return _build;
  }


  Widget _buildButton(String name, Function func) =>
    new GestureDetector(
      onTap: () => func(),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(width: 1.0, color: Colors.black26),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 0),
                ),
              ]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  Icons.power_settings_new,
                  size: 45,
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
