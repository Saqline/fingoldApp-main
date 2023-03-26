class Accounts {
  int _id = 0;
  String _memberId = '';
  String _currency = '';
  int _accountType = 0;
  String _accountName = '';
  String _otp = '';
  double _transactionLimit = 0;
  double _monthlyLimit = 0;
  double _dayLimit = 0;
  double _balance = 0;
  double _hold = 0;
  String _regDate = '';
  String _lastTransaction = '';
  int _status = 0;
  String _lastSync = '';
  String _needSync = '';

  Accounts(
      this._id,
      this._currency,
      this._memberId,
      this._accountType,
      this._accountName,
      this._otp,
      this._transactionLimit,
      this._monthlyLimit,
      this._dayLimit,
      this._balance,
      this._hold,
      this._regDate,
      this._lastTransaction,
      this._status,
      this._lastSync,
      this._needSync);
  Accounts.empty();

  int get id => _id;
  String get memberId => _memberId;
  String get currency => _currency;
  int get accountType => _accountType;
  String get accountName => _accountName;
  String get otp => _otp;
  double get transactionLimit => _transactionLimit;
  double get monthlyLimit => _monthlyLimit;
  double get dayLimit => _dayLimit;
  double get balance => _balance;
  double get hold => _hold;
  String get regDate => _regDate;

  String get lastTransaction => _lastTransaction;
  int get status => _status;
  String get lastSync => _lastSync;
  String get needSync => _needSync;

  set id(int value) {
    this._id = value;
  }

  set memberId(String value) {
    this._memberId = value;
  }

  set currency(String value) {
    this._currency = value;
  }

  set accountType(int value) {
    this._accountType = value;
  }

  set accountName(String value) {
    this._accountName = value;
  }

  set transactionLimit(double value) {
    this._transactionLimit = value;
  }

  set monthlyLimit(double value) {
    this._monthlyLimit = value;
  }

  set dayLimit(double value) {
    this._dayLimit = value;
  }

  set balance(double value) {
    this._balance = value;
  }

  set hold(double value) {
    this._hold = value;
  }

  set regDate(String value) {
    this._regDate = value;
  }

  set lastTransaction(String value) {
    this._lastTransaction = value;
  }

  set status(int value) {
    this._status = value;
  }

  set lastSync(String value) {
    this._lastSync = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['memberId'] = _memberId;
    map['currency'] = _currency;
    map['accountType'] = _accountType;
    map['accountName'] = _accountName;
    map['transactionLimit'] = _transactionLimit;
    map['monthlyLimit'] = _monthlyLimit;
    map['dayLimit'] = _dayLimit;
    map['balance'] = _balance;
    map['hold'] = _hold;
    map['lastTransaction'] = _lastTransaction;
    map['status'] = _status;
    map['lastSync'] = _lastSync;
    return map;
  }

  Accounts.fromMap(Map<String, dynamic> map) {
    //print(map);
    this._id = map['id'] ?? 0;
    this._memberId = map['memberid'] ?? '';
    this._currency = map['currency'] ?? '';
    this._accountType = map['accounttype'] ?? '';
    this._transactionLimit = (map['transactionlimit'] == null)
        ? 0.00
        : double.parse(map['transactionlimit']);
    this._monthlyLimit = (map['monthlylimit'] == null)
        ? 0.00
        : double.parse(map['monthlylimit']);
    this._dayLimit =
        (map['daylimit'] == null) ? 0.00 : double.parse(map['daylimit']);
    this._balance =
        (map['balance'] == null) ? 0.00 : double.parse(map['balance']);
    this._hold = (map['hold'] == null) ? 0.00 : double.parse(map['hold']);
    this._regDate = map['regdate'] ?? '';

    this._lastTransaction = map['lasttransaction'] ?? '';
    this._status = map['status'] ?? 0;
    this._lastSync = map['lastsync'] ?? '';
    this._accountName = map['accountname'] ?? '';
  }
  Accounts.fromIDAndCurrency(int id, String currency, String name) {
    this._id = id;
    this._currency = currency;
    this._accountName = name;
    this._memberId = '';

    this._accountType = 0;
    this._transactionLimit = 0.00;
    this._monthlyLimit = 0.00;
    this._dayLimit = 0.00;
    this._balance = 0.00;
    this._hold = 0.00;
    this._regDate = '';
    this._lastTransaction = '';
    this._status = 1;
    this._lastSync = '';
  }

  static List<Accounts> getListFromJson(List<dynamic> jsonArray) {
    List<Accounts> list = [];
    for (int i = 0; i < jsonArray.length; i++) {
      list.add(Accounts.fromMap(jsonArray[i]));
    }
    return list;
  }
}
