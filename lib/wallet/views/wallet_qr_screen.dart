import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/utils/common.dart';
import 'package:fingold/utils/config.dart';
import 'package:fingold/wallet/controllers/qr_controller.dart';
import 'package:fingold/wallet/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:fingold/wallet/models/accounts.dart';

import 'package:barcode_widget/barcode_widget.dart';

class WalletQrScreen extends StatefulWidget {
  final Accounts account;
  const WalletQrScreen({Key? key, required this.account}) : super(key: key);

  @override
  _WalletQrScreenState createState() => _WalletQrScreenState();
}

class _WalletQrScreenState extends State<WalletQrScreen> {
  late ThemeData theme;
  late QRController controller;
  CommonFunc cf = CommonFunc();
  Currency cur = Currency.empty();
  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;

    controller = FxControllerStore.putOrFind(QRController());
    setState(() {
      cur = Currency.getCurrency(controller.currency, widget.account.currency);
      controller.currentCurrency = cur;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color =
        widget.account.currency == "USD" ? Config.fiatDark : Config.goldenDark;
    return FxBuilder<QRController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(leading: BackButton(color: Colors.black)),
            /*
            appBar: PreferredSize(
              child: FinAppBarWidget(AppTheme.loggedUser),
              preferredSize: Size.fromHeight(50.0),
            ),*/
            body: SingleChildScrollView(
              child: controller.loaded
                  ? Center(
                      child: Padding(
                        padding: FxSpacing.fromLTRB(
                            20, FxSpacing.safeAreaTop(context) + 20, 20, 0),
                        child: FxContainer.bordered(
                          width: MediaQuery.of(context).size.width - 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              balance(),
                              FxSpacing.height(20),
                              FxSpacing.height(20),
                              qrCode(
                                  cf.encrypt(
                                      "fin-wallet##${widget.account.id}##${widget.account.currency}##${widget.account.accountName}"),
                                  200.00,
                                  color: color),
                              FxSpacing.height(20),
                              FxText.titleMedium(
                                "Account# " + widget.account.id.toString(),
                                fontWeight: 700,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                      heightFactor: 15,
                    ),
            ),
          );
        });
  }

  Widget balance() {
    List<Widget> mywidgets = [];

    mywidgets.add(FxSpacing.height(1));
    mywidgets.add(FxText.titleLarge(
      widget.account.balance.toStringAsFixed(cur.decimalPoint) + " " + cur.unit,
      fontWeight: 700,
    ));

    mywidgets.add(FxSpacing.height(2));
    mywidgets.add(FxText.bodyMedium(
      widget.account.accountName,
      fontWeight: 400,
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: mywidgets,
    );
  }

  Widget qrCode(String data, double size,
      {Color color = const Color.fromARGB(223, 196, 120, 5)}) {
    return BarcodeWidget(
      barcode: Barcode.qrCode(), // Barcode type and settings
      data: data, // Content
      width: size,
      height: size,
      color: color,
    );
  }
}
