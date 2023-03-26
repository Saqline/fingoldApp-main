import 'package:fingold/wallet/models/banners.dart';
import 'package:fingold/wallet/models/rates.dart';
import 'package:fingold/wallet/views/home_screen.dart';
import 'package:fingold/utils/commonSync.dart';
import 'package:fingold/utils/config.dart';
import 'package:fingold/wallet/models/accounts.dart';
import 'package:fingold/wallet/models/currency.dart';
import 'package:fingold/wallet/views/wallet_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

//import '../models/coin.dart';
//import '../nft_cache.dart';
//import '../views/single_coin_screen.dart';

class WalletController extends FxController {
  List<Currency> currencyList = [];

  List<Rates> rates = [];
  List<Banners> banners = [];
  Rates currentRate = Rates.empty();
  int selectedCurrencyType = 0;
  int selectedBalanceType = 0;
  List<Accounts> accounts = [];
  CommonSync sync = CommonSync();
  bool refreshing = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    refreshing = true;
    update();
    List<dynamic> rawAcc = await sync.retriveData(keyName: Config.accounts);
    List<dynamic> rawCur = await sync.retriveData(keyName: Config.currency);
    List<dynamic> rawRates = await sync.retriveData(keyName: Config.rates);
    List<dynamic> rawBanners = await sync.retriveData(keyName: Config.banners);
    accounts = Accounts.getListFromJson(rawAcc);
    currencyList = Currency.getListFromJson(rawCur);
    rates = Rates.getListFromJson(rawRates);
    banners = Banners.getListFromJson(rawBanners);
    if (rates.length > 0) {
      currentRate = rates[0];
    }
    refreshing = false;
    update();
  }

  void selectCurrency(int index) {
    selectedCurrencyType = index;
    update();
  }

  void selectBalance(int index) {
    selectedBalanceType = index;
    update();
  }

  void goToQRScreen(Accounts coin) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => WalletQrScreen(account: coin),
      ),
    );
  }

  void goToWalletHomeScreen(Accounts coin) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => HomeScreen(account: coin),
      ),
    );
  }

  Future<void> goToWalletHomeScreen2(
      BuildContext context, Accounts coin) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => HomeScreen(account: coin)),
    );
  }

  void refresh() async {
    refreshing = true;
    update();
    CommonSync sync = CommonSync();
    int now = DateTime.now().millisecondsSinceEpoch;
    int prevSync = await sync.lastSync();

    int diff = int.parse(((now - prevSync) / 60000).toStringAsFixed(0));
    // print(now - prevSync);
    if (diff > Config.syncInterval) {
      await sync.sync();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Please retry after ${Config.syncInterval - diff} minute(s)"),
          backgroundColor: Colors.red,
        ),
      );
    }

    await fetchData();
    refreshing = false;
    update();
  }

  @override
  String getTag() {
    return "wallet_controller";
  }
}
