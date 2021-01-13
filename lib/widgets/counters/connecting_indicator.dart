import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget connectingIndicator(AsyncSnapshot<String> snapshot) {
  String log = "";
  if(snapshot.hasData) {
    log = snapshot.data!;
  }
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Center(child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: CircularProgressIndicator(),
      )),
      Center(child: Text(log))
    ],
  );
}