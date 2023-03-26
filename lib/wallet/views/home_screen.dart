import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/theme/constant.dart';
import 'package:fingold/utils/common.dart';
import 'package:fingold/utils/config.dart';
import 'package:fingold/wallet/models/currency.dart';
//import 'package:fingold/utils/config.dart';
import 'package:fingold/wallet/models/transactions.dart';
import 'package:fingold/widgets/custom/icons.dart';
//import 'package:fingold/widgets/material/appbar/finAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:fingold/wallet/models/accounts.dart';
import '../controllers/home_controller.dart';
import '../models/coin.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class HomeScreen extends StatefulWidget {
  final Accounts account;
  const HomeScreen({Key? key, required this.account}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ThemeData theme;
  late HomeController controller;
  Currency cur = Currency.empty();
  CustomIcon icon = CustomIcon();
  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;

    controller = FxControllerStore.putOrFind(HomeController());

    setState(() {
      cur = Currency.getCurrency(controller.currency, widget.account.currency);
      controller.currentCurrency = cur;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<HomeController>(
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
                  ? Padding(
                      padding: FxSpacing.fromLTRB(
                          20, FxSpacing.safeAreaTop(context) + 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          balance(),
                          FxSpacing.height(20),
                          FxSpacing.height(20),
                          coinsGrid(),
                          FxSpacing.height(20),
                          FxText.titleMedium(
                            "Latest Trasnactions",
                            fontWeight: 700,
                          ),
                          FxSpacing.height(20),
                          transactionList(),
                        ],
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
    // for (int x = 0; x < controller.accounts.length; x++) {
    mywidgets.add(FxSpacing.height(4));
    mywidgets.add(FxText.titleLarge(
      widget.account.balance.toStringAsFixed(cur.decimalPoint) + " " + cur.unit,
      fontWeight: 700,
    ));
    // }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: mywidgets,
        ),
        controller.refreshing
            ? CircularProgressIndicator()
            : FxContainer.roundBordered(
                onTap: () {
                  controller.refresh();
                },
                paddingAll: 8,
                color: theme.scaffoldBackgroundColor,
                child: Icon(
                  FeatherIcons.refreshCw,
                  size: 15,
                ),
              ),
      ],
    );
  }

  Widget coinsGrid() {
    return GridView.builder(
        padding: FxSpacing.zero,
        shrinkWrap: true,
        itemCount: controller.coins.length,
        physics: ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: controller.findAspectRatio(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (BuildContext context, int index) {
          return singleCoin(controller.coins[index]);
        });
  }

  Widget singleCoin(Coin coin) {
    Accounts targetAccount = Accounts.empty();
    if (coin.code == Config.codeSwap) {
      targetAccount = controller.accounts
          .firstWhere((element) => element.currency != widget.account.currency);
    } else {
      targetAccount.currency = widget.account.currency;
    }
    return FxContainer(
      onTap: () async {
        if (coin.code != Config.codeScan) {
          controller.goToScreen(widget.account, targetAccount, coin.code);
        } else {
          {
            String barcodeScanRes;
            // Platform messages may fail, so we use a try/catch PlatformException.
            try {
              barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                  '#ff6666', 'Cancel', true, ScanMode.QR);
              if (barcodeScanRes.length > 10) {
                String dValue = CommonFunc().decrypted(barcodeScanRes);
                List<String> accountInfo = dValue.split("##");
                print(accountInfo);
                if (accountInfo.length == 4 && accountInfo[0] == "fin-wallet") {
                  //controller.accountController.text = accountInfo[1];
                  //controller.nameController.text = accountInfo[2];
                  // controller.nameController.text = accountInfo[2];
                  if (accountInfo[2] == widget.account.currency) {
                    int id = int.parse(accountInfo[1]);
                    print(">>>>>>>${id}");
                    targetAccount = Accounts.fromIDAndCurrency(
                        id, accountInfo[2], accountInfo[3]);
                    controller.goToScreen(
                        widget.account, targetAccount, coin.code);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text("Source and Target musbe be same currency"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Invalid Qr Code"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            } on PlatformException {
              barcodeScanRes = 'Failed to get platform version.';
            }
          }
        }
      },
      paddingAll: 12,
      borderRadiusAll: Constant.containerRadius.xs,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon.buttonIcon(coin.code,
              color: cur.symbol == "USD" ? Config.fiat : Config.golden),
          FxSpacing.height(8),
          FxText.bodySmall(
            coin.name.toUpperCase(),
            fontWeight: 700,
            textAlign: TextAlign.center,
          ),
          FxSpacing.height(2),
          /*
          FxText.bodySmall(
            coin.price.toString(),
            xMuted: true,
            fontSize: 10,
          ),
          FxSpacing.height(8),
          FxText.bodySmall(
            coin.priceChange.toString(),
            fontWeight: 600,
            fontSize: 10,
          ),
          FxSpacing.height(2),
          
          FxText.bodySmall(
            coin.percentChange.toString() + "%",
            fontWeight: 600,
            color: (coin.percentChange.toString().startsWith("-"))
                ? theme.colorScheme.error
                : theme.colorScheme.primary,
            fontSize: 10,
          ),*/
          //FxSpacing.height(2),
        ],
      ),
    );
  }

  Widget transactionList() {
    // print("AAA=>");
    // print(cur.currencyName);
    return ListView.separated(
      shrinkWrap: true,
      padding: FxSpacing.zero,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 28,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        Transactions coin = controller.transactions[index];

        return InkWell(
          onTap: () {
            //controller.goToSingleCoinScreen(coin);
          },
          child: Row(
            children: [
              icon.transactionIcon(coin.transactionType),
              FxSpacing.width(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.bodySmall(
                      coin.comments.toUpperCase(),
                      fontWeight: 700,
                    ),
                    FxText.bodySmall(
                      coin.transactionTime,
                      fontSize: 10,
                    ),
                  ],
                ),
              ),
              FxSpacing.width(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FxText.bodySmall(
                    coin.amount.toStringAsFixed(cur.decimalPoint),
                    fontWeight: 600,
                    fontSize: 10,
                    textAlign: TextAlign.right,
                    color: coin.amount > 0 ? Colors.green : Colors.red,
                  ),
                  FxText.bodySmall(
                    coin.balance.toStringAsFixed(cur.decimalPoint),
                    color: (coin.balance.toString().startsWith("-"))
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    fontSize: 10,
                    textAlign: TextAlign.right,
                    fontWeight: 600,
                  ),
                ],
              ),
            ],
          ),
        );
      },
      itemCount: controller.transactions.length,
    );
  }
}
