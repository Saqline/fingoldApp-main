import 'package:fingold/theme/app_notifier.dart';
import 'package:fingold/utils/LocalStore.dart';
import 'package:fingold/utils/apiRequest.dart';
import 'package:fingold/utils/commonSync.dart';
import 'package:fingold/wallet/views/full_app.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:provider/provider.dart';
import '../views/register_screen.dart';
//import '../views/reset_password_screen.dart';
import 'dart:convert' as convert;
import 'package:fingold/utils/config.dart';

class VerificationController extends FxController {
  TextEditingController codeController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool resedCode = false;
  LocalStore localStore = LocalStore();
  String storeValue = "";
  Map<dynamic, dynamic> storeObj = {};
  @override
  void initState() async {
    super.initState();
    save = false;
    storeValue = await localStore.read(Config.token, isList: false);
    storeObj = convert.jsonDecode(storeValue) as Map<String, dynamic>;
    codeController = TextEditingController(text: '');
  }

  String? validateCode(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter OTP";
    }
    return null;
  }

  void verifyCode() async {
    if (formKey.currentState!.validate()) {
      var result = await sendVerifyCode();

      if (!result.containsKey("errors")) {
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(
            builder: (context) => FinFoldApp(),
          ),
        );
      }
    }
  }

  void goToRegisterScreen() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => RegisterScreen(),
      ),
    );
  }

  @override
  String getTag() {
    return "verification_controller";
  }

  sendVerifyCode({bool isResend = false, String email = ""}) async {
    // loading = true;
    save = true;
    update();
    String path = isResend ? "emailOtp" : "verifyEmail";
    localStore.read(Config.token);

    var data =
        isResend ? {'email': email} : {'emailotp': codeController.text.trim()};
    ApiRequest api = ApiRequest(path, RequestType.patch, data: data);
    var jsonResponse = await api.send();

    if (jsonResponse["errors"] == null) {
      storeObj["ev"] = 1;
      await localStore.save(Config.token, convert.jsonEncode(storeObj));

      await CommonSync().sync();
      Provider.of<AppNotifier>(context, listen: false).updateLogin();
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

  void resendCode(String emailMobile, bool isEmail) async {
    var result = await sendVerifyCode(isResend: true, email: emailMobile);

    if (!result.containsKey("errors")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please check email for new code"),
          backgroundColor: Colors.green,
        ),
      );
      /*
      Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(
            email: codeController.text,
          ),
        ),
      );
      */
    }
  }
}
