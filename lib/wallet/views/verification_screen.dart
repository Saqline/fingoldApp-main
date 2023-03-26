import 'package:fingold/images.dart';
import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/theme/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../controllers/verification_controller.dart';

class VerificationScreen extends StatefulWidget {
  final String email_mobile;
  final bool isEmail;
  const VerificationScreen(
      {Key? key, required this.email_mobile, required this.isEmail})
      : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late ThemeData theme;
  late VerificationController controller;
  late OutlineInputBorder outlineInputBorder;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = FxControllerStore.putOrFind(VerificationController());
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
    String title = "Code has been sent to " + widget.email_mobile;
    return FxBuilder<VerificationController>(
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
                      FxText.titleMedium(
                        title,
                        fontWeight: 400,
                      ),
                      FxSpacing.height(40),
                      OTPForm(),
                      FxSpacing.height(20),
                      controller.save
                          ? CircularProgressIndicator()
                          : verifyBtn(),
                      FxSpacing.height(20),
                      registerBtn(),
                      FxSpacing.height(20),
                      FxText.titleSmall(
                        "Did't receive the code ?",
                        fontWeight: 400,
                      ),
                      FxSpacing.height(20),
                      resendBtn()
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget OTPForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [OTPField()],
      ),
    );
  }

  Widget OTPField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: theme.cardTheme.color,
          hintText: widget.isEmail ? "Email OTP" : "Mobile OTP",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          isCollapsed: true),
      maxLines: 1,
      maxLength: 6,
      controller: controller.codeController,
      validator: controller.validateCode,
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  Widget verifyBtn() {
    return FxButton.block(
      onPressed: () {
        controller.verifyCode();
      },
      elevation: 0,
      borderRadiusAll: Constant.textFieldRadius.xs,
      child: FxText.labelLarge(
        "Verify",
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

  Widget resendBtn() {
    return FxButton.block(
      onPressed: () {
        controller.resendCode(widget.email_mobile, widget.isEmail);
      },
      elevation: 0,
      borderRadiusAll: Constant.textFieldRadius.xs,
      child: FxText.labelLarge(
        "Resend",
        fontWeight: 700,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}
