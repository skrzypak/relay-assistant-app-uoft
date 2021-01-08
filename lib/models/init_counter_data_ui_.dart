class InitCounterDataUi {
  int? _index;
  String? _name;

  List<DateTime> _zonesLastExtra = [DateTime(2000, 1, 1, 0, 0, 0)];
  bool _state = false;
  int _repeats = 0;

  InitCounterDataUi(int index, String name) {
    this._index = index;
    this._name = name;
  }

  get index => this._index;

  get name => this._name;

  get zones => this._zonesLastExtra;

  get state => this._state;

  get repeats => this._repeats;

  get length => this._zonesLastExtra.length;

  get numOfValidZones => this._zonesLastExtra.length - 1;

  void addZone(DateTime val) => this._zonesLastExtra.add(val);

  DateTime getZone(int index) => this._zonesLastExtra[index];

  void updateZone(int index, DateTime val) => this._zonesLastExtra[index] = val;

  void toggleState() => this._state = !this._state;

  void setRepeat(int val) => this._repeats = val;

  void removeZone(int index) => this._zonesLastExtra.removeAt(index);

}