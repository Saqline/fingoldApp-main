import 'package:fingold/theme/app_notifier.dart';
//import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/utils/LocalStore.dart';
import 'package:fingold/utils/apiRequest.dart';
import 'package:fingold/utils/commonSync.dart';
import 'package:fingold/wallet/views/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:provider/provider.dart';

import '../nft_cache.dart';
import '../views/forgot_password_screen.dart';
import '../views/full_app.dart';
import 'package:fingold/wallet/views/register_screen.dart';
import 'dart:convert' as convert;
import 'package:fingold/utils/config.dart';

class LoginController extends FxController {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isChecked = true;
  CommonSync sync = CommonSync();
  //bool loading = true;
  @override
  void initState() {
    super.initState();
    save = false;
    // loading = false;
    this.emailController = TextEditingController(text: '');
    passwordController = TextEditingController(text: '');
    fetchData();
  }

  fetchData() async {
    await NFTCache.initDummy();
    /*
    Map<String, dynamic> logindata = await sync.tokenData();
    if (logindata.containsKey("accessToken")) {
      goToHomeScreen();
    }
    */
  }

  checkLogin() async {
    // loading = true;
    save = true;
    update();
    var data = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim()
    };
    ApiRequest api =
        ApiRequest('authWeb', RequestType.post, data: data, secured: false);
    var jsonResponse = await api.send();

    if (jsonResponse["errors"] == null) {
      final storage = LocalStore();
      await storage.save(Config.token, convert.jsonEncode(jsonResponse));

      if (jsonResponse["ev"] == 1) {
        Provider.of<AppNotifier>(context, listen: false).updateLogin();
        await sync.sync();
      }
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

  void goToRegisterScreen() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => RegisterScreen(),
      ),
    );
  }

  void goToForgotPasswordScreen() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ForgotPasswordScreen(),
      ),
    );
  }

  void goToHomeScreen() {
    //AppTheme.loggedUser;
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => FinFoldApp(),
      ),
    );
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      var result = await checkLogin();
      if (!result.containsKey("errors")) {
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              if (result["ev"] == 0) {
                return VerificationScreen(
                  email_mobile: result["email"],
                  isEmail: true,
                );
              } else {
                return FinFoldApp();
              }
            },
          ),
        );
      }
    }
  }

  @override
  String getTag() {
    return "shopping_login_controller";
  }
}
