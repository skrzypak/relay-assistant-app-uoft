import 'package:app/models/modes/repeat_model.dart';
import 'package:app/models/socket_state_model.dart';
import 'package:flutter/material.dart';

import 'buildCardBottomStatistic.dart';
import 'buildCardTop.dart';

Widget buildCardReadySockets(SocketStateModel data) {

  return Card(
      child: InkWell(
        onLongPress: () {
          int idx = data.index;
          print("TODO:// delete confirmation, socket $idx");
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildCardTop(data),
              // REPEAT TABLE DATA
              data.getMode() is RepeatModel
                  ? buildCardBottomStatistic(data) : Text(""),
            ],
          ),
        ),
      ));
}