import 'package:fingold/utils/LocalStore.dart';
import 'package:fingold/utils/commonSync.dart';
import 'package:fingold/utils/config.dart';
import 'package:fingold/wallet/models/accounts.dart';
import 'package:fingold/wallet/models/currency.dart';
import 'package:fingold/wallet/models/transactions.dart';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import '../models/coin.dart';
import '../nft_cache.dart';
import '../views/single_coin_screen.dart';

class QRController extends FxController {
  List<Coin> coins = [];
  late Map<dynamic, dynamic> storeValue;
  //late Map<dynamic, dynamic> storeValue;
  LocalStore localStore = LocalStore();
  CommonSync sync = CommonSync();
  List<Accounts> accounts = [];
  List<Transactions> transactions = [];
  List<Currency> currency = [];
  bool loaded = true;
  bool refreshing = false;
  Currency currentCurrency = Currency.empty();
  int max = 15;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fetchData() async {
    //await NFTCache.initDummy();
    //coins = NFTCache.coins!;
    // List<dynamic> rawAcc = await sync.retriveData(keyName: Config.accounts);
    // List<dynamic> rawTrans =
    //  await sync.retriveData(keyName: Config.transactions);
    // accounts = Accounts.getListFromJson(rawAcc);
    // transactions = Transactions.getListFromJson(rawTrans,
    // selected: currentCurrency.symbol, max: max);
    List<dynamic> rawCur = await sync.retriveData(keyName: Config.currency);
    currency = Currency.getListFromJson(rawCur);
    //loaded = true;
    //refreshing = false;
    update();
  }

  double findAspectRatio() {
    double width = MediaQuery.of(context).size.width;
    return ((width - 72) / 3) / (133);
  }

  void goToSingleCoinScreen(Coin coin) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => SingleCoinScreen(),
      ),
    );
  }

  void refresh() async {
    refreshing = true;
    update();
    await CommonSync().sync();

    await fetchData();
  }

  @override
  String getTag() {
    return "qr_controller";
  }
}
