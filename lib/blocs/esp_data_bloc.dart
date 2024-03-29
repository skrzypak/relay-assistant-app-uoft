import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app/models/init_counter_data_ui_.dart';
import 'package:app/models/modes/countdown_model.dart';
import 'package:app/models/timetable_form_model.dart';
import 'package:rxdart/rxdart.dart';

import '../models/esp_data_model.dart';
import '../pages/special/storage.dart';
import '../resources/repository.dart';

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
  int _handlerPongSeconds = 0;
  Timer? _handlerTimerInc;
  String _currentPowerStripIp = "";

  Stream<EspDataModel> get controllerFetcher => this._controllerFetcher.stream;

  Stream<EspDataModel> get countersFetcher => this._countersFetcher.stream;

  Stream<EspDataModel> get timetableFetcher => this._timetableFetcher.stream;

  Stream<String> get reconnectingFetcher => this._reconnectingFetcher.stream;

  Socket? get channel => this._channel;

  Storage get storage => this._storage;

  EspDataModel get espDataModel => this._espDataModel;

  String get currentPowerStripIp => this._currentPowerStripIp;

  set channel(Socket? s) {
    this._channel = s;
  }

  _remakeTimer() {
    if(this._handlerTimerInc != null) {
      this._handlerTimerInc!.cancel();
    }
    this._handlerPongSeconds = 0;
    this._handlerTimerInc = new Timer.periodic(new Duration(seconds: 1), (_) {
      this._handlerPongSeconds++;
      if(this._handlerPongSeconds == 4) {
        print("Do reconnect()");
        this._handlerTimerInc!.cancel();
        this._handlerPongSeconds = 0;
        this.reconnect();
      }
    });
  }

  reconnect() async {
    try {
      if (this._channel != null) {
        this._channel!.close();
        this._channel = null;
      }

      this._currentPowerStripIp = await _storage.readEspIp();
      this._reconnectingFetcher.sink.add("${this._currentPowerStripIp}");
      this._channel = await Socket.connect(this._currentPowerStripIp, 81);
      this._reconnectingFetcher.sink.add("_");

      _remakeTimer();

      (this.channel!).listen(this.dataHandler,
          onError: this.errorHandler, cancelOnError: false);
    } catch(e) {
      print(e);
      await Future.delayed(Duration(seconds: 1));
      reconnect();
    }
    return;
  }

  void dataHandler(data){
    String stream = String.fromCharCodes(data);
    this._handlerPongSeconds = 0;
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
        List<dynamic>? jsonSuccess = tmp["success"];
        this._espDataModel.fetchHttpPostTimetable(jsonSuccess);
        this._timetableFetcher.sink.add(this._espDataModel);
        List<dynamic>? jsonError = tmp["error"];
        if(jsonError == null) return;
        else {
          String msg = jsonError[0]["msg"];
          if(msg.compareTo("This socket, day and time already exists in database") == 0) {
            throw(0);
          }
        }
      }
      throw("FATAL ERROR, CHECK CONNECTION");
    } catch(e) {
      throw(e);
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

  Future<Map?> fetchGetStartupSocketsStates() async {
    try{
      Map? item = await this._repository.fetchGetStartupSocketsStates();
      return item;
    } catch(e) {
      print(e);
      return null;
    }
  }

  Future<bool> fetchPutStartupSocketStates(int index, bool state) async {
    try{
      await this._repository.fetchPutStartupSocketStates(index, state);
      return true;
    } catch(e) {
      print(e);
      return false;
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
      this._channel = null;
    }
  }

}

final bloc = EspDataBloc();