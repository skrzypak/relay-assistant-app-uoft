import 'package:app/models/esp_data_model.dart';
import 'package:app/models/timetable_form_model.dart';
import 'package:app/pages/counters.dart';
import 'package:flutter/material.dart';

import '../blocs/esp_data_bloc.dart';
import '../models/timetable_model.dart';

class TimetablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: [
            InitTimetableCard(),
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
                    t.state!
                        ? Icon(
                            Icons.power,
                            size: 25,
                            color: Colors.green,
                          )
                        : Icon(
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

  String getDayNameFromInt(int day) {
    switch(day) {
      case 0:
        return "SUN";
      case 1:
        return "MON";
      case 2:
        return "TUE";
      case 3:
        return "WED";
      case 4:
        return "THU";
      case 5:
        return "FRI";
    }
    return "SAT";
  }
}

class InitTimetableCard extends StatefulWidget {
  InitTimetableCard({Key? key}) : super(key: key);

  @override
  _InitTimetableCard createState() => _InitTimetableCard();
}

class Item {
  const Item(this._index, this._name);
  final String _name;
  final int _index;
  String get name => this._name;
  int get index => this._index;

}

class _InitTimetableCard extends State<InitTimetableCard> {

  TimetableForm data = TimetableForm(0, 0, 0, "00:00", true);
  List<Item> names = [Item(0, 'USB'), Item(1, 'FIRST'), Item(2, 'SECOND'), Item(3, 'THIRD')];
  List<Item> dayNames = [
    Item(0, 'SUNDAY'),
    Item(1, 'MONDAY'),
    Item(2, 'TUESDAY'),
    Item(3, 'WEDNESDAY'),
    Item(4, 'THURSDAY'),
    Item(5, 'FRIDAY'),
    Item(6, 'SATURDAY'),
  ];

  void setEditMode(TimetableForm data) {
    setState(() {
      this.data = data;
    });
  }

  void setSocket(int socket) {
    setState(() {
      this.data.setSocket(socket);
    });
  }

  void setDay(int day) {
    setState(() {
      this.data.setDay(day);
    });
  }

  void setTime(String time) {
    setState(() {
      this.data.setTime(time);
    });
  }

  void toggleState() {
    setState(() {
      this.data.toggleState();
    });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context,initialTime: TimeOfDay(hour: 00, minute: 00));
    if (picked != null) {
      var hour = picked.hour;
      var min = picked.minute;
      String val = "";
      if (hour < 10) val += "0";
      val += "$hour:";
      if (min < 10) val += "0";
      val += "$min";
      setTime(val);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    DropdownButton<Item>(
                      value: this.names[this.data.socket!],
                      iconSize: 0,
                      elevation: 0,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      onChanged: (Item? value) {
                        if(value != null)
                          this.setSocket(value.index);
                      },
                      items: this.names.map<DropdownMenuItem<Item>>((Item value) {
                        return DropdownMenuItem<Item>(
                          value: value,
                          child: Text(value.name.toUpperCase()),
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
                    DropdownButton<Item>(
                      value: this.dayNames[this.data.day!],
                      iconSize: 0,
                      elevation: 0,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      onChanged: (Item? value) {
                        if(value != null)
                          this.setDay(value.index);
                      },
                      items: this.dayNames.map<DropdownMenuItem<Item>>((Item value) {
                        return DropdownMenuItem<Item>(
                          value: value,
                          child: Text(value.name.toUpperCase()),
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
                        _selectTime(context);
                      },
                      child: SizedBox(
                        height: 48,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(data.time.toString(), style: TextStyle(
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
                        this.toggleState();
                      },
                      child: SizedBox(
                        height: 48,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            this.data.state! ? Icons.power : Icons.power_off,
                            size: 45,
                            color: this.data.state! ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ]),
                  TableRow(children: [
                    MaterialButton(
                      child: Text("REST"),
                      onPressed: () {
                        setState(() {
                          this.data = TimetableForm(0, 0, 0, "00:00", true);
                        });
                      },
                    ),
                    MaterialButton(
                      child: Text("ADD"),
                      onPressed: () {
                        print("TODO:// add");
                        print(data.index);
                        print(data.socket);
                        print(data.time);
                        print(data.day);
                        print(data.state);
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
}

