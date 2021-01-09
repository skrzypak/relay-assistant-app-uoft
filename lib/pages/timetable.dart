import 'package:app/models/esp_data_model.dart';
import 'package:flutter/material.dart';
import '../blocs/esp_data_bloc.dart';
import '../models/timetable_model.dart';

class TimetablePage extends StatefulWidget {
  TimetablePage({Key? key}) : super(key: key);

  @override
  _TimetablePage createState() => _TimetablePage();
}

class _TimetablePage extends State<TimetablePage> {
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
            SingleChildScrollView(
              physics: ScrollPhysics(),
              child: StreamBuilder(
                stream: bloc.timetableFetcher,
                builder: (context, AsyncSnapshot<EspDataModel> snapshot) {
                  if (snapshot.hasData) {
                    return _buildSocketsList(snapshot);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    bloc.fechTimetable();
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
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

  Widget _buildSocketsList(AsyncSnapshot<EspDataModel> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.socketsDataList.length,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
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
                        snapshot.data!.getSocketData(index).name.toString().toUpperCase(),
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  _buildCardWeek(snapshot.data!.getSocketData(index).dayOfWeekTimetable),
                ],
              )
          ),
        );
      },
    );
  }

  Widget _buildCardWeek(Map<int, List<Timetable>> dayOfWeekTimetables) {
    var keys = dayOfWeekTimetables.keys.toList();

    return ListView.builder(
      itemCount: dayOfWeekTimetables.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        List<Timetable> val = dayOfWeekTimetables[keys[index]]!;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    getDayNameFromInt(keys[index]).toUpperCase(),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              // Record
              _buildDayOfWeekContent(val),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDayOfWeekContent(List<Timetable> timetables) {
    return ListView.builder(
      itemCount: timetables.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        Timetable t = timetables[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  print("TODO:// update timetable element");
                  var idx = t.index;
                  var socket = t.socket;
                  var day = t.day;
                  var time = t.time;
                  print("index $idx");
                  print("socket $socket");
                  print("day $day");
                  print("time $time");
                },
                child: Row(
                  children: [
                    Text(
                      t.time.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    t.state ?
                    Icon(
                      Icons.power,
                      size: 25,
                      color: Colors.green,
                    ) :
                    Icon(
                      Icons.power_off,
                      size: 25,
                      color: Colors.red,
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
                    var idx = t.index;
                    var socket = t.socket;
                    var day = t.day;
                    var time = t.time;
                    print("index $idx");
                    print("socket $socket");
                    print("day $day");
                    print("time $time");
                  },
                ),
              ),
            ],
          ),
        );
      },

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

  String getDayNameFromInt(int day) {
    switch(day) {
      case 0: return "SUN";
      case 1: return "MON";
      case 2: return "TUE";
      case 3: return "WED";
      case 4: return "THU";
      case 5: return "FRI";
    }
    return "SAT";
  }
}
