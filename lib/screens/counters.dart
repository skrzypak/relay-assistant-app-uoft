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
            _buildCard(false),
            //_buildCard(true),
            _buildInitCard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("TODO:// send new counters");
        },
        child: Icon(Icons.send),
      ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        print("TODO:// switch icon");
                      },
                      child: Icon(
                        Icons.power,
                        size: 45,
                        color: Colors.green,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print("TODO:// run time picker");
                      },
                      child: Text (
                        "00:00",
                        style: TextStyle(
                          color: Colors.black12,
                          fontSize: 50,
                        ),
                      ),
                    ),
                  ],
                ),
                CheckboxListTile(
                  title: Text("REPEAT"),
                  value: true,
                  contentPadding: EdgeInsets.all(0),
                  onChanged: (newValue) {
                    setState(() {
                      //checkedValue = newValue;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                ),
                // EXTRA
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ZONE
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: TextField(
                        decoration: new InputDecoration(
                            labelText: "ZONE 1".toUpperCase(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onSubmitted: (int) {
                          print("TODO:// add zone $int");
                        },
                      ),
                    ),
                    // REPEATS
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: TextField(
                        decoration: new InputDecoration(
                            labelText: "REPEATS".toUpperCase(),
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
      ),
    );
  }

  Widget _buildCard(bool countdown) {
    return new Card (
      child: InkWell(
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
                        fontSize: 50,
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
                                        fontSize: 20,
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
                                        fontSize: 20,
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
