import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  TimetableScreen({Key key}) : super(key: key);
  @override
  _TimetableScreen createState() => _TimetableScreen();
}

class _TimetableScreen extends State<TimetableScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Container (
        child: Text("Timetable screen"),
      ),
    );
  }
}
