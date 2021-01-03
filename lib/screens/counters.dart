import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountersScreen extends StatefulWidget {
  CountersScreen({Key key}) : super(key: key);
  @override
  _CountersScreen createState() => _CountersScreen();
}

class _CountersScreen extends State<CountersScreen> {
  int zones = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container (
        child: ListView(
          children: [
            _buildCard(true),
            _buildCard(false),
            MaterialButton(
              onPressed: () {
                print("TODO:// send all new counters");
              },
              child: Text(
                "SEND ALL UPDATES TO ESP32",
              ),
            ),
            _buildInitCard(),
            _buildInitCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(bool countdown) {
    return Card(
      child: InkWell(
        onLongPress: () => print("TODO:// delete confirmation"),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "FIRST".toUpperCase(), style: TextStyle(fontSize: 16.0),
                ),
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                TableRow(children: [
                  Center(
                    child: Icon(
                      Icons.power,
                      size: 45,
                      color: Colors.green,
                    ),
                  ),
                  Center(
                    child: Text (
                      "20:00",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 50,
                      ),
                    ),
                  ),
                ]),
              ]),
              // REPEAT TABLE DATA
              countdown == false ?
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          children: [
                            Center(
                              child: Text(
                                "REMAINING REPEATS",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                "100",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Center(
                              child: Text(
                                "CURRENT ZONE",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                "1",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                               ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          children: [
                            Center(child: Text("ZONE")),
                            Center(child: Text("COUNTDOWN")),
                          ],
                        ),
                        TableRow(
                          children: [
                            Center(child: Text("1")),
                            Center(child: Text("00:50")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ) : Text(""),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildInitCard() {
    return Opacity(
      opacity: 0.8,
      child: new Card (
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
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      Center(
                        child: Icon(
                          Icons.power,
                          size: 45,
                          color: Colors.green,
                        ),
                      ),
                      Center(
                        child: Text (
                          "00:00",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 50,
                          ),
                        ),
                      ),
                    ]),
                  ]
                ),
                // EXTRA
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // REPEATS
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: TextField(
                        decoration: new InputDecoration(
                          hintText: "REPEATS".toUpperCase(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onSubmitted: (int) {
                          print("TODO:// get repeats $int");
                        },
                      ),
                    ),
                    //TODO
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: [
                              Center(child: Text("ZONE")),
                              Center(child: Text("COUNTDOWN")),
                            ],
                          ),
                          TableRow(
                            children: [
                              Center(child: Text("1")),
                              Center(
                                child: TextField(
                                  decoration: new InputDecoration(
                                    hintText: "00:00".toUpperCase(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  onSubmitted: (int) {
                                    print("TODO:// get repeats $int");
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                MaterialButton(
                  onPressed: () {
                    print("TODO:// send new counters");
                  },
                  child: Text(
                    "SEND REQUEST TO ESP32",
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}
