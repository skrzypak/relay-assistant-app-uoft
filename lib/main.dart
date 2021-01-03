import 'package:app/screens/controller.dart';
import 'package:app/screens/counters.dart';
import 'package:app/screens/settings.dart';
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
  int _currentPageIndex = 0;
  PageController _myPage = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: PageView (
            controller: _myPage,
            onPageChanged: (int) {
              print('Page changes to index $int');
              setState(() {
                _currentPageIndex = int;
              });
            },
            children: [
              ControllerScreen(),
              CountersScreen(),
              TimetableScreen(),
              SettingsScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (int) {
              setState(() {
                _myPage.jumpToPage(int);
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.point_of_sale),
                label: 'Controller',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.av_timer),
                label: 'Counters',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.schedule),
                label: 'Timetable',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentPageIndex,
          ),
        ),
      ),
    );
  }
}
