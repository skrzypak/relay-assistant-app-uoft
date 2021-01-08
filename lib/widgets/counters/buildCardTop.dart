import 'package:app/models/socket_state_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildCardTop(SocketStateModel data) {
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
                    data.getMode()!.getState() ? Icons.power : Icons.power_off,
                    size: 45,
                    color:
                        data.getMode()!.getState() ? Colors.green : Colors.red),
              ),
              Center(
                child: Text(
                  data.getMode()!.getTimeString(),
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
