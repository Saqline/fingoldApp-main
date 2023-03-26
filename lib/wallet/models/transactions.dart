import 'package:fingold/extensions/string.dart';
import 'package:intl/intl.dart';

class Transactions {
  int _id = 0;
  int _account = 0;
  String _currency = '';
  String _comments = '';
  double _amount = 0;
  double _balance = 0;
  int _transactionType = 0;
  String _transactionTime = '';

  int _status = 0;
  String _investmentId = '';
  String _memberId = '';

  Transactions(
    this._id,
    this._account,
    this._currency,
    this._comments,
    this._amount,
    this._balance,
    this._transactionType,
    this._transactionTime,
    this._status,
    this._investmentId,
    this._memberId,
  );
  Transactions.empty();

  int get id => _id;
  int get account => _account;
  String get currency => _currency;
  String get comments => _comments;
  double get amount => _amount;
  double get balance => _balance;
  int get transactionType => _transactionType;
  String get transactionTime => _transactionTime;

  int get status => _status;
  String get investmentId => _investmentId;
  String get memberId => _memberId;

  set id(int value) {
    this._id = value;
  }

  set account(int value) {
    this._account = value;
  }

  set currency(String value) {
    this._currency = value;
  }

  set comments(String value) {
    this._comments = value;
  }

  set amount(double value) {
    this._amount = value;
  }

  set balance(double value) {
    this._balance = value;
  }

  set transactionType(int value) {
    this._transactionType = value;
  }

  set transactionTime(String value) {
    this._transactionTime = value;
  }

  set status(int value) {
    this._status = value;
  }

  set investmentId(String value) {
    this._investmentId = value;
  }

  set memberId(String value) {
    this._memberId = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['account'] = _account;
    map['currency'] = _currency;
    map['comments'] = _comments;
    map['amount'] = _amount;
    map['balance'] = _balance;
    map['transactionType'] = _transactionType;
    map['transactionTime'] = _transactionTime;
    map['status'] = _status;
    map['investmentId'] = _investmentId;
    map['memberId'] = _memberId;
    return map;
  }

  Transactions.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._account = map['account'] ?? 0;
    this._currency = map['currency'] ?? '';
    this._comments = map['comments'] ?? '';
    this._amount = (map['amount'] == null) ? 0.00 : double.parse(map['amount']);
    this._balance =
        (map['balance'] == null) ? 0.00 : double.parse(map['balance']);
    this._transactionType = map['transactiontype'] ?? 0;
    this._transactionTime = map['transactiontime'] ?? '';
    this._status = map['status'] ?? 0;
    this._investmentId = map['investmentid'] ?? '';
    this._memberId = map['memberid'] ?? '';
    this._transactionTime = readTimestamp(this._transactionTime.toInt());
  }
  String readTimestamp(int timestamp, [String format = 'yMMMEd']) {
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    DateFormat subHead = new DateFormat(format);
    return subHead.format(date).toString();
  }

  static List<Transactions> getListFromJson(List<dynamic> jsonArray,
      {String selected = "", int max = 15}) {
    List<Transactions> list = [];
    int itemCount = 0;
    for (int i = 0; i < jsonArray.length; i++) {
      if (selected == "" && itemCount < max) {
        list.add(Transactions.fromMap(jsonArray[i]));
        itemCount++;
      } else {
        if (jsonArray[i]["currency"].trim() == selected && itemCount < max) {
          list.add(Transactions.fromMap(jsonArray[i]));
          itemCount++;
        }
      }
    }
    list.sort((a, b) => b.id.compareTo(a.id));
    return list;
  }
}
