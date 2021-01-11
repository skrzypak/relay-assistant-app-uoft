import 'package:app/models/modes/repeat_model.dart';
import 'package:app/models/socket_state_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildCardBottomStatistic(SocketStateModel data) {
  RepeatModel dataMode = data.getMode()! as RepeatModel;
  final zonesTable = <TableRow>[];
  zonesTable.add(TableRow(
    children: [
      Center(child: Text("ZONE")),
      Center(child: Text("COUNTDOWN")),
    ],
  ));
  var zonesList =  dataMode.getZones();
  for (int i = 0; i < zonesList.length; i++) {
    zonesTable.add(TableRow(
      children: [
        Center(child: Text((i+1).toString())),
        Center(child: Text(dataMode.getStringTimeZone(i))),
      ],
    ));
  }
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
                    dataMode.getRepeats().toString(),
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
                    (dataMode.getCurrentZone()+1).toString(),
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
          children: zonesTable,
        ),
      ),
    ],
  );
}