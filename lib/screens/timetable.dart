import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  TimetableScreen({Key key}) : super(key: key);
  @override
  _TimetableScreen createState() => _TimetableScreen();
}

class _TimetableScreen extends State<TimetableScreen> {
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  @override
  Widget build(BuildContext context) {
    Future<TimeOfDay> _selectTime(BuildContext context) async {
      final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        setState(() {
          selectedTime = picked;
        });
        print(picked.toString());
      }
      return picked;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Container (
        child: Align(
          alignment: AlignmentDirectional.bottomEnd,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: FloatingActionButton(
              onPressed: () {
                print("TODO://_TimetableScreen::FloatingActionButton");
                _selectTime(context);
              },
              child: Text(
                "+",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              backgroundColor: Colors.blue,
            ),
          ),
        )
      ),
    );
  }
}
