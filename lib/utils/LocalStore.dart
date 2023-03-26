import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStore {
  save(String key, String data) async {
    final storage = new FlutterSecureStorage();
    await storage.write(
        key: key,
        value: data,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
  }

  Future<String> read(String key, {bool isList = true}) async {
    final storage = new FlutterSecureStorage();
    String? data = await storage.read(
        key: key, iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
    if (data != null) {
      return data.length > 0
          ? data
          : isList
              ? "[]"
              : "{}";
    } else {
      return isList ? "[]" : "{}";
    }
  }

  deleteAll() async {
    final storage = new FlutterSecureStorage();
    await storage.deleteAll(
        iOptions: _getIOSOptions(), aOptions: _getAndroidOptions());
  }

  IOSOptions _getIOSOptions() => IOSOptions(
        accountName: "fingold_app_data",
      );
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}
