import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum RequestType { post, get, patch, delete, put }

class Config {
  static String edKey = "fInGoLD@@1!@!234";
  static String accounts = "fingold_accounts";
  static String transactions = "fingold_transactions";
  static String orders = "fingold_exchangeOrders";
  static String currency = "fingold_currency";
  static String rates = "fingold_rates";
  static String marchants = "fingold_marchants";
  static String bank = "fingold_bank";
  static String token = "fingold_app";
  static String banners = "fingold_banners";
  static const String apiUrl = "fg.ikra.my"; //
  static const String Ip = "192.168.100.30"; // ; //"fg.ikra.my";
  static const int port = 3300;
  static bool remoteServer = true;

  static int transfer = 1;
  static int syncInterval = 2;
  static int tupup = 2;
  static int swap = 3;
  static int liquidate = 4;

  static Color golden = Color(0xFFF7D330);
  static Color goldenDark = Color.fromARGB(255, 167, 141, 25);

  static Color fiat = Color(0xFF3AA3A0);
  static Color fiatDark = Color.fromARGB(255, 11, 113, 109);
  static Color cliquidate = Color(0xFF189AB4);
  static Color cTransfer = Color(0xFF05445E);
  static Color cTopup = Color(0xFF75E6DA);
  static Color cSwap = Color(0xFFD4F1F4);

  static String codeScan = "scan";
  static String codeTransfer = "transfer";
  static String codeTopup = "topup";
  static String codeLiquidate = "liquidate";
  static String codeSwap = "swap";
  static String codeHistory = "history";
  static String codeInfo = "info";
}
