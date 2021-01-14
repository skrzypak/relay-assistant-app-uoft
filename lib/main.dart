import 'package:app/blocs/esp_data_bloc.dart';
import 'package:app/pages/controller.dart';
import 'package:app/pages/counters.dart';
import 'package:app/pages/settings.dart';
import 'package:app/pages/timetable.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
  String espIp =  await bloc.storage.readEspIp();
  if(espIp == "") {
    espIp = "192.168.1.20";
    await bloc.storage.writeEspIp(espIp);
  }
  bloc.reconnect();
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
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  int _currentPageIndex = 0;
  String _lastIpReconnection = "";
  PageController _myPage = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _connection();
  }

  void _connection() async {

    bloc.reconnectingFetcher.listen((ip) async {
      if(ip.compareTo("_") == 0) {
        print("Connect");
        this._lastIpReconnection = "";
        this.scaffoldMessengerKey.currentState!.removeCurrentSnackBar();
      } else if(_lastIpReconnection.compareTo(ip) != 0) {
          this.scaffoldMessengerKey.currentState!.removeCurrentSnackBar();
          this._lastIpReconnection = ip;
          var snackBar = SnackBar(
            content: Text("Connect to: ${this._lastIpReconnection}"),
            duration: Duration(days: 365),
          );
          this.scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
        }
    }, cancelOnError: false, onError: (e) => print(e));

  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: this.scaffoldMessengerKey,
      child: Scaffold(
        body: PageView(
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
    );
  }
}
