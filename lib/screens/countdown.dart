import 'package:flutter/material.dart';

class CountdownScreen extends StatefulWidget {
  CountdownScreen({Key key}) : super(key: key);
  @override
  _CountdownScreen createState() => _CountdownScreen();
}

class _CountdownScreen extends State<CountdownScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Container (
        child: Text("Countdown screen"),
      ),
    );
  }
}
