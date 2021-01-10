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

  // TODO separates streams
  Stream<EspDataModel> get controllerFetcher => this._controllerFetcher.stream;
  Stream<EspDataModel> get countersFetcher => this._countersFetcher.stream;
  Stream<EspDataModel> get timetableFetcher => this._timetableFetcher.stream;

  Socket? get socket => this._socket;

  generateCounters() async {
    print("Generate counters...");
    _espDataModel = await this._repository.fetchEspData();
    this._countersFetcher.sink.add(this._espDataModel!);
  }

  Future<bool> connectToEsp() async {
    if(this.socket == null) {
      //this._socket = await Socket.connect('192.168.1.20', 80);
      return true;
    }
    return false;
  }

  Future<bool> fetchEspData() async {
    print("fetchEspData() async");
    bool status = await connectToEsp();
    if(status) {
      print("EspData generate...");
      _espDataModel = await this._repository.fetchEspData();
      this._controllerFetcher.sink.add(this._espDataModel!);
      return true;
    } else {
      print("No connection");
      return false;
    }
  }

  fetchController() async {
    print("fetchController()");
    this._controllerFetcher.sink.add(this._espDataModel!);
  }

  fetchCounters() async {
    print("fetchCounters() async");
    this._countersFetcher.sink.add(this._espDataModel!);
  }

  fetchInitCounter(InitCounterDataUi data) async {
    bool success = false;

    if(data.numOfValidZones == 0) {
      success = await this._repository.fetchSetCountdown(data.toJson());
    } else if(data.numOfValidZones > 1) {
      success = await this._repository.fetchSetRepeat(data.toJson());
    }

    if(success) {
      // TODO alert
      this._controllerFetcher.sink.add(this._espDataModel!);
    } else {
      // TODO send err
    }
  }

  fechTimetable() async {
    print("fechTimetable()");
    this._timetableFetcher.sink.add(this._espDataModel!);
  }

  fechInitTimetable(TimetableForm data) async {
    bool success = await this._repository.fetchSetTimetable(data.toJson());

    if(success) {
      // TODO alert
      this._timetableFetcher.sink.add(this._espDataModel!);
    } else {
      // TODO send err
    }
  }

  fetchSetOffSocket(int num) async {
    print("offSocket(int num) async");
    bool success = await this._repository.fetchSetOffSocket(num);

    if(success) {
      // TODO alert
      this._controllerFetcher.sink.add(this._espDataModel!);
    } else {
      // TODO send err
    }

  }

  fetchSetOnSocket(int num) async {
    print("onSocket(int num) async");
    bool success = await this._repository.fetchSetOnSocket(num);

    if(success) {
      // TODO alert
      this._controllerFetcher.sink.add(this._espDataModel!);
    } else {
      // TODO send err
    }
  }

  fetchSetOffAllSockets() async {
    print("offSocket(int num) async");
    bool success = await this._repository.fetchSetOffAllSockets();

    if(success) {
      // TODO alert
      this._controllerFetcher.sink.add(this._espDataModel!);
    } else {
      // TODO send err
    }

  }

  fetchSetOnAllSockets() async {
    print("onAllSockets() async");
    bool success = await this._repository.fetchSetOnAllSockets();

    if(success) {
      // TODO alert
      this._controllerFetcher.sink.add(this._espDataModel!);
    } else {
      // TODO send err
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