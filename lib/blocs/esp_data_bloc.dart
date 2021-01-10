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
  EspDataModel? _espDataModel;
  Socket? _socket;

  Stream<EspDataModel> get controllerFetcher => this._controllerFetcher.stream;
  Stream<EspDataModel> get countersFetcher => this._countersFetcher.stream;
  Stream<EspDataModel> get timetableFetcher => this._timetableFetcher.stream;

  Socket? get socket => this._socket;

  // TODO connection
  Future<bool> connectToEsp() async {
    if(this.socket == null) {
      //this._socket = await Socket.connect('192.168.1.20', 80);
      return true;
    }
    return false;
  }

  Future<bool> fetchEspData() async {
    bool status = await connectToEsp();
    if(status) {
      print("EspData generate...");
      _espDataModel = await this._repository.fetchEspData();
      this._controllerFetcher.sink.add(this._espDataModel!);
      return true;
    } else {
      print("No esp32 connection...");
      return false;
    }
  }

  fetchController() async {
    this._controllerFetcher.sink.add(this._espDataModel!);
  }

  fetchCounters() async {
    this._countersFetcher.sink.add(this._espDataModel!);
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

  fetchGetTimetable() async {
    try{
      Map? tmp = await this._repository.fetchTimetable();
      this._espDataModel!.fetchHttpGetTimetable(tmp);
      this._timetableFetcher.sink.add(this._espDataModel!);
    } catch(e) {
      print(e);
    }
  }

  fetchPostTimetable(TimetableForm data) async {
    try{
      Map? tmp = await this._repository.fetchSetTimetable(data.toJson());
      if(tmp != null) {
        List<dynamic> jsonSuccess = tmp["success"];
        this._espDataModel!.fetchHttpPostTimetable(jsonSuccess);
        this._timetableFetcher.sink.add(this._espDataModel!);
        //TODO
        //List<dynamic> jsonError = tmp["error"];
      } else print("Some error while init new timetable");
    } catch(e) {
      print(e);
    }
  }

  fetchPostOffSocket(int num) async {
    try {
      await this._repository.fetchPostOffSocket(num);
      this._controllerFetcher.sink.add(this._espDataModel!);
    } catch (e) {
      print(e);
    }
  }

  fetchPostOnSocket(int num) async {
    try {
      await this._repository.fetchPostOnSocket(num);
      this._controllerFetcher.sink.add(this._espDataModel!);
    } catch (e) {
      print(e);
    }
  }

  fetchPostOffAllSockets() async {
    try {
      await this._repository.fetchPostOffAllSockets();
      this._controllerFetcher.sink.add(this._espDataModel!);
    } catch (e) {
      print(e);
    }

  }

  fetchPostOnAllSockets() async {
    try {
      await this._repository.fetchPostOnAllSockets();
      this._controllerFetcher.sink.add(this._espDataModel!);
    } catch (e) {
      print(e);
    }

  }

  dispose() {
    print("dispose()");
    this._controllerFetcher.close();
    this._countersFetcher.close();
    this._timetableFetcher.close();
  }

}

final bloc = EspDataBloc();