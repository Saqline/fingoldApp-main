/*
* File : Hotel Home
* Version : 1.0.0
* */

import 'package:fingold/theme/app_theme.dart';
//import 'package:fingold/screens/hotel/hotel_room_screen.dart';
import 'package:fingold/wallet/controllers/marchants_controller.dart';
import 'package:fingold/wallet/models/marchants.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MarchantsScreen extends StatefulWidget {
  const MarchantsScreen({Key? key}) : super(key: key);

  @override
  _MarchantsScreenState createState() => _MarchantsScreenState();
}

class _MarchantsScreenState extends State<MarchantsScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;
  late MarchantsController mController;
  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;

    mController = FxControllerStore.putOrFind(MarchantsController());
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<MarchantsController>(
        controller: mController,
        theme: theme,
        builder: (mController) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: theme.appBarTheme.backgroundColor,
                leading: BackButton(),
                titleSpacing: -9.0,
                title: FxText.titleMedium("Physical Stores", fontWeight: 500),
              ),
              resizeToAvoidBottomInset: false,
              body: Container(
                margin: FxSpacing.fromLTRB(
                    20, FxSpacing.safeAreaTop(context) + 20, 20, 0),
                child: Column(
                  children: <Widget>[
                    // _SearchWidget(),
                    //  FxSpacing.height(20),
                    //Text(mController.refreshing.toString()),
                    Expanded(
                      flex: 1,
                      child: mController.refreshing
                          ? Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : ListView(
                              shrinkWrap: true,
                              padding: FxSpacing.zero,
                              children:
                                  marchants(mController.marchants, context),
                            ),
                    ),
                  ],
                ),
              ));
        });
  }

  List<Widget> marchants(List<Marchants> marchants, BuildContext context) {
    List<Widget> wd = [];
    marchants.forEach((m) {
      // print("I AM HERE ");
      wd.add(Container(
          margin: EdgeInsets.only(top: 24),
          child: _SingleMarchantItem(
            image: m.image,
            name: m.name,
            phone: m.mobile,
            address: m.address + " " + m.city + " " + m.postcode,
            rating: 4.8,
            buildContext: context,
          )));
    });

    return wd;
  }
}

class _SearchWidget extends StatelessWidget {
  _pickDate(BuildContext context) async {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return FxContainer.bordered(
      marginAll: 0,
      color: Colors.transparent,
      paddingAll: 0,
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    style: FxTextStyle.titleSmall(
                      fontWeight: 500,
                    ),
                    decoration: InputDecoration(
                      hintStyle: FxTextStyle.titleSmall(fontWeight: 500),
                      hintText: "Hotels near me",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      prefixIcon: Icon(
                        MdiIcons.magnify,
                        size: 22,
                        color: theme.colorScheme.onBackground,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.only(top: 14),
                    ),
                    autofocus: false,
                    textInputAction: TextInputAction.search,
                    textCapitalization: TextCapitalization.sentences,
                    controller: TextEditingController(text: ""),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 16, left: 16),
                  child: InkWell(
                    onTap: () {
                      _pickDate(context);
                    },
                    child: Icon(
                      MdiIcons.calendarOutline,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                )
              ],
            ),
            Divider(
              thickness: 1,
              height: 0,
              color: theme.dividerColor,
            ),
            Container(
              margin: EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FxText.bodySmall("Check in", fontWeight: 500),
                            FxText.bodyLarge("28 May", fontWeight: 600),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FxText.bodySmall("Check out", fontWeight: 500),
                            FxText.bodyLarge("31 May", fontWeight: 600),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FxText.bodySmall("Person", fontWeight: 500),
                            FxText.bodyLarge("2 Couple", fontWeight: 600),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SingleMarchantItem extends StatefulWidget {
  final String name, address, image;
  final String phone;
  final double rating;
  final BuildContext buildContext;

  const _SingleMarchantItem(
      {Key? key,
      required this.name,
      required this.address,
      required this.image,
      required this.phone,
      required this.rating,
      required this.buildContext})
      : super(key: key);

  @override
  _SingleMarchantItemState createState() => _SingleMarchantItemState();
}

class _SingleMarchantItemState extends State<_SingleMarchantItem> {
  late ThemeData theme;
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return InkWell(
      onTap: () {
        /*
        Navigator.push(
            widget.buildContext,
            PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 500),
                transitionsBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) =>
                    FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                pageBuilder: (_, __, ___) => HotelRoomScreen()));
                */
      },
      child: FxContainer(
        paddingAll: 0,
        borderRadiusAll: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                child: Image(
                  image: NetworkImage(widget.image),
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                )),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FxText.titleMedium(widget.name, fontWeight: 600),
                      FxText.bodySmall(widget.phone, fontWeight: 600),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  MdiIcons.mapMarker,
                                  color: theme.colorScheme.onBackground,
                                  size: 14,
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 2),
                                    child: FxText.bodySmall(widget.address,
                                        fontWeight: 500)),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 2),
                              child: Row(
                                children: <Widget>[
                                  Icon(MdiIcons.star,
                                      color: theme.colorScheme.onBackground,
                                      size: 14),
                                  Container(
                                    margin: EdgeInsets.only(left: 4),
                                    child: FxText.bodySmall(
                                        widget.rating.toString() + " Ratings",
                                        fontWeight: 500),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        TextButton(
                            onPressed: () async {
                              /*
                              Navigator.push(
                                  widget.buildContext,
                                  PageRouteBuilder(
                                      transitionDuration:
                                          Duration(milliseconds: 500),
                                      transitionsBuilder: (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child,
                                      ) =>
                                          FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          ),
                                      pageBuilder: (_, __, ___) =>
                                          HotelRoomScreen()));
                                          */
                              await _makePhoneCall(widget.phone);
                            },
                            child: FxText.bodySmall("Call",
                                fontWeight: 600,
                                color: theme.colorScheme.primary)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
