import 'package:app/screens/controller.dart';
import 'package:app/screens/countdown.dart';
import 'package:app/screens/repeat.dart';
import 'package:app/screens/timetable.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Power Strip Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    ControllerScreen(),
    CountdownScreen(),
    RepeatScreen(),
    TimetableScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (int idx) {
              setState(() {
                _currentIndex = idx;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.point_of_sale),
                label: 'Controller',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.av_timer),
                label: 'Countdown',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.repeat),
                label: 'Repeat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.schedule),
                label: 'Timetable',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
          ),
        ),
      ),
    );
  }
}
