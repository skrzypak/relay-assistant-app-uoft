import 'package:flutter/material.dart';

class CountersScreen extends StatefulWidget {
  CountersScreen({Key key}) : super(key: key);
  @override
  _CountersScreen createState() => _CountersScreen();
}

class _CountersScreen extends State<CountersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container (
        child: ListView(
          children: [
            _buildCard(false),
            _buildCard(true),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("TODO:// go to page: new counter");
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildCard(bool countdown) {
    return new Card (
      child: GestureDetector(
        onLongPress: () => print("TODO:// delete confirmation"),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column (
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "FIRST".toUpperCase(), style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.power,
                      size: 45,
                      color: Colors.green,
                    ),
                    Text (
                      "20:00",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 75,
                      ),
                    ),
                  ],
                ),
                countdown == false ?
                  new SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text("1", style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                     ),
                                    ),
                                    Text("ZONE", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("100", style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Text("REMAINING LOOPS", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("ZONE 1 STATE OFF COUNTDOWN 00:05 "),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text("ZONE 2 STATE ON COUNTDOWN 00:50 "),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                    : Text(""),
              ],
            )
        ),
      ),
    );
  }

}
