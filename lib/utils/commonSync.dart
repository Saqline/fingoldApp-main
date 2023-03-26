import 'dart:convert' as convert;
import 'package:fingold/utils/apiRequest.dart';
import 'package:fingold/utils/config.dart';
import 'package:fingold/utils/LocalStore.dart';

class CommonSync {
  sync({String section = "all"}) async {
    String path = "sync";
    LocalStore localStore = LocalStore();
    if (section == Config.rates) {
      path = "rates";
    } else if (section == Config.marchants) {
      path = "marchants";
    }
    ApiRequest api = ApiRequest(path, RequestType.get);
    var result = await api.send();
    if (result["errors"] == null) {
      if (section == Config.rates) {
        await localStore.save(Config.rates, convert.jsonEncode(result['docs']));
        await localStore.save("lastUpdate",
            DateTime.now().toUtc().millisecondsSinceEpoch.toString());
      } else if (section == Config.marchants) {
        await localStore.save(
            Config.marchants, convert.jsonEncode(result['docs']));
        await localStore.save("lastUpdate" + Config.marchants,
            DateTime.now().toUtc().millisecondsSinceEpoch.toString());
      } else {
        await localStore.save(
            Config.accounts, convert.jsonEncode(result['accounts']['docs']));
        await localStore.save(
            Config.orders, convert.jsonEncode(result['exchangeOrder']['docs']));
        await localStore.save(Config.transactions,
            convert.jsonEncode(result['transactions']['docs']));
        await localStore.save(
            Config.currency, convert.jsonEncode(result['currencies']['docs']));
        await localStore.save(
            Config.rates, convert.jsonEncode(result['rates']['docs']));
        await localStore.save(
            Config.banners, convert.jsonEncode(result['banners']));
        await localStore.save("lastUpdate",
            DateTime.now().toUtc().millisecondsSinceEpoch.toString());
      }
    }
  }

  getData({String path = ""}) async {
    LocalStore localStore = LocalStore();

    ApiRequest api = ApiRequest(path, RequestType.get);
    var result = await api.send();
    if (result["errors"] == null) {
      await localStore.save(path, convert.jsonEncode(result));
      await localStore.save("lastUpdate_" + path,
          DateTime.now().toUtc().millisecondsSinceEpoch.toString());
    }
  }

  Future<Map<String, dynamic>> tokenData() async {
    LocalStore localStore = LocalStore();
    String storeValue = await localStore.read(Config.token, isList: false);
    Map<String, dynamic> storeObj =
        convert.jsonDecode(storeValue) as Map<String, dynamic>;
    return storeObj;
  }

  Future<List<dynamic>> retriveData(
      {required keyName, Map<dynamic, dynamic> data = const {}}) async {
    LocalStore localStore = LocalStore();
    String storeValue = await localStore.read(keyName);
    List<dynamic> storeObj = convert.jsonDecode(storeValue) as List<dynamic>;
    if (data.values.toList().length > 0) {
      List<dynamic> newData = [data, ...storeObj];
      await localStore.save(keyName, convert.jsonEncode(newData));
      return newData;
    } else {
      return storeObj;
    }
  }

  Future<int> lastSync({bool marchants = false}) async {
    LocalStore localStore = LocalStore();
    String keyVal = marchants ? "lastUpdate" + Config.marchants : "lastUpdate";
    String storeValue = await localStore.read(keyVal);
    String val = storeValue == "[]" || storeValue == "" ? "0" : storeValue;
    return int.parse(val);
  }
}
