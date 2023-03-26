import 'package:fingold/images.dart';
import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/theme/constant.dart';
import 'package:fingold/utils/validation.dart';
import 'package:fingold/wallet/controllers/confirm_otp_controller.dart';
import 'package:fingold/wallet/models/exchangeorders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class ConfirmOTPScreen extends StatefulWidget {
  final ExchangeOrders exchangeOrders;
  const ConfirmOTPScreen({Key? key, required this.exchangeOrders})
      : super(key: key);

  @override
  _ConfirmOTPScreenState createState() => _ConfirmOTPScreenState();
}

class _ConfirmOTPScreenState extends State<ConfirmOTPScreen> {
  late ThemeData theme;
  late OTPConfirmController controller;
  late OutlineInputBorder outlineInputBorder;
  Validation validation = Validation();
  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = FxControllerStore.putOrFind(OTPConfirmController());
    controller.order = widget.exchangeOrders;
    controller.user = AppTheme.loggedUser;

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
    return FxBuilder<OTPConfirmController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(FeatherIcons.chevronLeft)),
            ),
            body: Padding(
              padding: FxSpacing.fromLTRB(
                  20, FxSpacing.safeAreaTop(context) + 20, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      Images.otp,
                      width: 100,
                      height: 100,
                    ),
                    FxSpacing.height(20),
                    //Divider(),
                    FxText.titleLarge(
                      "Confirm your transaction",
                      fontWeight: 700,
                    ),
                    FxSpacing.height(3),
                    FxText.labelSmall(
                      "An OTP email has been sent to your email " +
                          AppTheme.loggedUser.email,
                      fontWeight: 700,
                    ),
                    CountdownTimer(
                      endTime: widget.exchangeOrders.expired,
                      onEnd: controller.onEnd,
                    ),
                    otpForm(),
                    FxSpacing.height(20),
                    controller.save
                        ? CircularProgressIndicator()
                        : controller.expired
                            ? Text("..")
                            : confirmBtn(),
                    FxSpacing.height(10),
                    // loginBtn(),
                    FxSpacing.height(20),
                    Divider(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget otpForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          otpField(),
          FxSpacing.height(20),
        ],
      ),
    );
  }

  Widget otpField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: theme.cardTheme.color,
          hintText: "OTP",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          isCollapsed: true),
      maxLines: 1,
      controller: controller.otpController,
      validator: validation.validateCode,
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  Widget confirmBtn() {
    return FxButton.block(
      onPressed: () {
        if (!controller.expired) {
          controller.confirm();
        }
      },
      borderRadiusAll: Constant.buttonRadius.xs,
      elevation: 0,
      child: FxText.labelLarge(
        "Confirm",
        fontWeight: 700,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }
}
