import 'package:fingold/utils/LocalStore.dart';
import 'package:fingold/utils/apiRequest.dart';
import 'package:fingold/utils/commonSync.dart';
import 'package:fingold/wallet/models/accounts.dart';
import 'package:fingold/wallet/models/bank.dart';
import 'package:fingold/wallet/models/exchangeorders.dart';
import 'package:fingold/wallet/views/confirm_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:fingold/utils/config.dart';

class BankController extends FxController {
  Accounts account = Accounts.empty();
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController accountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController swiftController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  bool enable = false;
  bool posting = false;
  LocalStore localStore = LocalStore();
  ExchangeOrders order = ExchangeOrders.empty();
  Map<dynamic, dynamic> storeObj = {};
  Bank bank = Bank.empty();

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
    initialLoad = true;
    if (isSwap) {
      fetchBankData();
    } else {
      update();
    }
  }

  void toggle() {
    enable = !enable;
    update();
  }

  void saveBank() async {
    if (formKey.currentState!.validate()) {
      var result = await updateBank();
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

  updateBank() async {
    // loading = true;
    posting = true;
    update();
    var data = {
      "name": "account.currency",
    };
    ApiRequest api = ApiRequest('memberBank', RequestType.post, data: data);
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
    return "bank_controller";
  }

  fetchBankData() async {
    loadRates = true;
    update();
    await sync.getData(path: "memberBank");
    dynamic rawRates = await sync.retriveData(keyName: "memberBank");
    bank = Bank.fromMap(rawRates);

    loadRates = false;
    update();
  }
}
