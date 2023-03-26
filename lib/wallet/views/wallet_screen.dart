import 'package:fingold/images.dart';
import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/theme/constant.dart';
import 'package:fingold/utils/config.dart';
import 'package:fingold/wallet/models/accounts.dart';
import 'package:fingold/wallet/models/banners.dart';
import 'package:fingold/wallet/models/currency.dart';
import 'package:fingold/widgets/material/appbar/finAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import '../controllers/wallet_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import '../models/coin.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late ThemeData theme;
  late WalletController controller;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = FxControllerStore.putOrFind(WalletController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<WalletController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: PreferredSize(
              child: FinAppBarWidget(AppTheme.loggedUser),
              preferredSize: Size.fromHeight(50.0),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: FxSpacing.fromLTRB(
                    20, FxSpacing.safeAreaTop(context) + 5, 20, 0),
                child: Column(
                  children: [
                    controller.banners.length > 0
                        ? ImageSlideshow(
                            /// Width of the [ImageSlideshow].
                            width: double.infinity,

                            /// Height of the [ImageSlideshow].
                            height: 200,

                            /// The page to show when first creating the [ImageSlideshow].
                            initialPage: 0,

                            /// The color to paint the indicator.
                            indicatorColor: Colors.blue,

                            /// The color to paint behind th indicator.
                            indicatorBackgroundColor: Colors.grey,

                            /// The widgets to display in the [ImageSlideshow].
                            /// Add the sample image file into the images folder
                            children: bannersImages(),

                            /// Called whenever the page in the center of the viewport changes.
                            onPageChanged: (value) {
                              print('Page changed: $value');
                            },

                            /// Auto scroll interval.
                            /// Do not auto scroll with null or 0.
                            autoPlayInterval: 3000,

                            /// Loops back to first slide.
                            isLoop: true,
                          )
                        : Text(""),
                    FxSpacing.height(32),
                    buySellView(),
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
                    FxSpacing.height(20),
                    // balanceView(),
                    // FxSpacing.height(20),
                    coinsView(context),
                  ],
                ),
              ),
            ),
          );
        });
  }

  List<Widget> bannersImages() {
    List<Widget> list = [];
    for (int i = 0; i < controller.banners.length; i++) {
      Banners banner = controller.banners[i];
      list.add(
        CachedNetworkImage(
          imageUrl: banner.url,
          fit: BoxFit.cover,
          placeholder: (context, url) => SizedBox(
              height: 12,
              width: 12,
              child: Center(
                  child: CircularProgressIndicator(
                strokeWidth: 1.5,
              ))),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
    }
    return list;
  }

  Widget coinsView(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < controller.accounts.length; i++) {
      Accounts coin = controller.accounts[i];
      Currency cur =
          Currency.getCurrency(controller.currencyList, coin.currency);
      list.add(FxContainer.bordered(
        ///  onTap: () {
        // controller.goToSingleCoinScreen(coin);
        // },
        paddingAll: 12,
        margin: FxSpacing.bottom(20),
        borderRadiusAll: Constant.containerRadius.small,
        color: theme.scaffoldBackgroundColor,
        child: Row(
          children: [
            Image(
                height: 32,
                width: 32,
                image: cur.symbol == "USD"
                    ? AssetImage(Images.usd)
                    : AssetImage(Images.gold)),
            FxSpacing.width(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.bodyMedium(
                      cur.currencyName + "\nAC#" + coin.id.toString()),
                  FxSpacing.height(4),
                  FxText.bodyMedium(
                    coin.balance.toStringAsFixed(cur.decimalPoint) +
                        " " +
                        cur.unit,
                    fontWeight: 700,
                  ),
                ],
              ),
            ),
            FxButton.small(
              backgroundColor:
                  cur.symbol == "USD" ? Config.fiat : Config.golden,
              onPressed: () {
                controller.goToQRScreen(coin);
              },
              child: Icon(Icons.qr_code),
            ),
            FxSpacing.width(12),
            FxButton.small(
              backgroundColor:
                  cur.symbol == "USD" ? Config.fiat : Config.golden,
              onPressed: () {
                controller.goToWalletHomeScreen(coin);
              },
              child: Icon(Icons.wallet),
            ),
          ],
        ),
      ));
    }
    return Column(
      children: list,
    );
  }

  Widget buySellView() {
    return GridView.count(
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      childAspectRatio: (1 / .4),
      children: <Widget>[
        FxContainer.bordered(
          /*
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 88, 243, 148),
              border: Border.all(color: Colors.white12),
              borderRadius: BorderRadius.all(
                  Radius.circular(Constant.containerRadius.small))),*/
          padding: const EdgeInsets.all(8),
          //color: Color.fromARGB(255, 1, 133, 52),
          height: 200,
          child: Column(
            children: [
              FxText.titleMedium(
                "We buy",
                fontWeight: 600,
                color: theme.colorScheme.onPrimaryContainer,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FxText.bodySmall(
                    "\$" + controller.currentRate.bid.toStringAsFixed(2),
                    //  fontWeight: 400,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  FxText.bodySmall(
                    "(" + controller.currentRate.cbid.toStringAsFixed(2) + ")",
                    //    fontWeight: 400,
                    color: controller.currentRate.cbid > 0
                        ? Color.fromARGB(255, 6, 118, 11)
                        : Color.fromARGB(255, 199, 25, 13),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 250, 225, 165),
              border: Border.all(color: Colors.white12),
              borderRadius: BorderRadius.all(
                  Radius.circular(Constant.containerRadius.small))),
          height: 200,
          padding: const EdgeInsets.all(8),
          // color: Color.fromARGB(255, 237, 168, 9),
          child: Column(
            children: [
              FxText.titleMedium(
                "We sell",
                fontWeight: 600,
                //color: selected ? theme.colorScheme.onPrimaryContainer : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FxText.bodySmall(
                    "\$" + controller.currentRate.ask.toStringAsFixed(2),
                    // fontWeight: 400,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  FxText.bodySmall(
                    "(" + controller.currentRate.cask.toStringAsFixed(2) + ")",
                    // fontWeight: 400,
                    color: controller.currentRate.cask > 0
                        ? Color.fromARGB(255, 6, 118, 11)
                        : Color.fromARGB(255, 199, 25, 13),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget balanceView() {
    return FxContainer.bordered(
      borderRadiusAll: Constant.containerRadius.small,
      color: theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FxText.bodySmall(
            "Balance",
            xMuted: true,
            fontWeight: 600,
          ),
          FxText.bodyMedium(
            "\$ 4,556.46",
            fontWeight: 700,
          ),
          FxSpacing.height(16),
          balanceType(),
        ],
      ),
    );
  }

  Widget balanceType() {
    return Text("");
    // List<Widget> list = [];
    /*
    for (int i = 0; i < controller.balanceList.length; i++) {
      bool selected = controller.selectedBalanceType == i;
      list.add(FxContainer.bordered(
        onTap: () {
          controller.selectBalance(i);
        },
        padding: FxSpacing.xy(16, 6),
        margin: FxSpacing.right(16),
        color: selected
            ? theme.colorScheme.primary
            : theme.scaffoldBackgroundColor,
        border: Border.all(
            color: selected ? theme.colorScheme.primary : theme.dividerColor),
        borderRadiusAll: Constant.containerRadius.large,
        child: Row(
          children: [
            Icon(
              controller.balanceIcons[i],
              size: 20,
              color: selected ? theme.colorScheme.onPrimary : null,
            ),
            FxSpacing.width(12),
            FxText.bodySmall(
              controller.balanceList[i],
              fontWeight: 600,
              color: selected ? theme.colorScheme.onPrimary : null,
            ),
          ],
        ),
      ));
    }
    return Row(
      children: list,
    );
    */
  }
}
