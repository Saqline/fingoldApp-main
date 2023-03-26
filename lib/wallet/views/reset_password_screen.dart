import 'package:fingold/images.dart';
import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/theme/constant.dart';
import 'package:fingold/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../controllers/reset_password_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late ThemeData theme;
  late ResetPasswordController controller;
  late OutlineInputBorder outlineInputBorder;
  Validation validation = Validation();
  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = FxControllerStore.putOrFind(ResetPasswordController());
    controller.email = widget.email;
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
    return FxBuilder<ResetPasswordController>(
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
                        "Enter new Password",
                        fontWeight: 700,
                      ),
                      FxSpacing.height(40),
                      FxText.titleSmall(
                        "If you have an account a Reset-Code has been sent to " +
                            widget.email,
                        fontWeight: 400,
                      ),
                      FxSpacing.height(40),
                      resetPasswordForm(),
                      FxSpacing.height(20),
                      resetPasswordBtn(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget resetPasswordForm() {
    return Form(
      key: controller.formKey1,
      child: Column(
        children: [
          resetCode(),
          FxSpacing.height(20),
          passwordField(),
          FxSpacing.height(20),
          resetPasswordField()
        ],
      ),
    );
  }

  Widget resetCode() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: theme.cardTheme.color,
          hintText: "Reset Code",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          isCollapsed: true),
      maxLines: 1,
      controller: controller.resetCode,
      validator: validation.validateCode,
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  Widget passwordField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.emailAddress,
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
          isCollapsed: true),
      maxLines: 1,
      obscureText: true,
      controller: controller.passwordTE,
      validator: validation.validatePassword,
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  Widget resetPasswordField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: theme.cardTheme.color,
          hintText: "Confirm Password",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          isCollapsed: true),
      maxLines: 1,
      obscureText: true,
      controller: controller.confirmPasswordTE,
      validator: controller.validateConfirmPassword,
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  Widget resetPasswordBtn() {
    return FxButton.block(
      onPressed: () {
        controller.resetPassword();
      },
      elevation: 0,
      borderRadiusAll: Constant.textFieldRadius.xs,
      child: FxText.labelLarge(
        "Reset Password",
        fontWeight: 700,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }
}
