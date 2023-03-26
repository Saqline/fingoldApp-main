class Marchants {
  int _id = 0;
  String _mobile = '';
  String _name = '';
  String _address = '';
  String _city = '';
  String _state = '';
  String _postcode = '';
  String _country = '';
  int _status = 0;
  int _regdate = 0;
  int _lastupdate = 0;
  String _email = '';
  String _image = '';

  Marchants(
      this._id,
      this._image,
      this._mobile,
      this._name,
      this._address,
      this._city,
      this._state,
      this._postcode,
      this._country,
      this._status,
      this._regdate,
      this._lastupdate,
      this._email);
  Marchants.empty();

  int get id => _id;
  String get image => _image;
  String get mobile => _mobile;
  String get name => _name;
  String get address => _address;
  String get city => _city;
  String get state => _state;
  String get postcode => _postcode;
  String get country => _country;
  int get status => _status;
  int get regdate => _regdate;

  int get lastupdate => _lastupdate;

  String get email => _email;

  set id(int value) {
    this._id = value;
  }

  set image(String value) {
    this._image = value;
  }

  set mobile(String value) {
    this._mobile = value;
  }

  set name(String value) {
    this._name = value;
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

  set regdate(int value) {
    this._regdate = value;
  }

  set lastupdate(int value) {
    this._lastupdate = value;
  }

  set email(String value) {
    this._email = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['mobile'] = _mobile;
    map['name'] = _name;
    map['address'] = _address;
    map['city'] = _city;
    map['state'] = _state;
    map['postcode'] = _postcode;
    map['country'] = _country;
    map['status'] = _status;
    map['regdate'] = _regdate;
    map['image'] = _image;
    map['lastupdate'] = _lastupdate;
    map['email'] = _email;

    return map;
  }

  Marchants.fromMap(Map<String, dynamic> map) {
    this._id = map['id'] ?? 0;
    this._image = map['image'] ?? '';
    this._mobile = map['mobile'] ?? '';
    this._name = map['name'] ?? '';
    this._address = map['address'] ?? '';
    this._city = map['city'] ?? '';
    this._state = map['state'] ?? '';
    this._postcode = map['postcode'] ?? '';
    this._country = map['country'] ?? '';
    this._status = map['status'];
    this._regdate = int.parse(map['regdate']);
    this._lastupdate = int.parse(map['lastupdate']);
    this._email = map['email'] ?? '';
  }

  static List<Marchants> getListFromJson(List<dynamic> jsonArray) {
    List<Marchants> list = [];
    for (int i = 0; i < jsonArray.length; i++) {
      list.add(Marchants.fromMap(jsonArray[i]));
    }
    return list;
  }
}
