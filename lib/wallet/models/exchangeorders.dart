class ExchangeOrders {
  int _id = 0;
  String _sourcecurrency = '';
  String _targetcurrency = '';
  String _sourceAccount = '';
  String _targetAccount = '';
  double _exchangeRate = 0;
  double _sourceamount = 0;
  double _targetamount = 0;
  String _exchangeTime = '';
  int _status = 0;
  String _memberId = '';
  int _expired = 0;

  ExchangeOrders(
      this._id,
      this._sourcecurrency,
      this._targetcurrency,
      this._sourceAccount,
      this._targetAccount,
      this._exchangeRate,
      this._sourceamount,
      this._targetamount,
      this._exchangeTime,
      this._status,
      this._memberId,
      this._expired);
  ExchangeOrders.empty();

  int get id => _id;
  String get sourcecurrency => _sourcecurrency;
  String get targetcurrency => _targetcurrency;
  String get sourceAccount => _sourceAccount;
  String get targetAccount => _targetAccount;
  double get exchangeRate => _exchangeRate;
  double get sourceamount => _sourceamount;
  double get targetamount => _targetamount;
  String get exchangeTime => _exchangeTime;
  int get status => _status;
  String get memberId => _memberId;
  int get expired => _expired;

  set id(int value) {
    this._id = value;
  }

  set sourcecurrency(String value) {
    this._sourcecurrency = value;
  }

  set targetcurrency(String value) {
    this._targetcurrency = value;
  }

  set sourceAccount(String value) {
    this._sourceAccount = value;
  }

  set targetAccount(String value) {
    this._targetAccount = value;
  }

  set exchangeRate(double value) {
    this._exchangeRate = value;
  }

  set sourceamount(double value) {
    this._sourceamount = value;
  }

  set targetamount(double value) {
    this._targetamount = value;
  }

  set exchangeTime(String value) {
    this._exchangeTime = value;
  }

  set status(int value) {
    this._status = value;
  }

  set memberId(String value) {
    this._memberId = value;
  }

  set expired(int value) {
    this._expired = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;

    map['sourcecurrency'] = _sourcecurrency;
    map['targetcurrency'] = _targetcurrency;
    map['sourceAccount'] = _sourceAccount;
    map['targetAccount'] = _targetAccount;
    map['exchangeRate'] = _exchangeRate;
    map['sourceamount'] = _sourceamount;
    map['targetamount'] = _targetamount;
    map['exchangeTime'] = _exchangeTime;

    map['status'] = _status;

    map['memberId'] = _memberId;

    map['expired'] = _expired;

    return map;
  }

  ExchangeOrders.fromMap(Map<dynamic, dynamic> map) {
    this._id = map['id'];

    this._sourcecurrency = map['sourcecurrency'] ?? '';
    this._targetcurrency = map['targetcurrency'] ?? '';
    this._sourceAccount = map['sourceaccount'] ?? '';
    this._targetAccount = map['targetaccount'] ?? '';
    this._exchangeRate = (map['exchangerate'] == null)
        ? 0.00
        : double.parse(map['exchangerate']);
    this._sourceamount = (map['sourceamount'] == null)
        ? 0.00
        : double.parse(map['sourceamount']);
    this._targetamount = (map['targetamount'] == null)
        ? 0.00
        : double.parse(map['targetamount']);
    this._exchangeTime = map['exchangetime'] ?? '';
    this._status = map['status'] ?? 0;
    this._memberId = map['memberid'] ?? '';
    this._expired = map['expired'] == null ? 0 : int.parse(map['expired']);
  }
  static List<ExchangeOrders> getListFromJson(
      List<Map<String, dynamic>> jsonArray) {
    List<ExchangeOrders> list = [];
    for (int i = 0; i < jsonArray.length; i++) {
      list.add(ExchangeOrders.fromMap(jsonArray[i]));
    }
    return list;
  }
}
