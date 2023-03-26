class Currency {
  int _id = 0;
  String _currencyName = '';
  String _symbol = '';
  String _sign = '';
  String _unit = '';
  int _decimalPoint = 2;
  double _transactionFee = 0;
  bool _isPercentage = false;

  Currency(this._id, this._transactionFee, this._currencyName, this._symbol,
      this._sign, this._decimalPoint, this._isPercentage);
  Currency.empty();

  int get id => _id;
  bool get isPercentage => _isPercentage;
  String get currencyName => _currencyName;
  String get symbol => _symbol;
  String get unit => _unit;
  String get sign => _sign;
  int get decimalPoint => _decimalPoint;
  double get transactionFee => _transactionFee;

  set id(int value) {
    this._id = value;
  }

  set isPercentage(bool value) {
    this._isPercentage = value;
  }

  set currencyName(String value) {
    this._currencyName = value;
  }

  set unit(String value) {
    this._unit = value;
  }

  set symbol(String value) {
    this._symbol = value;
  }

  set sign(String value) {
    this._sign = value;
  }

  set decimalPoint(int value) {
    this._decimalPoint = value;
  }

  set transactionFee(double value) {
    this._transactionFee = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['transactionFeed'] = _transactionFee;
    map['currencyName'] = _currencyName;
    map['symbol'] = _symbol;
    map['sign'] = _sign;
    map['decimalPoint'] = _decimalPoint;
    map['isPercentage'] = _isPercentage;

    return map;
  }

  Currency.fromMap(Map<String, dynamic> map) {
    /*
"id": 4,
        "currencyname": "US Dollar",
        "symbol": "USD",
        "sign": "$",
        "decimalpoint": 2,
        "status": 1,
        "unit": "USD",
        "transactionfee": "1",
        "ispercentage": true

    */
    this._id = map['id'] ?? 0;
    this._isPercentage = map['ispercentage'];
    this._transactionFee = double.parse(map['transactionfee']);
    this._currencyName = map['currencyname'] ?? '';
    this._symbol = map['symbol'] ?? '';
    this._sign = map['sign'] ?? '';
    this._unit = map['unit'] ?? '';
    this._decimalPoint = map['decimalpoint'] ?? 2;
  }
  static List<Currency> getListFromJson(List<dynamic> jsonArray) {
    List<Currency> list = [];
    for (int i = 0; i < jsonArray.length; i++) {
      list.add(Currency.fromMap(jsonArray[i]));
    }
    return list;
  }

  static Currency getCurrency(List<Currency> jsonArray, String cur) {
    Currency _cur = jsonArray.firstWhere(
        (item) => item.symbol.trim() == cur.trim(),
        orElse: () => Currency.empty());
    //print("***");
    // print(_cur.decimalPoint);
    return _cur;
  }
}
