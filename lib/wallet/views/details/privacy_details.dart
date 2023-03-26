//import 'package:fingold/images.dart';
import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/theme/constant.dart';

import 'package:fingold/utils/config.dart';
import 'package:fingold/utils/validation.dart';
import 'package:fingold/wallet/controllers/transfer_controller.dart';

//import 'package:fingold/wallet/models/currency.dart';
import 'package:fingold/widgets/custom/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
//import '../controllers/register_controller.dart';

class PrivacyDetailsScreen extends StatefulWidget {
  const PrivacyDetailsScreen({Key? key}) : super(key: key);

  @override
  PrivacyDetailsScreennState createState() => PrivacyDetailsScreennState();
}

class PrivacyDetailsScreennState extends State<PrivacyDetailsScreen> {
  late ThemeData theme;
  late TransferController controller;
  late OutlineInputBorder outlineInputBorder;
  bool isSwap = false;
  CustomIcon icon = CustomIcon();
  String title = "Privacy Information";
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
  }

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
                    icon.buttonIcon(Config.codeInfo, color: color),
                    FxText.titleLarge(
                      title,
                      fontWeight: 700,
                    ),
                    FxSpacing.height(20),
                    Center(
                      child: Text(
                        'Tap Every Field for Info',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                    FxSpacing.height(20),
                    sourceField('Password', '123456a@'),
                    FxSpacing.height(20),
                    sourceField('Pin', '1234'),
                    FxSpacing.height(20),
                    changePassword(context),
                    FxSpacing.height(10),
                    Divider(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget sourceField(String textT, String textD) {
    //String text;
    //sourceAccountField({required this.text});
    return TextFormField(
      style: FxTextStyle.bodyMedium(),
      keyboardType: TextInputType.number,
      readOnly: true,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          isDense: true,
          filled: true,
          fillColor: readOnly,
          hintText: "$textT",
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          border: outlineInputBorder,
          contentPadding: FxSpacing.all(16),
          hintStyle: FxTextStyle.bodySmall(xMuted: true),
          //suffixIcon: Icon(Icons.numbers),
          suffixText: " $textD",
          isCollapsed: true),
      maxLines: 1,
      controller: controller.accountController,
      validator: validation.validateAccount,
      cursorColor: theme.colorScheme.onBackground,
    );
  }

  Widget changePassword(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String _currentPassword;
    String? _newPassword;
    String _confirmNewPassword;
    return ElevatedButton(
      onPressed: () {
        print('onTap pressed');
        showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('Change Password'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Current Password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your current password.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _currentPassword = value!;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'New Password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a new password.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newPassword = value!;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration:
                      InputDecoration(labelText: 'Confirm New Password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please confirm your new password.';
                        }
                        if (value != _newPassword) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _confirmNewPassword = value!;
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Save'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // TODO: implement password change logic
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },

        );
      },
      child: Text('Change password',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black)),
    );
  }
}
