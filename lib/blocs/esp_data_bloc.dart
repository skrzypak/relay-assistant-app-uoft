import 'package:app/models/init_counter_data_ui_.dart';
import 'package:rxdart/rxdart.dart';
import '../models/esp_data_model.dart';
import '../resources/repository.dart';

class EspDataBloc {
  final _repository = Repository();
  final _controllerFetcher = PublishSubject<EspDataModel>();
  final _countersFetcher = PublishSubject<EspDataModel>();
  final _timetableFetcher = PublishSubject<EspDataModel>();
  EspDataModel? _espDataModel;

  // TODO separates streams
  Stream<EspDataModel> get controllerFetcher => this._controllerFetcher.stream;
  Stream<EspDataModel> get countersFetcher => this._countersFetcher.stream;
  Stream<EspDataModel> get timetableFetcher => this._timetableFetcher.stream;

  generateCounters() async {
    print("Generate counters...");
    _espDataModel = await this._repository.fetchEspData();
    this._countersFetcher.sink.add(this._espDataModel!);
  }

  fetchEspData() async {
    print("fetchEspData() async");
    print("EspData generate...");
    _espDataModel = await this._repository.fetchEspData();
    this._controllerFetcher.sink.add(this._espDataModel!);
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
    print("TODO:// send new counter");
  }

  fechTimetable() async {
    print("fechTimetable()");
    this._timetableFetcher.sink.add(this._espDataModel!);
  }

  fetchSetOffSocket(int num) async {
    print("offSocket(int num) async");
    bool success = await this._repository.fetchSetOffSocket(num);

    if(success) {
      this._espDataModel!.offSocket(num);
      this._controllerFetcher.sink.add(this._espDataModel!);
    } else {
      // TODO send err
    }

  }

  fetchSetOnSocket(int num) async {
    print("onSocket(int num) async");
    bool success = await this._repository.fetchSetOnSocket(num);

    if(success) {
      this._espDataModel!.onSocket(num);
      this._controllerFetcher.sink.add(this._espDataModel!);
    } else {
      // TODO send err
    }
  }

  fetchSetOffAllSockets() async {
    print("offSocket(int num) async");
    bool success = await this._repository.fetchSetOffAllSockets();

    if(success) {
      this._espDataModel!.offAllSockets();
      this._controllerFetcher.sink.add(this._espDataModel!);
    } else {
      // TODO send err
    }

  }

  fetchSetOnAllSockets() async {
    print("onAllSockets() async");
    bool success = await this._repository.fetchSetOnAllSockets();

    if(success) {
      this._espDataModel!.onAllSockets();
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