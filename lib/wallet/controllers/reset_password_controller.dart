
import 'package:fingold/utils/apiRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import '../views/login_screen.dart';
import '../views/register_screen.dart';

import 'package:fingold/utils/config.dart';

class ResetPasswordController extends FxController {
  late TextEditingController confirmPasswordTE, passwordTE, resetCode;
  GlobalKey<FormState> formKey1 = GlobalKey();
  bool enableConfirmPass = false;
  bool enablePass = false;
  String email = "";

  @override
  void initState() {
    super.initState();
    confirmPasswordTE = TextEditingController(text: '');
    passwordTE = TextEditingController(text: '');
    resetCode = TextEditingController(text: '');
  }

  String? validateConfirmPassword(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter password";
    } else if (!FxStringValidator.validateStringRange(
      text,
    )) {
      return "Password length must between 8 and 20";
    } else if (passwordTE.text != text) {
      return "Both passwords are not same";
    }
    return null;
  }

  void togglePassword() {
    enablePass = !enablePass;
    update();
  }

  void toggleConfirmPassword() {
    enableConfirmPass = !enableConfirmPass;
    update();
  }

  void resetPassword() async {
    if (formKey1.currentState!.validate()) {
      var result = await updatePassword();
      if (!result.containsKey("errors")) {
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
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
    return "reset_password_controller";
  }

  updatePassword() async {
    // loading = true;
    save = true;
    update();
    var data = {
      'email': email,
      'newPass': passwordTE.text.trim(),
      'code': resetCode.text.trim()
    };
    ApiRequest api =
        ApiRequest('resetPass', RequestType.patch, data: data, secured: false);
    var jsonResponse = await api.send();

    // Await the http get response, then decode the json-formatted response.
    if (jsonResponse["errors"] == null) {
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
}
