class ExchangeRates {
  String _id = '';
  String _tradingTime = '';
  String _sourceCurrency = '';
  String _targetCurrency = '';
  double _closingrate = 0;
  double _averagerate = 0;

  ExchangeRates(
    this._id,
    this._tradingTime,
    this._sourceCurrency,
    this._targetCurrency,
    this._closingrate,
    this._averagerate,
  );
  ExchangeRates.empty();

  String get id => _id;
  String get tradingTime => _tradingTime;
  String get sourceCurrency => _sourceCurrency;
  String get targetCurrency => _targetCurrency;
  double get closingrate => _closingrate;

  double get averagerate => _averagerate;

  set id(String value) {
    this._id = value;
  }

  set tradingTime(String value) {
    this._tradingTime = value;
  }

  set sourceCurrency(String value) {
    this._sourceCurrency = value;
  }

  set targetCurrency(String value) {
    this._targetCurrency = value;
  }

  set closingrate(double value) {
    this._closingrate = value;
  }

  set averagerate(double value) {
    this._averagerate = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['tradingTime'] = _tradingTime;
    map['sourceCurrency'] = _sourceCurrency;
    map['targetCurrency'] = _targetCurrency;
    map['closingrate'] = _closingrate;

    map['averagerate'] = _averagerate;

    return map;
  }

  ExchangeRates.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._tradingTime = map['tradingtime'] ?? '';
    this._sourceCurrency = map['sourcecurrency'] ?? '';
    this._targetCurrency = map['targetcurrency'] ?? '';
    this._closingrate =
        (map['closingrate'] == null) ? 0.00 : double.parse(map['closingrate']);
    this._averagerate =
        (map['averagerate'] == null) ? 0.00 : double.parse(map['averagerate']);
  }
  static List<ExchangeRates> getListFromJson(
      List<Map<String, dynamic>> jsonArray) {
    List<ExchangeRates> list = [];
    for (int i = 0; i < jsonArray.length; i++) {
      list.add(ExchangeRates.fromMap(jsonArray[i]));
    }
    return list;
  }
}
