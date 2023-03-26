import 'package:fingold/utils/apiRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import '../views/register_screen.dart';
import '../views/reset_password_screen.dart';
import 'package:fingold/utils/config.dart';

class ForgotPasswordController extends FxController {
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    save = false;
    emailController = TextEditingController(text: '');
  }

  void forgotPassword() async {
    if (formKey.currentState!.validate()) {
      var result = await resetLoginPassword();
      if (!result.containsKey("errors")) {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(
              email: emailController.text,
            ),
          ),
        );
      }
    }
  }

  void goToRegisterScreen() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => RegisterScreen(),
      ),
    );
  }

  @override
  String getTag() {
    return "forgot_password_controller";
  }

  resetLoginPassword() async {
    save = true;
    update();
    var data = {'email': emailController.text.trim()};
    ApiRequest api = ApiRequest('resetPassword', RequestType.patch,
        data: data, secured: false);
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

    save = false;
    update();
    return jsonResponse;
  }
}
