import 'package:flutter/material.dart';

class RepeatScreen extends StatefulWidget {
  RepeatScreen({Key key}) : super(key: key);
  @override
  _RepeatScreen createState() => _RepeatScreen();
}

class _RepeatScreen extends State<RepeatScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Container (
        child: Text("Repeat screen"),
      ),
    );
  }
}
