class Rates {
  int _id = 0;
  String _datetime = '';
  String _symbol = '';
  String _currency = '';
  String _unit = '';
  double _bid = 0;
  double _ask = 0;
  double _cbid = 0;
  double _cask = 0;
  Rates(this._id, this._datetime, this._symbol, this._currency, this._unit,
      this._bid, this._ask, this._cask, this._cbid);
  Rates.empty();

  int get id => _id;
  String get datetime => _datetime;
  String get symbol => _symbol;
  String get currency => _currency;
  String get unit => _unit;

  double get bid => _bid;
  double get ask => _ask;

  double get cbid => _cbid;
  double get cask => _cask;

  set id(int value) {
    this._id = value;
  }

  set datetime(String value) {
    this._datetime = value;
  }

  set symbol(String value) {
    this._symbol = value;
  }

  set currency(String value) {
    this._currency = value;
  }

  set unit(String value) {
    this._unit = value;
  }

  set bid(double value) {
    this._bid = value;
  }

  set ask(double value) {
    this._ask = value;
  }

  set cask(double value) {
    this._cask = value;
  }

  set cbid(double value) {
    this._cbid = value;
  }

  Rates.fromMap(Map<String, dynamic> map) {
    /*
 {
        "id": "2018559",
        "datetime": "2022-12-10 08:00:03",
        "symbol": "GOLD",
        "price": "46.2397",
        "currency": "USD",
        "unit": "gm",
        "bid": "46.2397",
        "ask": "57.7996"
      }

    */
    this._id = int.parse(map['id']);
    this._datetime = map['datetime'] ?? '';
    this._symbol = map['symbol'] ?? '';
    this._currency = map['currency'] ?? '';
    this._unit = map['unit'] ?? "";
    this._bid = (map['bid'] == null) ? 0.00 : double.parse(map['bid']);
    this._ask = (map['ask'] == null) ? 0.00 : double.parse(map['ask']);
    this._cbid = (map['cbid'] == null) ? 0.00 : map['cbid'];
    this._cask = (map['cask'] == null) ? 0.00 : map['cask'];
  }
  static List<Rates> getListFromJson(List<dynamic> jsonArray) {
    List<Rates> list = [];
    for (int i = 0; i < jsonArray.length; i++) {
      dynamic current = jsonArray[i];
      current['cbid'] = null;
      current['cask'] = null;
      if ((i + 1) < jsonArray.length) {
        dynamic prev = jsonArray[i + 1];
        current['cbid'] =
            double.parse(current['bid']) - double.parse(prev['bid']);
        current['cask'] =
            double.parse(current['ask']) - double.parse(prev['ask']);
      }
      list.add(Rates.fromMap(current));
    }
    return list;
  }
}
