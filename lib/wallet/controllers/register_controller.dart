import 'package:fingold/utils/apiRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import '../views/login_screen.dart';
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

  String? validateConfirmPassword(String? text) {
    if (text == null || text.isEmpty) {
      return "Please enter confirm password";
    } else if (passwordController.text != text) {
      return "Both passwords are not same";
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
    var data = {
      'email': emailController.text.trim(),
      'name': nameController.text.trim(),
      'pass': passwordController.text.trim(),
      'mobile': mobileController.text.trim()
    };
    ApiRequest api =
        ApiRequest('reg', RequestType.post, data: data, secured: false);
    var jsonResponse = await api.send();

    // Await the http get response, then decode the json-formatted response.
    if (jsonResponse["errors"] == null) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonResponse['errors']),
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
    return "register_controller";
  }
}
