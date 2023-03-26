class Bank {
  int _id = 0;
  String _accountname = '';
  String _accountnumber = '';
  String _bankname = '';
  String _swift = '';
  String _address = '';
  String _city = '';
  String _state = '';
  String _postcode = '';
  String _country = '';
  int _status = 0;
  int _inserttime = 0;

  int _updatetime = 0;
  int _memberid = 0;

  Bank(
      this._id,
      this._accountname,
      this._accountnumber,
      this._bankname,
      this._swift,
      this._address,
      this._city,
      this._state,
      this._postcode,
      this._country,
      this._status,
      this._inserttime,
      this._updatetime,
      this._memberid);
  Bank.empty();

  int get id => _id;

  String get accountname => _accountname;
  String get accountnumber => _accountnumber;
  String get bankname => _bankname;
  String get swift => _swift;
  String get address => _address;
  String get city => _city;
  String get state => _state;
  String get postcode => _postcode;
  String get country => _country;
  int get status => _status;
  int get inserttime => _inserttime;
  int get updatetime => _updatetime;

  int get memberid => _memberid;

  set id(int value) {
    this._id = value;
  }

  set accountname(String value) {
    this._accountname = value;
  }

  set accountnumber(String value) {
    this._accountnumber = value;
  }

  set bankname(String value) {
    this._bankname = value;
  }

  set swift(String value) {
    this._swift = value;
  }

  set address(String value) {
    this._address = value;
  }

  set city(String value) {
    this._city = value;
  }

  set state(String value) {
    this._state = value;
  }

  set postcode(String value) {
    this._postcode = value;
  }

  set country(String value) {
    this._country = value;
  }

  set status(int value) {
    this._status = value;
  }

  set inserttime(int value) {
    this._inserttime = value;
  }

  set updatetime(int value) {
    this._updatetime = value;
  }

  set memberid(int value) {
    this._memberid = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['accountname'] = _accountname;
    map['accountnumber'] = _accountnumber;
    map['bankname'] = _bankname;
    map['swift'] = _swift;
    map['address'] = _address;
    map['city'] = _city;
    map['state'] = _state;
    map['postcode'] = _postcode;
    map['country'] = _country;
    map['status'] = _status;
    map['inserttime'] = _inserttime;
    map['updatetime'] = _updatetime;
    map['memberid'] = _memberid;
    return map;
  }

  Bank.fromMap(Map<String, dynamic> map) {
    this._id = map['id'] ?? 0;
    this._accountname = map['accountname'] ?? '';
    this._accountnumber = map['accountnumber'] ?? '';
    this._bankname = map['bankname'] ?? '';
    this._swift = map['swift'] ?? '';
    this._address = map['address'] ?? '';
    this._city = map['city'] ?? '';
    this._state = map['state'] ?? '';
    this._postcode = map['postcode'] ?? '';
    this._country = map['country'] ?? '';
    this._status = map['status'] ?? 0;
    this._inserttime = (map['inserttime'] == null)
        ? DateTime.now().toUtc().millisecondsSinceEpoch
        : map['inserttime'].toInt();
    this._updatetime = map['updatetime'] ?? 0;
    this._memberid = map['memberid'] ?? 0;
  }
}
