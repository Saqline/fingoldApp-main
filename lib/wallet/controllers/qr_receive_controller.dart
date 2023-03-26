import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

//import '../views/home_screen.dart';
import '../views/login_screen.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:fingold/utils/config.dart';

class RegisterController extends FxController {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  bool enable = false;

  @override
  void initState() {
    super.initState();
    save = false;
  }

  String? validateName(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter  name";
    }
    return null;
  }

  String? validateEmail(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter email";
    } else if (!FxStringValidator.isEmail(text)) {
      return "Please enter valid email";
    }
    return null;
  }

  String? validatePassword(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter password";
    } else if (!FxStringValidator.validateString(text,
        includeSpecialCharacter: true,
        includeAlphabet: true,
        includeDigit: true,
        minDigit: 1,
        minAlphabet: 1,
        minLength: 6,
        maxLength: 20)) {
      return "Password must have special character and number, minimum 6 chars";
    }
    return null;
  }

  String? validateConfirmPassword(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter confirm password";
    } else if (passwordController.text != text) {
      return "Both passwords are not same";
    }
    return null;
  }

  String? validateMobile(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter Mobile";
    } else if (!FxStringValidator.validateString(text,
        includeDigit: true,
        minDigit: 8,
        maxDigit: 20,
        maxAlphabet: 0,
        minAlphabet: 0,
        includeAlphabet: false)) {
      return "Please enter valid mobile number";
    }
    return null;
  }

  void toggle() {
    enable = !enable;
    update();
  }

  void goToLoginScreen() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  void register() async {
    if (formKey.currentState!.validate()) {
      var result = await updateRegister();
      if (!result.containsKey("errors")) {
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    }
  }

  updateRegister() async {
    // loading = true;
    save = true;
    update();

    var jsonResponse = {};
    // Await the http get response, then decode the json-formatted response.

    return jsonResponse;
  }

  @override
  String getTag() {
    return "register_controller";
  }
}
