/*
* File : Main File
* Version : 1.0.0
* */

//import 'package:fingold/wallet/views/home_screen.dart';
//import 'package:fingold/utils/LocalStore.dart';
//import 'package:fingold/utils/LocalStore.dart';
import 'dart:async';

import 'package:fingold/utils/commonSync.dart';
import 'package:fingold/wallet/views/full_app.dart';
import 'package:fingold/wallet/views/login_screen.dart';
import 'package:fingold/localizations/app_localization_delegate.dart';
import 'package:fingold/localizations/language.dart';
import 'package:fingold/theme/app_notifier.dart';
import 'package:fingold/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutx/themes/app_theme_notifier.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:fingold/wallet/models/user.dart';


import 'wallet/views/verification_screen.dart';

Future<void> main() async {
  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await GetStorage.init();

  AppTheme.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //check LoggedIn
  CommonSync sync = CommonSync();
  User user = User.empty();
  //LocalStore localStore = LocalStore();
  //await localStore.deleteAll();
  Map<String, dynamic> logindata = await sync.tokenData();
  // LocalStore().deleteAll();
  if (logindata.containsKey("accessToken")) {
    user = User.fromMap(logindata);
    AppTheme.loggedUser = user;
  }

  runApp(ChangeNotifierProvider<AppNotifier>(
    create: (context) => AppNotifier(),
    child: ChangeNotifierProvider<FxAppThemeNotifier>(
      create: (context) => FxAppThemeNotifier(),
      child: MyApp(user),
    ),
  ));
}

class MyApp extends StatelessWidget {
  final User user;
  MyApp(this.user);
  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (BuildContext context, AppNotifier value, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          builder: (context, child) {
            return Directionality(
              textDirection: AppTheme.textDirection,
              child: child!,
            );
          },
          localizationsDelegates: [
            AppLocalizationsDelegate(context),
            // Add this line
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: Language.getLocales(),
          // home: IntroScreen(),
          // home: SplashScreen(),
          home: user.accessToken.length > 20
              ? user.ev == 1
                  ? FinFoldApp()
                  : VerificationScreen(
                      email_mobile: user.email,
                      isEmail: true,
                    )
              : LoginScreen(),
        );
      },
    );
  }
}
