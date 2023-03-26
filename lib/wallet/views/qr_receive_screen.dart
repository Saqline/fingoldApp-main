import 'package:fingold/images.dart';
import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/theme/constant.dart';
import 'package:fingold/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../controllers/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late ThemeData theme;
  late RegisterController controller;
  late OutlineInputBorder outlineInputBorder;
  Validation validation = Validation();
  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = FxControllerStore.putOrFind(RegisterController());
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
    return FxBuilder<RegisterController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            body: Padding(
              padding: FxSpacing.fromLTRB(
                  20, FxSpacing.safeAreaTop(context) + 20, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      Images.brandLogo,
                      width: 100,
                      height: 100,
                    ),
                    FxSpacing.height(20),
                    //Divider(),
                    FxText.titleLarge(
                      "Create an account",
                      fontWeight: 700,
                    ),
                    FxSpacing.height(20),
                    registerForm(),
                    FxSpacing.height(20),
                    controller.save
                        ? CircularProgressIndicator()
                        : registerBtn(),
                    FxSpacing.height(10),
                    loginBtn(),
                    FxSpacing.height(20),
                    Divider(),
                    //  FxSpacing.height(20),
                    // google(),
                    // FxSpacing.height(20),
                    // facebook(),
                    //  FxSpacing.height(20),
                    //  apple()
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget registerForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          emailField(),
          FxSpacing.height(20),
          mobileField(),
          FxSpacing.height(20),
          nameField(),
          FxSpacing.height(20),
          passwordField(),
          FxSpacing.height(20),
          passwordField(confirm: true),
          FxSpacing.height(20)
        ],
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

  Widget mobileField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: theme.cardTheme.color,
          hintText: "Mobile Phone with country code",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          isCollapsed: true),
      maxLines: 1,
      controller: controller.mobileController,
      validator: validation.validateMobile,
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  Widget passwordField({bool confirm = false}) {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: theme.cardTheme.color,
          hintText: !confirm ? "Password" : "Confirm Password",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          isCollapsed: true),
      maxLines: 1,
      maxLength: 20,
      controller: !confirm
          ? controller.passwordController
          : controller.passwordConfirmController,
      validator: !confirm
          ? validation.validatePassword
          : controller.validateConfirmPassword,
      cursorColor: theme.colorScheme.onBackground,
      obscureText: true,
    );
  }

  Widget nameField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: theme.cardTheme.color,
          hintText: "Name",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          isCollapsed: true),
      maxLines: 1,
      controller: controller.nameController,
      validator: validation.validateName,
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  Widget registerBtn() {
    return FxButton.block(
      onPressed: () {
        controller.register();
      },
      borderRadiusAll: Constant.buttonRadius.xs,
      elevation: 0,
      child: FxText.labelLarge(
        "Create your account",
        fontWeight: 700,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget loginBtn() {
    return FxButton.text(
      onPressed: () {
        controller.goToLoginScreen();
      },
      borderRadiusAll: Constant.buttonRadius.xs,
      child: FxText.bodySmall(
        "Already have an account?",
        fontWeight: 600,
        xMuted: true,
      ),
    );
  }

  Widget google() {
    return FxButton.block(
      elevation: 0,
      padding: FxSpacing.y(12),
      backgroundColor: theme.cardTheme.color,
      borderRadiusAll: Constant.buttonRadius.xs,
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            height: 20,
            width: 20,
            color: theme.colorScheme.primary,
            image: AssetImage(
              'assets/images/full_apps/nft/icons/google.png',
            ),
          ),
          FxSpacing.width(12),
          FxText.labelLarge(
            "Continue with Google",
            fontWeight: 700,
          ),
        ],
      ),
    );
  }

  Widget facebook() {
    return FxButton.block(
      elevation: 0,
      padding: FxSpacing.y(12),
      backgroundColor: theme.cardTheme.color,
      borderRadiusAll: Constant.buttonRadius.xs,
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            height: 20,
            width: 20,
            color: theme.colorScheme.primary,
            image: AssetImage('assets/images/full_apps/nft/icons/facebook.png'),
          ),
          FxSpacing.width(12),
          FxText.labelLarge(
            "Continue with Facebook",
            fontWeight: 700,
          ),
        ],
      ),
    );
  }

  Widget apple() {
    return FxButton.block(
      elevation: 0,
      padding: FxSpacing.y(12),
      backgroundColor: theme.cardTheme.color,
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            height: 20,
            width: 20,
            color: theme.colorScheme.primary,
            image: AssetImage('assets/images/full_apps/nft/icons/apple.png'),
          ),
          FxSpacing.width(12),
          FxText.labelLarge(
            "Continue with Apple",
            fontWeight: 700,
          ),
        ],
      ),
    );
  }
}
