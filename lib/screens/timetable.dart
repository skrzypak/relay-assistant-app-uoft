import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  TimetableScreen({Key? key}) : super(key: key);

  @override
  _TimetableScreen createState() => _TimetableScreen();
}

class _TimetableScreen extends State<TimetableScreen> {
  bool updateMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            _buildInitCard(),
            MaterialButton(
              onPressed: () {
                print("TODO:// send all new timetables");
              },
              child: Text(
                "SEND ALL UPDATES TO ESP32",
              ),
            ),
            _buildCard("usb"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("TODO:// send timetable data");
        },
        child: Icon(Icons.send),
      ),
    );
  }

  Widget  _buildInitCard() {
    return new Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Table(children: [
              TableRow(children: [
                SizedBox(
                  height: 48,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("SELECT SOCKET", style: TextStyle(
                      fontSize: 16,
                    )),
                  ),
                ),
                DropdownButton<String>(
                  value: 'FIRST'.toUpperCase(),
                  iconSize: 0,
                  elevation: 0,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  onChanged: (String? newValue) {
                    setState(() {
                      //dropdownValue = newValue;
                    });
                  },
                  items: <String>['USB', 'FIRST', 'SECOND', 'THIRD']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value.toUpperCase(),
                      child: Text(value.toUpperCase()),
                    );
                  }).toList(),
                )
              ]),
              TableRow(children: [
                SizedBox(
                  height: 48,
                  child: Align(
                    alignment: Alignment.centerLeft,
                      child: Text("SELECT DAY", style: TextStyle(
                        fontSize: 16,
                      )),
                  ),
                ),
                DropdownButton<String>(
                  value: 'MONDAY'.toUpperCase(),
                  iconSize: 0,
                  elevation: 0,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  onChanged: (String? newValue) {
                    setState(() {
                      //dropdownValue = newValue;
                    });
                  },
                  items: <String>['SUNDAY', 'MONDAY', 'TUESDAY',
                    'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value.toUpperCase(),
                      child: Text(value.toUpperCase()),
                    );
                  }).toList(),
                )
              ]),
              TableRow(children: [
                SizedBox(
                  height: 48,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("SELECT TIME", style: TextStyle(
                      fontSize: 16,
                    )),
                  ),
                ),
                InkWell(
                  onTap: () {
                    print("TODO:// timer");
                  },
                  child: SizedBox(
                    height: 48,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("00:00", style: TextStyle(
                        fontSize: 16,
                      )),
                    ),
                  ),
                ),
              ]),
              TableRow(children: [
                SizedBox(
                  height: 48,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("SELECT STATE", style: TextStyle(
                      fontSize: 16,
                    )),
                  ),
                ),
                InkWell(
                  onTap: () {
                    print("TODO:// change state icon");
                  },
                  child: SizedBox(
                    height: 48,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.power,
                        size: 45,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ]),
              TableRow(children: [
                MaterialButton(
                  child: Text("REST"),
                  onPressed: () {
                    print("TODO:// reset");
                  },
                ),
                MaterialButton(
                  child: Text("ADD"),
                  onPressed: () {
                    print("TODO:// add");
                  },
                ),
              ]),
              ],
            ),
          ],
        )
      )
    );
  }

  Widget _buildCard(String name) {
    return new Card(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    name.toUpperCase(),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              _buildDayOfWeekContent("monday"),
            ],
          )
      ),
    );
  }

  Widget _buildDayOfWeekContent(String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                name.toUpperCase(),
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
          // Record
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    print("TODO:// update timetable element");
                  },
                  child: Row(
                    children: [
                      Text(
                        "00:00",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      Icon(
                        Icons.power,
                        size: 25,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 35,
                  height: 35,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    child: Icon(
                      Icons.delete,
                      size: 25,
                      color: Colors.red,
                    ),
                    onTap: () {
                      print("TODO:// delete timetable item");
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
