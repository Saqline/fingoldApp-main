import 'package:fingold/utils/LocalStore.dart';
import 'package:fingold/wallet/models/user.dart';
import 'package:fingold/wallet/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:fingold/utils/apiRequest.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:fingold/utils/config.dart';

class ProfileController extends FxController {
  bool deleting = false;
  void goBack() {
    Navigator.pop(context);
  }

  @override
  String getTag() {
    return "profile_controller";
  }

  deleteAccount(User user) async {
    // loading = true;
    deleting = true;
    update();

    ApiRequest api =
        ApiRequest('members/' + user.userId.toString(), RequestType.delete);
    var jsonResponse = await api.send();

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
    deleting = false;
    update();
    return jsonResponse;
  }

  void delete(User user) async {
    var result = await deleteAccount(user);
    if (!result.containsKey("errors")) {
      await LocalStore().deleteAll();
      Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
      );
    }
  }
}
