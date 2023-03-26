import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/utils/common.dart';
import 'package:fingold/utils/config.dart';
import 'package:fingold/wallet/controllers/qr_controller.dart';
import 'package:fingold/widgets/custom/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:fingold/wallet/models/accounts.dart';

import 'package:barcode_widget/barcode_widget.dart';

class WalletLiquidateScreen extends StatefulWidget {
  final Accounts account;
  const WalletLiquidateScreen({Key? key, required this.account})
      : super(key: key);

  @override
  _WalletLiquidateScreenState createState() => _WalletLiquidateScreenState();
}

class _WalletLiquidateScreenState extends State<WalletLiquidateScreen> {
  late ThemeData theme;
  late QRController controller;
  CommonFunc cf = CommonFunc();
  CustomIcon icon = CustomIcon();
  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;

    controller = FxControllerStore.putOrFind(QRController());
  }

  @override
  Widget build(BuildContext context) {
    Color color =
        widget.account.currency == "USD" ? Config.fiat : Config.golden;
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
                              icon.buttonIcon(Config.codeLiquidate,
                                  color: color),
                              FxText.titleLarge(
                                "Comming Soon",
                                fontWeight: 700,
                              ),
                              FxSpacing.height(20),
                              FxSpacing.height(20),
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

    mywidgets.add(FxSpacing.height(4));
    mywidgets.add(FxText.titleLarge(
      widget.account.currency +
          " " +
          widget.account.balance.toStringAsFixed(2) +
          " ",
      fontWeight: 700,
    ));

    mywidgets.add(FxSpacing.height(4));

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
