import 'package:fingold/utils/apiRequest.dart';
import 'package:fingold/utils/commonSync.dart';
import 'package:fingold/wallet/models/exchangeorders.dart';
import 'package:fingold/wallet/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../views/login_screen.dart';
import 'package:fingold/utils/config.dart';

class OTPConfirmController extends FxController {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController otpController = TextEditingController();

  bool enable = false;
  bool expired = false;
  User user = User.empty();
  ExchangeOrders order = ExchangeOrders.empty();

  @override
  void initState() {
    super.initState();
    save = false;
  }

  void toggle() {
    enable = !enable;
    update();
  }

  void goToLoginScreen() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  void confirm() async {
    if (formKey.currentState!.validate()) {
      var result = await updateConfirm();
      if (!result.containsKey("errors")) {
        Navigator.of(context, rootNavigator: true).pop(true);
        Navigator.of(context, rootNavigator: true).pop(true);
      }
    }
  }

  void onEnd() {
    print("end");
    expired = true;
    update();
  }

  updateConfirm() async {
    // loading = true;
    save = true;
    update();
    var data = {'otp': otpController.text.trim()};
    ApiRequest api = ApiRequest(
        'confirmorders/' + order.id.toString(), RequestType.patch,
        data: data);
    var jsonResponse = await api.send();

    if (jsonResponse["errors"] == null) {
      CommonSync sync = CommonSync();
      await sync.sync();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Transaction Confirmed"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonResponse["errors"]),
          backgroundColor: Colors.red,
        ),
      );
    }
    //  loading = false;
    save = false;
    update();
    return jsonResponse;
  }

  @override
  String getTag() {
    return "confirm_opt_controller";
  }
}
