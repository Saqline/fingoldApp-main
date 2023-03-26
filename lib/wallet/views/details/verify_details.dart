//import 'package:fingold/images.dart';
import 'dart:io';

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
import 'package:image_picker/image_picker.dart';
//import '../controllers/register_controller.dart';

class VerifyDetailsScreen extends StatefulWidget {
  const VerifyDetailsScreen({Key? key}) : super(key: key);

  @override
  VerifyDetailsScreenState createState() => VerifyDetailsScreenState();
}

class VerifyDetailsScreenState extends State<VerifyDetailsScreen> {
  late ThemeData theme;
  late TransferController controller;
  late OutlineInputBorder outlineInputBorder;
  bool isSwap = false;
  CustomIcon icon = CustomIcon();
  String title = "Verify Information";
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
                  20,  0, 20, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    sourceField('AccountName', 'Imran Nur'),
                    ElevatedButton(
                        onPressed: () {
                          //controller.accountController = null;
                        },
                        child: Text('Verify')),
                    FxSpacing.height(20),
                    sourceField('AccountNumber', '1233444242'),
                    ElevatedButton(onPressed: () {}, child: Text('Verify')),
                    FxSpacing.height(20),
                    sourceField('NID Number', '56657777'),
                    ElevatedButton(onPressed: () {}, child: Text('Verify')),
                    FxSpacing.height(20),
                    imagePick(context,"NID/KYC"),
                    ElevatedButton(onPressed: () {}, child: Text('Verify')),
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
      //keyboardType: TextInputType.text,
      readOnly: false,
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
          hintStyle: FxTextStyle.bodySmall(xMuted: false),
          //suffixIcon: Icon(Icons.numbers),
          suffixText: " ",
          isCollapsed: true),
      maxLines: 1,
      //controller: controller.accountController,
      validator: validation.validateAccount,
      cursorColor: theme.colorScheme.onBackground,
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
          child: _image == null ? Text('No image selected for $text.') : Image.file(_image!),
        ),
        ElevatedButton(onPressed: getImage, child: Icon(Icons.add_a_photo),)
      ],
    );
  }

}
