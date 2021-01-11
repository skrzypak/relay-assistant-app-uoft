import 'dart:core';

import 'package:app/models/esp_data_model.dart';
import 'package:app/models/init_counter_data_ui_.dart';
import 'package:app/models/socket_state_model.dart';
import 'package:app/widgets/counters/buildCardReadySockets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../blocs/esp_data_bloc.dart';
import '../models/modes/mode_model.dart';
import '../models/socket_state_model.dart';

class CountersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
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
        ],
      )),
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
          return new CardInitSocket(snapshot.data!.getSocketData(index));
        else
          return buildCardReadySockets(snapshot.data!.getSocketData(index));
      },
    );
  }
}

class CardInitSocket extends StatefulWidget {
  final SocketStateModel? tmp;

  CardInitSocket(SocketStateModel socketData, {Key? key})
      : tmp = socketData,
        super(key: key);

  @override
  _CardInitSocket createState() => _CardInitSocket(tmp!.index, tmp!.name);
}

class _CardInitSocket extends State<CardInitSocket> {

  Widget? _timePickerSpinner;
  int _currentZone = 0;
  bool _reloadTimePickerSpinner = false;
  InitCounterDataUi? _initCounterData;

  _CardInitSocket(int index, String name) {
    _initCounterData = InitCounterDataUi(index, name);
    this._timePickerSpinner = _buildInitTime();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: new Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildCardTop(),
              this._initCounterData!.numOfValidZones > 0 ?
              _buildCardBottomForm() :
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: () {
                    bloc.fetchPostCounter(this._initCounterData!);
                  },
                  child: Text(
                    "SEND REQUEST TO ESP32",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardTop() {
    return Container(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.tmp!.name.toUpperCase(),
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    Center(
                        child:
                        InkWell(
                          onTap: () {
                            setState(() {
                              this._initCounterData!.toggleState();
                            });
                          },
                          child: Icon(
                            this._initCounterData!.state ? Icons.power : Icons
                                .power_off,
                            size: 45,
                            color: Colors.black,
                          ),
                        )
                    ),
                    InkWell(
                      onDoubleTap: () {
                        if (_reloadTimePickerSpinner == false) {
                          setState(() {
                            this._currentZone++;
                            this._initCounterData!.addZone(DateTime(
                                2000, 1, 1, 0, 0, 0));
                            this._timePickerSpinner = _buildInitTime();
                          });
                        } else {
                          setState(() {
                            this._reloadTimePickerSpinner = false;
                            this._currentZone = this._initCounterData!.length -
                                1;
                            this._timePickerSpinner = _buildInitTime();
                          });
                        }
                      },
                      child: this._timePickerSpinner != null ? this
                          ._timePickerSpinner : Text(
                          ""),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildInitTime() {
    DateTime _time = this._initCounterData!.getZone(this._currentZone);
    return new TimePickerSpinner(
        key: UniqueKey(),
        is24HourMode: true,
        spacing: 5,
        time: _time,
        itemHeight: 30,
        isForce2Digits: true,
        isShowSeconds: true,
        minutesInterval: 1,
        onTimeChange: (time) {
          if (time.hour > 0 || time.minute > 0 || time.second > 0)
            setState(() {
              this._initCounterData!.updateZone(this._currentZone, time);
            });
        }
    );
  }

  Widget _buildCardBottomForm() {
    return Container(
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                decoration: new InputDecoration(
                  labelText: "REPEATS (0=>1)".toUpperCase(),
                  hintText: this._initCounterData!.repeats.toString(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onSubmitted: (rep) {
                  setState(() {
                    this._initCounterData!.setRepeat(int.parse(rep));
                  });
                },
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 18.0, left: 8.0, right: 8.0, bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                          child: Text("ZONE")
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text("COUNTDOWN"),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                itemCount: this._initCounterData!.numOfValidZones,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        this._reloadTimePickerSpinner = true;
                        this._currentZone = index;
                        this._timePickerSpinner = _buildInitTime();
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        this._initCounterData!.removeZone(index);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(
                                child: Text(index.toString())
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: (() {
                                String val = "";
                                int hour = this._initCounterData!
                                    .getZone(index)
                                    .hour;
                                int min = this._initCounterData!
                                    .getZone(index)
                                    .minute;
                                int sec = this._initCounterData!
                                    .getZone(index)
                                    .second;
                                if (hour < 10) val += "0";
                                val += "$hour:";
                                if (min < 10) val += "0";
                                val += "$min:";
                                if (sec < 10) val += "0";
                                val += sec.toString();
                                return Text(val);
                              }()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          MaterialButton(
            onPressed: () {
                bloc.fetchPostCounter(this._initCounterData!);
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
