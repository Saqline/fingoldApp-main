class Banners {
  String _url = '';

  Banners(this._url);
  Banners.empty();

  String get url => _url;

  set url(String value) {
    this._url = value;
  }

  Banners.fromMap(Map<String, dynamic> map) {
    this._url = map['url'] ?? '';
  }
  static List<Banners> getListFromJson(List<dynamic> jsonArray) {
    List<Banners> list = [];
    for (int i = 0; i < jsonArray.length; i++) {
      list.add(Banners.fromMap(jsonArray[i]));
    }
    return list;
  }
}
