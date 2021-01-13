import 'dart:convert';
import 'dart:io';

import 'package:app/models/init_counter_data_ui_.dart';
import 'package:app/models/modes/countdown_model.dart';
import 'package:app/models/timetable_form_model.dart';
import 'package:rxdart/rxdart.dart';
import '../models/esp_data_model.dart';
import '../resources/repository.dart';
import '../pages/special/storage.dart';

class EspDataBloc {
  Storage _storage = Storage();
  final _repository = Repository();

  final _controllerFetcher = PublishSubject<EspDataModel>();
  final _countersFetcher = PublishSubject<EspDataModel>();
  final _timetableFetcher = PublishSubject<EspDataModel>();
  final _reconnectingFetcher = PublishSubject<String>();

  EspDataModel _espDataModel = EspDataModel();
  Socket? _channel;
  Map? _json;

  Stream<EspDataModel> get controllerFetcher => this._controllerFetcher.stream;
  Stream<EspDataModel> get countersFetcher => this._countersFetcher.stream;
  Stream<EspDataModel> get timetableFetcher => this._timetableFetcher.stream;
  Stream<String> get reconnectingFetcher => this._reconnectingFetcher.stream;

  Socket? get channel => this._channel;

  set channel(Socket? s) {
    this._channel = s;
  }

  reconnect() async {
    String espIp =  await _storage.readEspIp();
    if(espIp == "") {
      espIp = "192.168.1.20";
      this._storage.writeEspIp(espIp);
    }
    try {
      if(this.channel != null) {
        this._channel!.close();
      }
      this._channel = null;
      this._reconnectingFetcher.sink.add("$espIp");
      this.channel = await Socket.connect(espIp, 81);
      this._reconnectingFetcher.sink.add("_");
      (this.channel!).listen(this.dataHandler,
          onError: this.errorHandler,
          cancelOnError: false
      );
    } catch(e) {
      print(e);
      await Future.delayed(Duration(seconds: 1));
      reconnect();
    }
    return;
  }

  void dataHandler(data){
    String stream = String.fromCharCodes(data);
    this.fetch(stream);
  }

  void errorHandler(error, StackTrace trace){
    print("$error");
    this.reconnect();
  }

  fetch(String stream) async {
    try {
      this._json = jsonDecode(stream);
      fetchController();
      fetchCounters();
    } catch(e) {
      print(e);
    }
  }

  fetchController() async {
    try {
      if(this._json != null) {
        for(int i = 0; i < 4 ; i++) {
          int s = int.parse(this._json!["controller"]![i.toString()]);
          bool state = s > 0 ? true : false;
          this._espDataModel.socketsDataList[i].setState(state);
        }
        this._controllerFetcher.sink.add(this._espDataModel);
      }
    } catch(e) {
      print(e);
    }
  }

  fetchCounters() async {
    try {
      if(this._json != null) {
        Map? counters = this._json!["counters"];
        for(int i = 0; i < 4 ; i++) {
          // Remove exits counter
          this._espDataModel.getSocketData(i).removeMode();
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
      this._countersFetcher.sink.add(this._espDataModel);
    } catch(e) {
      print(e);
    }
  }

  fetchGetTimetable() async {
    try{
      Map? tmp = await this._repository.fetchGetTimetable();
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
      } else if(data.numOfValidZones > 0) {
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

  fetchDeleteCounter(int index) async {
    try{
      if(this._espDataModel.getSocketData(index).getMode() is CountdownModel) {
        this._repository.fetchDeleteCountdown(index);
      } else {
        this._repository.fetchDeleteRepeat(index);
      }
    } catch(e) {
      print(e);
    }
  }

  fetchDeleteTimetable(String id) async {
    try{
      await this._repository.fetchDeleteTimetable(id);
      // TODO
      fetchGetTimetable();
    } catch(e) {
      print(e);
    }
  }

  fetchPostTimetable(TimetableForm data) async {
    try{
      Map? tmp = await this._repository.fetchPostTimetable(data.toJson());
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
    this._reconnectingFetcher.close();
    this._controllerFetcher.close();
    this._countersFetcher.close();
    this._timetableFetcher.close();
    if(this.channel != null) {
      this._channel!.close();
    }
  }

}

final bloc = EspDataBloc();