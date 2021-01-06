import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);
  @override
  _SettingsScreen createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen> {
  String _currentIp = "192.168.1.23";
  String _value = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container (
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 250,
                    child: TextField (
                      onChanged: (text) {
                        _value = text;
                      },
                      autofocus: false,
                      decoration: InputDecoration(
                      border: InputBorder.none,
                          hintText: _currentIp
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      child: Icon(
                        Icons.save,
                        size: 25,
                        color: Colors.black,
                      ),
                      onTap: () {
                        setState(() {
                          _currentIp = _value;
                        });
                        print("TODO:// update ip $_value");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
