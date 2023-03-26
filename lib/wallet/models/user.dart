class User {
  int _userId = 0;
  String _name = '';
  String _email = '';
  String _mobile = '';
  String _accessToken = '';
  String _refreshToken = '';
  int _ev = 0;
  int _mv = 0;

  User(
    this._userId,
    this._name,
    this._email,
    this._mobile,
    this._accessToken,
    this._ev,
    this._refreshToken,
    this._mv,
  );
  User.empty();

  int get userId => _userId;
  String get email => _email;
  String get mobile => _mobile;
  String get name => _name;
  String get refreshToken => _refreshToken;
  String get accessToken => _accessToken;
  int get ev => _ev;
  int get mv => _mv;

  set mv(int value) {
    this._mv = value;
  }

  set userId(int value) {
    this._userId = value;
  }

  set ev(int value) {
    this._ev = value;
  }

  set email(String value) {
    this._email = value;
  }

  set mobile(String value) {
    this._mobile = value;
  }

  set name(String value) {
    this._name = value;
  }

  set accessToken(String value) {
    this._accessToken = value;
  }

  set refreshToken(String value) {
    this._refreshToken = value;
  }

  User.fromMap(Map<String, dynamic> map) {
    this._ev = map['ev'] ?? 0;
    this._mv = map['mv'] ?? 0;
    this._userId = map['userId'] ?? 0;
    this._email = map['email'] ?? '';
    this._mobile = map['mobile'] ?? '';
    this._name = map['name'] ?? '';
    this._accessToken = map['accessToken'] ?? '';
    this._refreshToken = map['refreshToken'] ?? '';
  }
}
