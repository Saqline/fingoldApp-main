import 'dart:io';

import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/theme/constant.dart';
import 'package:fingold/wallet/views/bank_screen.dart';
import 'package:fingold/wallet/views/details/bank_details.dart';
import 'package:fingold/wallet/views/details/profile_details.dart';
import 'package:fingold/wallet/views/details/privacy_details.dart';
import 'package:fingold/wallet/views/details/refferal_details.dart';
import 'package:fingold/wallet/views/details/verify_details.dart';
import 'package:fingold/wallet/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import '../../theme/app_notifier.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ThemeData theme;
  late ProfileController controller;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = FxControllerStore.putOrFind(ProfileController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<ProfileController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: FxSpacing.fromLTRB(
                    20, FxSpacing.safeAreaTop(context) + 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imagePick(context,"Profile Picture"),
                    FxSpacing.height(4),
                    Align(
                        alignment: Alignment.center,
                        child: FxText.titleMedium(
                          AppTheme.loggedUser.name,
                          fontWeight: 700,
                        )),
                    FxSpacing.height(4),
                    verified(),
                    FxSpacing.height(20),
                    settings(),
                    FxSpacing.height(16),
                    logout(),
                    FxSpacing.height(16),
                    controller.deleting
                        ? Center(
                            child: SizedBox(
                              child: CircularProgressIndicator(),
                              width: 20,
                              height: 20,
                            ),
                          )
                        : deleteAccount(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget image() {
    return Center(
      child: FxContainer.rounded(
        height: 100,
        paddingAll: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Icon(Icons.person),
      ),
    );
  }

  Widget verified() {
    return Align(
      alignment: Alignment.center,
      child: FxContainer(
        padding: FxSpacing.fromLTRB(6, 4, 12, 4),
        borderRadiusAll: Constant.containerRadius.large,
        color: theme.colorScheme.primaryContainer,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: theme.colorScheme.onPrimaryContainer,
              size: 16,
            ),
            FxSpacing.width(8),
            FxText.bodySmall(
              "Verified",
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: 600,
            ),
          ],
        ),
      ),
    );
  }

  Widget settings() {
    final VoidCallback onBankPressed = () {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => BankDetailsScreen(),
        ),
      );
    };
    final VoidCallback onDashBoardPressed = () {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => ProfileDetailsScreen(),
        ),
      );
    };
    final VoidCallback onPrivacyPressed = () {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => PrivacyDetailsScreen(),
        ),
      );
    };
    final VoidCallback onVerifyPressed = () {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => VerifyDetailsScreen(),
        ),
      );
    };
    final VoidCallback onRefferalPressed = () {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => RefferalDetailsScreen(),
        ),
      );
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FxText.bodyMedium(
          "Account Settings",
          fontWeight: 500,
          xMuted: true,
        ),
        FxSpacing.height(15),
        singleRow(Icons.dashboard, "Profile", "Your Profile Details",
        onpress: onDashBoardPressed),
        Divider(),
        FxSpacing.height(8),
        singleRow(Icons.admin_panel_settings, "Privacy Setting",
            "PIN & Biometric security",
            onpress: onPrivacyPressed),
        FxSpacing.height(15),
        FxText.bodyMedium(
          "General Settings",
          fontWeight: 500,
          xMuted: true,
        ),
        FxSpacing.height(15),
        singleRow(
            Icons.account_balance, "Bank Account", "Manage your account bank",
            onpress: onBankPressed),
        Divider(),
        FxSpacing.height(8),
        singleRow(
            Icons.notifications, "Verify Documentation", "Manage your Documantion",
            onpress: onVerifyPressed),
        Divider(),
        FxSpacing.height(8),
        singleRow(Icons.redeem, "Refferal Code", "Manage your Refferal",
        onpress: onRefferalPressed
        ),
      ],
    );
  }

  Widget singleRow(IconData icon, String title, String subTitle,
      {VoidCallback? onpress}) {
    return Padding(
      padding: FxSpacing.bottom(8),
      child: InkWell(
        onTap: onpress,
        child: Row(
          children: [
            FxContainer.rounded(
              paddingAll: 12,
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            FxSpacing.width(20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.bodyMedium(
                    title,
                    fontWeight: 600,
                  ),
                  FxSpacing.height(2),
                  FxText.bodySmall(subTitle),
                ],
              ),
            ),
            FxSpacing.width(20),
            Icon(FeatherIcons.chevronRight, size: 18)
          ],
        ),
      ),
    );
  }

  Widget logout() {
    return Align(
      alignment: Alignment.center,
      child: FxButton.small(
        elevation: 0,
        onPressed: () {
          Provider.of<AppNotifier>(context, listen: false).updateLogout();
          print("I am out");
          Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
          print("I am out too");
        },
        borderRadiusAll: Constant.buttonRadius.xs,
        padding: FxSpacing.xy(16, 8),
        child: FxText.labelLarge(
          "Logout",
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget deleteAccount() {
    return Align(
      alignment: Alignment.center,
      child: FxButton.small(
        backgroundColor: Colors.red,
        elevation: 0,
        onPressed: () async {
          if (await confirm(context)) {
            controller.delete(AppTheme.loggedUser);
          }
        },
        borderRadiusAll: Constant.buttonRadius.xs,
        padding: FxSpacing.xy(16, 8),
        child: FxText.labelLarge(
          "Delete Account",
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget imagePick(BuildContext context,String text) {
    File? _image;

    Future getImage() async {
      final ImagePicker _picker = ImagePicker();
      var image = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image as File?;
      });
    }

    return Column(
      children: [
        Center(
          child: _image == null ? Text('No image selected for $text.',style: TextStyle(fontWeight: FontWeight.bold),) : Image.file(_image!),
        ),
        ElevatedButton(onPressed: getImage, child: Icon(Icons.add_a_photo),)
      ],
    );
  }


}
