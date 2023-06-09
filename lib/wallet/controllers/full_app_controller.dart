//import 'package:fingold/wallet/models/user.dart';
import 'package:fingold/wallet/views/single_coin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';

////import '../views/home_screen.dart';
//import '../views/portfolio_screen.dart';
import '../views/profile_screen.dart';
import '../views/wallet_screen.dart';

class NavItem {
  final String title;
  final IconData iconData;

  NavItem(this.title, this.iconData);
}

class FullAppController extends FxController {
  int currentIndex = 0;
  int pages = 3;
  late TabController tabController;

  final TickerProvider tickerProvider;

  late List<NavItem> navItems;
  late List<Widget> items;

  FullAppController(this.tickerProvider) {
    tabController =
        TabController(length: pages, vsync: tickerProvider, initialIndex: 0);

    navItems = [
      NavItem('Wallet', Icons.account_balance_wallet_outlined),
      NavItem('Portfolio', FeatherIcons.pieChart),
      NavItem('Profile', FeatherIcons.user),
    ];

    items = [
      WalletScreen(),
      SingleCoinScreen(),
      // WalletScreen(),
      ProfileScreen()
    ];
  }

  @override
  void initState() {
    super.initState();
    tabController.addListener(handleTabSelection);
    tabController.animation!.addListener(() {
      final aniValue = tabController.animation!.value;
      if (aniValue - currentIndex > 0.5) {
        currentIndex++;
        update();
      } else if (aniValue - currentIndex < -0.5) {
        currentIndex--;
        update();
      }
    });
  }

  handleTabSelection() {
    currentIndex = tabController.index;
    print(currentIndex);
    update();
  }

  @override
  String getTag() {
    return "shopping_manager_full_app_controller";
  }
}
