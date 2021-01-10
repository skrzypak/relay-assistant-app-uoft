import 'package:app/pages/controller.dart';
import 'package:app/pages/counters.dart';
import 'package:app/pages/settings.dart';
import 'package:app/pages/timetable.dart';
import 'package:flutter/material.dart';
import 'package:app/blocs/esp_data_bloc.dart';

void main() async {
  await bloc.connectToEsp();
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
  HomePage({Key? key}) : super(key: key);
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
          body: StreamBuilder<Object>(
            stream: bloc.channel,
            builder: (context, AsyncSnapshot<Object?> snapshot) {
              if(snapshot.hasData && !snapshot.hasError) {
                var charCodes = snapshot.data as List<int>;
                var stream = String.fromCharCodes(charCodes);
                bloc.fetch(stream);
                return PageView (
                  controller: _myPage,
                  onPageChanged: (int) {
                    setState(() {
                      _currentPageIndex = int;
                    });
                  },
                  children: [
                    ControllerPage(),
                    CountersPage(),
                    TimetablePage(),
                    SettingsPage(),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
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
