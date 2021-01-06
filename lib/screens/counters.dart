import 'package:app/models/esp_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/models/socket_state_model.dart';
import '../models/socket_state_model.dart';
import '../models/modes/mode_model.dart';
import '../models/modes/repeat_model.dart';
import '../blocs/esp_data_bloc.dart';

class CountersScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child: StreamBuilder(
                    stream: bloc.countersFetcher,
                    builder: (context, AsyncSnapshot<EspDataModel> snapshot) {
                      if (snapshot.hasData) {
                        return _buildList(snapshot);
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        bloc.fetchCounters();
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                bloc.fetchEspData();
                print("TODO:// send all new counters");
              },
              child: Text(
                "SEND ALL UPDATES TO ESP32",
              ),
            ),
            ],
          )
      ),
    );
  }

  Widget _buildList(AsyncSnapshot<EspDataModel> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.socketsDataList.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
          ModeModel? mode = snapshot.data!.getSocketData(index).getMode();
        if (mode == null)
          return _buildCardInitSocket(snapshot.data!.getSocketData(index));
        else
          return _buildCardReadySockets(snapshot.data!.getSocketData(index));
      },
    );
  }

  Widget _buildCardTop(SocketStateModel data) {
    return Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                data.name.toUpperCase(),
                style: TextStyle(fontSize: 16.0),
          ),
        ),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Center(
                  child: Icon(
                    ((){
                      ModeModel? m = data.getMode();
                      if (m == null) {
                        return Icons.power;
                      } else {
                        return m.getState() ? Icons.power : Icons.power_off;
                      }
                    }()),
                    size: 45,
                    color: ((){
                      ModeModel? m = data.getMode();
                      if (m == null) {
                        return Colors.black;
                      } else {
                        return m.getState() ? Colors.green : Colors.red;
                      }
                    }()),
                  ),
                ),
                Center(
                  child: Text(
                    ((){
                      ModeModel? m = data.getMode();
                      if (m == null) {
                        return "00:00";
                      } else
                        return m.getTimeString();
                    }()),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ));
  }

  Widget _buildCardBottomStatistic(SocketStateModel data) {
    return Column(
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
                          fontWeight: FontWeight.bold, color: Colors.black),
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
                          fontWeight: FontWeight.bold, color: Colors.black),
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
    );
  }

  Widget _buildCardReadySockets(SocketStateModel data) {
    return Card(
        child: InkWell(
      onLongPress: () {
        print("TODO:// delete confirmation, send request to esp32");
        //setState(() => this._socketStateList[index].removeMode());
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildCardTop(data),
            // REPEAT TABLE DATA
            data.getMode() is RepeatModel
                ? _buildCardBottomStatistic(data) : Text(""),
          ],
        ),
      ),
    ));
  }

  Widget _buildCardInitSocket(SocketStateModel data) {
    return Opacity(
      opacity: 0.5,
      child: new Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildCardTop(data),
              // EXTRA
              _buildCardBottomForm(data),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardBottomForm(SocketStateModel data) {
    return Container(
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // REPEATS
              SizedBox(
                //width: MediaQuery.of(context).size.width * 0.85,
                width: 250,
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
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
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
    );
  }
}
