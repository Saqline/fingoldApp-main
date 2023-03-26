/*
* File : Appbar widget
* Version : 1.0.0
* */

import 'package:fingold/images.dart';
import 'package:fingold/theme/app_notifier.dart';
import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/utils/config.dart';
import 'package:fingold/wallet/models/user.dart';
import 'package:fingold/wallet/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class FinAppBarWidget extends StatefulWidget {
  final User user;
  FinAppBarWidget(this.user);
  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<FinAppBarWidget> {
  late CustomTheme customTheme;
  late ThemeData theme;
  List<String> _simpleChoice = ["Add new", "Find me", "Contact", "Setting"];
  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      leading: IconButton(
        onPressed: () => () {}, // Navigator.of(context).pop(),
        icon: Image.asset(
          Images.brandLogo,
          alignment: const Alignment(-0.7, 0.0),
        ),
      ),
      titleSpacing: -9.0,
      title: FxText.titleMedium(widget.user.name, fontWeight: 500),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: CircleAvatar(
              backgroundColor: Config.golden,
              child: IconButton(
                icon: Icon(
                  Icons.logout,
                  size: 18,
                ),
                color: Colors.black,
                onPressed: () {
                  Provider.of<AppNotifier>(context, listen: false)
                      .updateLogout();
                  print("I am out");
                  Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                  print("I am out too");
                },
              )),
        ),
        /*
        Padding(
          padding: EdgeInsets.only(right: 0),
          child: PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return _simpleChoice.map((String choice) {
                return PopupMenuItem(
                  value: choice,
                  child: FxText(choice),
                  onTap: () {
                    Provider.of<AppNotifier>(context, listen: false)
                        .updateLogout();
                    print("I am out");
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                    print("I am out too");
                  },
                );
              }).toList();
            },
          ),
        ),*/
      ],
    );
  }
}
