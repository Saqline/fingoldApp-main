import 'package:fingold/utils/LocalStore.dart';
import 'package:fingold/utils/apiRequest.dart';
import 'package:fingold/utils/commonSync.dart';
import 'package:fingold/wallet/models/accounts.dart';
import 'package:fingold/wallet/models/currency.dart';
import 'package:fingold/wallet/models/exchangeorders.dart';
import 'package:fingold/wallet/models/rates.dart';
import 'package:fingold/wallet/views/confirm_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:fingold/utils/config.dart';

class TransferController extends FxController {
  Accounts account = Accounts.empty();
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController accountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController swapAmountController = TextEditingController();
  TextEditingController amountWithoutFeeController = TextEditingController();
  bool enable = false;
  bool posting = false;
  LocalStore localStore = LocalStore();
  ExchangeOrders order = ExchangeOrders.empty();
  Map<dynamic, dynamic> storeObj = {};
  List<Accounts> accounts = [];
  List<Rates> rates = [];
  Rates activeRate = Rates.empty();
  double exchangeRate = 1.0000;
  Currency currencyOrigin = Currency.empty();
  Currency currencyTarget = Currency.empty();

  String targetCurrency = "";
  CommonSync sync = CommonSync();
  bool loadRates = false;
  bool isSwap = false;
  bool isBuy = false;
  bool initialLoad = false;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    storeObj = await sync.tokenData();
    List<dynamic> storeValue2 =
        await sync.retriveData(keyName: Config.accounts);
    List<dynamic> curData = await sync.retriveData(keyName: Config.currency);
    List<Currency> c = Currency.getListFromJson(curData);
    currencyOrigin = Currency.getCurrency(c, account.currency);
    currencyTarget = Currency.getCurrency(c, targetCurrency);
    accounts = Accounts.getListFromJson(storeValue2);
    initialLoad = true;
    if (isSwap) {
      fetchRatrData();
    } else {
      update();
    }
  }

  void swapAmount(String? text) {
    double amount = 0.0000;
    if (text == null || text.isEmpty) {
    } else {
      if (isBuy) {
        amount = double.parse(text) / exchangeRate;
      } else {
        amount = double.parse(text) * exchangeRate;
      }
    }
    swapAmountController.text =
        amount.toStringAsFixed(currencyTarget.decimalPoint);
  }

  void updateAmount(String? text) {
    double amount = 0.0000;
    if (text == null || text.isEmpty) {
    } else {
      final number = num.tryParse(text);

      if (number != null) {
        amount = double.parse(text);
        double transferAmount = currencyOrigin.isPercentage
            ? amount * 100 / (100 + currencyOrigin.transactionFee)
            : amount - currencyOrigin.transactionFee;
        // double transferAmount = amount - fees;
        amountWithoutFeeController.text =
            transferAmount.toStringAsFixed(currencyOrigin.decimalPoint);
      }
    }
  }

  void updateFinalAmount(String? text) {
    double amount = 0.0000;
    if (text == null || text.isEmpty) {
    } else {
      final number = num.tryParse(text);

      if (number != null) {
        amount = double.parse(text);
        double fees = currencyOrigin.isPercentage
            ? amount * currencyOrigin.transactionFee / 100
            : currencyOrigin.transactionFee;
        double finalAmount = amount + fees;
        amountController.text =
            finalAmount.toStringAsFixed(currencyOrigin.decimalPoint);
      }
    }
  }

  void toggle() {
    enable = !enable;
    update();
  }

  void transfer() async {
    if (formKey.currentState!.validate()) {
      var result = await updateTransfer();
      //print(result);
      if (!result.containsKey("errors")) {
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ConfirmOTPScreen(
              exchangeOrders: order,
            ),
          ),
        );
      }
    }
  }

  updateTransfer() async {
    // loading = true;
    posting = true;
    update();
    var data = {
      "sourcecurrency": account.currency,
      "targetcurrency": targetCurrency,
      "isSwap": isSwap ? 1 : 0,
      "isBuy": isBuy ? 1 : 0,
      "sourceAccount": account.id,
      "targetAccount": accountController.text,
      "sourceAmount": amountController.text,
      "exchangerate": isSwap ? exchangeRate : 1
    };
    ApiRequest api = ApiRequest('exchangeorders', RequestType.post, data: data);
    var jsonResponse = await api.send();

    if (jsonResponse["errors"] == null) {
      order = ExchangeOrders.fromMap(jsonResponse);
      await sync.retriveData(keyName: Config.orders, data: jsonResponse);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonResponse["errors"]),
          backgroundColor: Colors.red,
        ),
      );
    }
    //  loading = false;
    posting = false;
    update();
    return jsonResponse;
  }

  @override
  String getTag() {
    return "transfer_controller";
  }

  fetchRatrData() async {
    loadRates = true;
    update();
    await sync.sync(section: Config.rates);
    List<dynamic> rawRates = await sync.retriveData(keyName: Config.rates);
    rates = Rates.getListFromJson(rawRates);
    if (rates.length > 0) {
      activeRate = rates[0];

      if (currencyTarget.symbol == "XAU") {
        exchangeRate = activeRate.ask;
        isBuy = true;
      } else {
        exchangeRate = activeRate.bid;
        isBuy = false;
      }
    }
    loadRates = false;
    update();
  }
}
