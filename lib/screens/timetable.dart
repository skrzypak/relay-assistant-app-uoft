import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  TimetableScreen({Key key}) : super(key: key);

  @override
  _TimetableScreen createState() => _TimetableScreen();
}

class _TimetableScreen extends State<TimetableScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            _buildCard("monday"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("TODO:// go to page: new timetable");
        },
        child: Icon(Icons.add),
      ),
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
              SizedBox(
                width: 35,
                height: 35,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  child: Icon(
                    Icons.add,
                    size: 25.0,
                    color: Colors.blue,
                  ),
                  onTap: () {
                    print("TODO:// add new timetable item");
                  },
                ),
              ),
            ],
          )),
    );
  }
}
