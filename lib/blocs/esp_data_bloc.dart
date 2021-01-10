import 'dart:convert';
import 'dart:io';

import 'package:app/models/init_counter_data_ui_.dart';
import 'package:app/models/timetable_form_model.dart';
import 'package:rxdart/rxdart.dart';
import '../models/esp_data_model.dart';
import '../resources/repository.dart';

class EspDataBloc {
  final _repository = Repository();
  final _controllerFetcher = PublishSubject<EspDataModel>();
  final _countersFetcher = PublishSubject<EspDataModel>();
  final _timetableFetcher = PublishSubject<EspDataModel>();
  EspDataModel _espDataModel = EspDataModel();
  Socket? _channel;

  Stream<EspDataModel> get controllerFetcher => this._controllerFetcher.stream;
  Stream<EspDataModel> get countersFetcher => this._countersFetcher.stream;
  Stream<EspDataModel> get timetableFetcher => this._timetableFetcher.stream;

  Socket? get channel => this._channel;

  // TODO connection
  Future<void> connectToEsp() async {

    if(this._channel == null)
      this._channel = await Socket.connect('192.168.1.20', 81);
  }

  fetch(String stream) async {
    try {
      Map? json = jsonDecode(stream);
      //print(json);
      if(json != null) {
        Map? states = json["controller"];
        Map? counters = json["counters"];
        for(int i = 0; i < 4 ; i++) {
          int s = int.parse(states![i.toString()]);
          bool state = s > 0 ? true : false;
          this._espDataModel.socketsDataList[i].setState(state);
          // Check counters
          if(counters == null) continue;
          if(counters[i.toString()] == null) continue;
          // Counter for this socket exists
          if(counters[i.toString()]["countdown"] != null) {
            // Countdown mode
            var item = counters[i.toString()]["countdown"];
            //print(item);
            bool state = this._espDataModel.socketsDataList[i].state;
            String time = item["time"];
            this._espDataModel.socketsDataList[i].setCountdown(state, int.parse(time), true);
          } else {
            // Repeat mode
            var item = counters[i.toString()]["repeat"];
            //print(item);
            bool state = item["state"] as bool;
            int time = item["countdown"];
            int zone = item["zone"];
            List<int> zones = item["zones"].cast<int>();
            int repeats = item["repeats"];
            this._espDataModel.socketsDataList[i].setRepeat(state, time, true, zone, zones, repeats);
          }
        }
      }
    } catch(e) {
      print(e);
    }
  }

  fetchController() async {
    this._controllerFetcher.sink.add(this._espDataModel);
  }

  fetchCounters() async {
    this._countersFetcher.sink.add(this._espDataModel);
  }

  fetchGetTimetable() async {
    try{
      Map? tmp = await this._repository.fetchTimetable();
      this._espDataModel.fetchHttpGetTimetable(tmp);
      this._timetableFetcher.sink.add(this._espDataModel);
    } catch(e) {
      print(e);
    }
  }

  fetchPostCounter(InitCounterDataUi data) async {
    try {
      Map? response;

      if(data.numOfValidZones == 0) {
        response = await this._repository.fetchPostCountdown(data.toJson());
      } else if(data.numOfValidZones > 1) {
        response = await this._repository.fetchPostRepeat(data.toJson());
      }

      if(response != null) {
        List<dynamic>? jsonError = response["error"];
        if(jsonError != null) {
          // TODO err
          print(jsonError.toString());
        }
      } else print("Can't set new counter correct");
    } catch(e) {
      print(e);
    }
  }

  fetchPostTimetable(TimetableForm data) async {
    try{
      Map? tmp = await this._repository.fetchSetTimetable(data.toJson());
      if(tmp != null) {
        List<dynamic> jsonSuccess = tmp["success"];
        this._espDataModel.fetchHttpPostTimetable(jsonSuccess);
        this._timetableFetcher.sink.add(this._espDataModel);
        //TODO
        //List<dynamic> jsonError = tmp["error"];
      } else print("Some error while init new timetable");
    } catch(e) {
      print(e);
    }
  }

  fetchPostOffSocket(int num) async {
    print("fetchPostOffSocket(int $num) async");
    try {
      await this._repository.fetchPostOffSocket(num);
    } catch (e) {
      print(e);
    }
  }

  fetchPostOnSocket(int num) async {
    print("fetchPostOnSocket(int $num) async");
    try {
      await this._repository.fetchPostOnSocket(num);
    } catch (e) {
      print(e);
    }
  }

  fetchPostOffAllSockets() async {
    try {
      await this._repository.fetchPostOffAllSockets();
    } catch (e) {
      print(e);
    }

  }

  fetchPostOnAllSockets() async {
    try {
      await this._repository.fetchPostOnAllSockets();
    } catch (e) {
      print(e);
    }

  }

  dispose() {
    print("dispose()");
    this._controllerFetcher.close();
    this._countersFetcher.close();
    this._timetableFetcher.close();
    if(this.channel != null) {
      this._channel!.close();
    }
  }

}

final bloc = EspDataBloc();