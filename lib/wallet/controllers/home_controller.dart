import 'package:fingold/utils/LocalStore.dart';
import 'package:fingold/utils/commonSync.dart';
import 'package:fingold/utils/config.dart';
import 'package:fingold/wallet/models/accounts.dart';
import 'package:fingold/wallet/models/currency.dart';
import 'package:fingold/wallet/models/transactions.dart';
import 'package:fingold/wallet/views/history_screen.dart';
import 'package:fingold/wallet/views/marchants_screen.dart';
import 'package:fingold/wallet/views/transfer_screen.dart';
//import 'package:fingold/wallet/views/wallet_liquidate_screen.dart';
import 'package:fingold/wallet/views/wallet_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import '../models/coin.dart';
import '../nft_cache.dart';
import '../views/single_coin_screen.dart';

class HomeController extends FxController {
  List<Coin> coins = [];
  late Map<dynamic, dynamic> storeValue;
  //late Map<dynamic, dynamic> storeValue;
  LocalStore localStore = LocalStore();
  CommonSync sync = CommonSync();
  List<Accounts> accounts = [];
  List<Transactions> transactions = [];
  List<Currency> currency = [];
  bool loaded = false;
  bool refreshing = false;
  Currency currentCurrency = Currency.empty();

  int max = 5;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fetchData() async {
    await NFTCache.initDummy();
    coins = NFTCache.coins!;
    List<dynamic> rawAcc = await sync.retriveData(keyName: Config.accounts);
    List<dynamic> rawTrans =
        await sync.retriveData(keyName: Config.transactions);
    accounts = Accounts.getListFromJson(rawAcc);
    transactions = Transactions.getListFromJson(rawTrans,
        selected: currentCurrency.symbol, max: max);
    List<dynamic> rawCur = await sync.retriveData(keyName: Config.currency);
    currency = Currency.getListFromJson(rawCur);
    loaded = true;
    refreshing = false;
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

  void goToScreen(Accounts account, Accounts targetAccount, String code) {
    //print("=======>${account} - ${targetAccount.id} - ${code}");
    if (code == Config.codeTransfer || code == Config.codeScan) {
      /*
      final result = await Navigator.push(
        context,
        // Create the SelectionScreen in the next step.
        MaterialPageRoute(
            builder: (context) => TransferScreen(
                  account: account,
                  targetAccount: targetAccount,
                )),
      );
      if (!mounted) return;

      if (result) {
        print("*** RELOAD*****");
      } else {
        print("*** NOTHING RETURN*****");
      }
      */

      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => TransferScreen(
            account: account,
            targetAccount: targetAccount,
          ),
        ),
      );
    } else if (code == Config.codeTopup) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => WalletQrScreen(
            account: account,
          ),
        ),
      );
    } else if (code == Config.codeLiquidate) {
      print(account.currency);
      /*
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => WalletLiquidateScreen(
            account: account,
          ),
        ),
      );
      */
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => MarchantsScreen(),
        ),
      );
    } else if (code == Config.codeSwap) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) =>
              TransferScreen(account: account, targetAccount: targetAccount),
        ),
      );
    } else if (code == Config.codeHistory) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => HistoryScreen(
            account: account,
          ),
        ),
      );
    }
  }

  void refresh() async {
    refreshing = true;
    update();
    await CommonSync().sync();

    await fetchData();
  }

  @override
  String getTag() {
    return "home_controller";
  }
}
