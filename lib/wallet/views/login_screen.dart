import 'package:fingold/images.dart';
import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/theme/constant.dart';
import 'package:fingold/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late ThemeData theme;
  late LoginController controller;
  late OutlineInputBorder outlineInputBorder;
  bool passwordVisible = false;
  Validation validation = Validation();
  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = FxControllerStore.putOrFind(LoginController());
    outlineInputBorder = OutlineInputBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(Constant.containerRadius.xs)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(controller.save);
    return FxBuilder<LoginController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            body: Padding(
              padding: FxSpacing.fromLTRB(
                  20, FxSpacing.safeAreaTop(context) + 40, 20, 0),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        Images.brandLogo,
                        width: 100,
                        height: 100,
                      ),

                      FxText.titleLarge(
                        "Login to your account",
                        fontWeight: 700,
                      ),
                      FxSpacing.height(40),
                      loginForm(),
                      FxSpacing.height(10),
                      forgotPasswordBtn(),
                      FxSpacing.height(10),
                      controller.save
                          ? CircularProgressIndicator(
                              //value: controller.value,
                              semanticsLabel: 'Authentication is progress...',
                            )
                          : loginBtn(),
                      FxSpacing.height(10),
                      registerBtn(),
                      FxSpacing.height(20),
                      //  Divider(),
                      FxSpacing.height(20),
                      //  google(),
                      FxSpacing.height(20),
                      // facebook(),
                      //  FxSpacing.height(20),
                      // apple()
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget loginForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [emailField(), FxSpacing.height(20), passwordField()],
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: theme.cardTheme.color,
          hintText: "Email Address",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          isCollapsed: true),
      maxLines: 1,
      controller: controller.emailController,
      validator: validation.validateEmail,
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  Widget passwordField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.visiblePassword,
      obscureText: !passwordVisible, //This will obscure text dynamically
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: theme.cardTheme.color,
          hintText: "Password",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
          ),
          isCollapsed: true),
      maxLines: 1,
      controller: controller.passwordController,
      validator: validation.validatePassword,
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  Widget loginBtn() {
    return FxButton.block(
      onPressed: () {
        controller.login();
      },
      borderRadiusAll: Constant.buttonRadius.xs,
      elevation: 0,
      child: FxText.labelLarge(
        "Login to your account",
        fontWeight: 700,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget registerBtn() {
    return FxButton.text(
      onPressed: () {
        controller.goToRegisterScreen();
      },
      child: FxText.bodySmall(
        "Don\'t have an account?",
        fontWeight: 600,
        xMuted: true,
      ),
    );
  }

  Widget forgotPasswordBtn() {
    return Align(
      alignment: Alignment.centerRight,
      child: FxButton.text(
        padding: FxSpacing.zero,
        onPressed: () {
          controller.goToForgotPasswordScreen();
        },
        child: FxText.bodySmall(
          "Forgot password?",
          fontWeight: 600,
          xMuted: true,
        ),
      ),
    );
  }
}
