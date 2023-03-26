import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/wallet/controllers/history_controller.dart';
import 'package:fingold/wallet/models/currency.dart';
//import 'package:fingold/utils/config.dart';
import 'package:fingold/wallet/models/transactions.dart';
import 'package:fingold/widgets/custom/icons.dart';
//import 'package:fingold/widgets/material/appbar/finAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:fingold/wallet/models/accounts.dart';

class HistoryScreen extends StatefulWidget {
  final Accounts account;
  const HistoryScreen({Key? key, required this.account}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late ThemeData theme;
  late HistoryController controller;
  Currency cur = Currency.empty();
  CustomIcon icon = CustomIcon();

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;

    controller = FxControllerStore.putOrFind(HistoryController());

    setState(() {
      cur = Currency.getCurrency(controller.currency, widget.account.currency);
      controller.currentCurrency = cur;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<HistoryController>(
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
                          // FxSpacing.height(20),
                          // coinsGrid(),
                          FxSpacing.height(20),
                          FxText.titleMedium(
                            "Latest Trasnactions ",
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
