//import 'package:fingold/images.dart';
import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/theme/constant.dart';
import 'package:fingold/utils/common.dart';
import 'package:fingold/utils/config.dart';
import 'package:fingold/utils/validation.dart';
import 'package:fingold/wallet/controllers/transfer_controller.dart';

//import 'package:fingold/wallet/models/currency.dart';
import 'package:fingold/widgets/custom/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//import '../controllers/register_controller.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({Key? key}) : super(key: key);

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<BankScreen> {
  late ThemeData theme;
  late TransferController controller;
  late OutlineInputBorder outlineInputBorder;
  bool isSwap = false;
  CustomIcon icon = CustomIcon();
  String title = "Bank Information";
  String currency = "";
  Color readOnly = Color.fromARGB(255, 249, 249, 212);
  Validation validation = Validation();
  // String transferFeeTitle = "";
  @override
  void initState() {
    super.initState();

    theme = AppTheme.nftTheme;
    controller = FxControllerStore.putOrFind(TransferController());

    outlineInputBorder = OutlineInputBorder(
      borderRadius:
          BorderRadius.all(Radius.circular(Constant.containerRadius.xs)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
    controller.accountController.text = "";
    controller.nameController.text = "";
    controller.amountController.text = "";
    controller.swapAmountController.text = "";
    controller.amountWithoutFeeController.text = "";

    setState(() {
      //controller.account = "";
      controller.loadData();
      // controller.targetCurrency = widget.targetAccount.currency;

      // print("BBBBB");

      // print(widget.account.currency);
      //controller.currencyOrigin = Currency.getCurrency(controller.curr  widget.account.currency);
      // print(controller.currencyOrigin.currencyName);
      // print("XXXXXX");
      controller.isSwap = isSwap;
    });
  }

/*
  @override
  void didChangeDependencies() {
    print('didChangeDependencies(), counter =');
    print(controller.account.currency);
    print(controller.currencyOrigin.currencyName);
    super.didChangeDependencies();
  }
*/
  @override
  Widget build(BuildContext context) {
    Color color = Config.fiat;
    return FxBuilder<TransferController>(
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
                    icon.buttonIcon(Config.codeSwap, color: color),

                    FxText.titleLarge(
                      title,
                      fontWeight: 700,
                    ),
                    FxSpacing.height(20),
                    //Divider(),
                    isSwap ? exchangeRate() : Text(""),
                    FxSpacing.height(20),
                    isSwap ? swapForm() : registerForm(),
                    FxSpacing.height(20),
                    controller.posting
                        ? CircularProgressIndicator()
                        : transferBtn(),
                    FxSpacing.height(10),

                    Divider(),
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
          accountField(),
          FxSpacing.height(20),
          nameField(),
          FxSpacing.height(20),
          amountField(),
          FxSpacing.height(20),
          finalAmountField(),
          FxSpacing.height(20),
        ],
      ),
    );
  }

  Widget swapForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          sourceAccountField(),
          FxSpacing.height(20),
          swapAmountField(),
          FxSpacing.height(20),
          targetAmountField(),
          FxSpacing.height(20),
        ],
      ),
    );
  }

  Widget exchangeRate() {
    String title = "";

    if (controller.isBuy) {
      title =
          "Exchange rate 1 gm @ ${controller.exchangeRate.toStringAsFixed(controller.currencyTarget.decimalPoint)}";
    } else {
      title =
          "Exchange rate 1 gm @ ${controller.exchangeRate.toStringAsFixed(controller.currencyTarget.decimalPoint)}";
    }
    return controller.loadRates ? CircularProgressIndicator() : Text(title);
  }

  Widget transferFee() {
    return controller.initialLoad ? Text("transferFeeTitle") : Text("");
  }

  Widget accountField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.number,
      readOnly: isSwap ? true : false,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: isSwap ? Colors.lightBlue : theme.cardTheme.color,
          hintText: "Account Number",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          suffixIcon: isSwap
              ? Icon(Icons.numbers)
              : IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: () async {
                    String barcodeScanRes;
                    // Platform messages may fail, so we use a try/catch PlatformException.
                    try {
                      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                          '#ff6666', 'Cancel', true, ScanMode.QR);
                      if (barcodeScanRes.length > 10) {
                        String dValue = CommonFunc().decrypted(barcodeScanRes);
                        List<String> accountInfo = dValue.split("##");
                        print("XXXXXXXX");
                        print(accountInfo);
                        if (accountInfo.length == 4 &&
                            accountInfo[0] == "fin-wallet") {
                          controller.accountController.text = accountInfo[1];
                          controller.nameController.text = accountInfo[3];
                          // controller.nameController.text = accountInfo[2];
                        }
                      }
                    } on PlatformException {
                      barcodeScanRes = 'Failed to get platform version.';
                    }
                  },
                ),
          isCollapsed: true),
      maxLines: 1,
      controller: controller.accountController,
      validator: validation.validateAccount,
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  Widget sourceAccountField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.number,
      readOnly: true,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: readOnly,
          hintText: "Account Number ",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          suffixIcon: Icon(Icons.numbers),
          suffixText: "Target account",
          isCollapsed: true),
      maxLines: 1,
      controller: controller.accountController,
      validator: validation.validateAccount,
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  Widget amountField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: theme.cardTheme.color,
          hintText: "Transfer amount",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          suffixIcon: Icon(Icons.money),
          suffixText: "Transfer amount in " + controller.currencyOrigin.unit,
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          isCollapsed: true),
      maxLines: 1,
      controller: controller.amountWithoutFeeController,
      validator: validation.validateAmount,
      onChanged: controller.updateFinalAmount,
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  Widget finalAmountField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: theme.cardTheme.color,
          hintText: "Final ",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          suffixIcon: Icon(Icons.money),
          suffixText: "+ fee (" +
              controller.currencyOrigin.transactionFee.toStringAsFixed(2) +
              " " +
              (controller.currencyOrigin.isPercentage
                  ? "%)"
                  : controller.currencyOrigin.unit + "/trans )"),
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          isCollapsed: true),
      maxLines: 1,
      controller: controller.amountController,
      validator: validation.validateAmount,
      onChanged: controller.updateAmount,
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  Widget targetAmountField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.number,
      readOnly: true,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: readOnly,
          hintText: "Swapped amount(" + controller.currencyTarget.unit + ")",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          suffixIcon: Icon(Icons.money),
          suffixText: "Swapped amount(" + controller.currencyTarget.unit + ")",
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          isCollapsed: true),
      maxLines: 1,
      controller: controller.swapAmountController,
      validator: validation.validateAmount,
      cursorColor: theme.colorScheme.onBackground,
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
          suffixIcon: Icon(Icons.people_outline),
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          isCollapsed: true),
      maxLines: 1,
      controller: controller.nameController,
      validator: validation.validateName,
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  Widget swapAmountField() {
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: theme.cardTheme.color,
          hintText: "Source amount(" + controller.currencyOrigin.unit + ")",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          suffixIcon: Icon(Icons.currency_exchange_sharp),
          suffixText: "Source amount(" + controller.currencyOrigin.unit + ")",
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          isCollapsed: true),
      maxLines: 1,
      controller: controller.amountController,
      validator: validation.validateAmount,
      cursorColor: theme.colorScheme.onBackground,
      onChanged: controller.swapAmount,
    );
  }

  Widget transferBtn() {
    Color color = Config.golden;
    return FxButton.block(
      onPressed: () {
        controller.transfer();
      },
      backgroundColor: color,
      borderRadiusAll: Constant.buttonRadius.xs,
      elevation: 0,
      child: FxText.labelLarge(
        isSwap ? "Swap" : "Transfer",
        fontWeight: 700,
        color: theme.colorScheme.onPrimary,
      ),
    );
  }
}
