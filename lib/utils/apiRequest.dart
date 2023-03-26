import 'dart:convert' as convert;
import 'package:fingold/utils/LocalStore.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fingold/utils/config.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';
import 'dart:async';
import 'package:network_tools/network_tools.dart';

class ApiRequest {
  final String host;
  final String path;
  final RequestType requestType;
  final Map<String, dynamic> data;
  final bool secured;
  ApiRequest(this.path, this.requestType,
      {this.data = const {}, this.secured = true, this.host = Config.apiUrl});

  Future<Map<String, dynamic>> send() async {
    late var response;

    String body = "";
    var url = Config.remoteServer
        ? Uri.https(host, path)
        : Uri.http(Config.Ip + ":" + Config.port.toString(), path);
    final headers = <String, String>{"Content-Type": "application/json"};
    if (secured) {
      LocalStore localStore = LocalStore();
      var storeValue = await localStore.read(Config.token, isList: false);
      Map<String, dynamic> storeObj =
          convert.jsonDecode(storeValue) as Map<String, dynamic>;

      headers['Authorization'] = "Bearer " + storeObj["accessToken"];
    }
    if (data.keys.length > 0) {
      body = convert.jsonEncode(data);
    }

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool haveNetwork = await check();

      if (haveNetwork) {
        if (requestType == RequestType.get) {
          response = await http.get(
            url,
            headers: headers,
          );
        } else if (requestType == RequestType.post) {
          response = await http.post(url, headers: headers, body: body);
        } else if (requestType == RequestType.patch) {
          response = await http.patch(url, headers: headers, body: body);
        } else if (requestType == RequestType.delete) {
          response = await http.delete(url, headers: headers, body: body);
        }
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 204) {
          return jsonResponse;
        } else {
          var errors = jsonResponse['errors'] ?? "";

          if (errors.length > 0) {
            return {"errors": errors};
          } else {
            return {"errors": "Something went wrong"};
          }
        }
      } else {
        return {"errors": "No-Internet or Server-Down"};
      }
    } on PlatformException catch (e) {
      return {"errors": e.toString()};
    }
  }

  Future<bool> check() async {
    bool haveInternet = false;
    if (Config.remoteServer) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        haveInternet = true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        haveInternet = true;
      } else if (connectivityResult == ConnectivityResult.vpn) {
        haveInternet = true;
      }
      if (haveInternet) {
        try {
          final result = await InternetAddress.lookup(Config.apiUrl);
          //print(result);
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            haveInternet = true;
          }
        } on Exception catch (err) {
          //print(err.toString());
          haveInternet = false;
        } catch (e) {
          //print(e.toString());
          haveInternet = false;
        }
      } else {
        haveInternet = false;
      }
    } else {
      haveInternet = await ipcheck();
    }
    return haveInternet;
  }

  ipcheck() async {
    bool isOk = false;
    try {
      isOk = await PortScanner.isOpen(Config.Ip, Config.port).then((value) {
        final OpenPort deviceWithOpenPort = value!.openPort[0];

        if (deviceWithOpenPort.isOpen) {
          return true;
        } else {
          return false;
        }
      });
    } catch (_) {
      isOk = false;
    }
    return isOk;
  }
}
