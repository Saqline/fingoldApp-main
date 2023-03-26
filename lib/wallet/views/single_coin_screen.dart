import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/theme/constant.dart';
import 'package:fingold/utils/commonSync.dart';
import 'package:fingold/utils/config.dart';
import 'package:fingold/wallet/models/rates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/single_coin_controller.dart';
//import '../models/coin.dart';

class SingleCoinScreen extends StatefulWidget {
  //final Coin coin;

  const SingleCoinScreen({Key? key}) : super(key: key);

  @override
  _SingleCoinScreenState createState() => _SingleCoinScreenState();
}

class _SingleCoinScreenState extends State<SingleCoinScreen> {
  late ThemeData theme;
  late SingleCoinController controller;
  List<Rates> rates = [];
  CommonSync sync = CommonSync();
  double max = 60;
  double min = 50;
  @override
  void initState() {
    super.initState();
    theme = AppTheme.nftTheme;
    controller = FxControllerStore.putOrFind(SingleCoinController());
    fetchData();
  }

  fetchData() async {
    List<dynamic> rawRates = await sync.retriveData(keyName: Config.rates);

    rates = Rates.getListFromJson(rawRates);

    print("fetched");

    setState(() {
      Rates maxR =
          rates.reduce((curr, next) => curr.ask > next.ask ? curr : next);
      Rates minR =
          rates.reduce((curr, next) => curr.ask < next.ask ? curr : next);
      controller.rates = rates;
      max = maxR.ask;
      min = minR.ask;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<SingleCoinController>(
        controller: controller,
        theme: theme,
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              /*
              leading: InkWell(
                  onTap: () {
                    controller.goBack();
                  },
                  child: Icon(FeatherIcons.chevronLeft)),*/
            ),
            body: Padding(
              padding: FxSpacing.nTop(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxSpacing.height(20),
                        intervals(),
                        FxSpacing.height(40),
                        coinChart(),
                        // FxSpacing.height(40),
                        //  chartOption(),
                      ],
                    ),
                  ),
                  /*
                  FxButton.block(
                    onPressed: () {},
                    elevation: 0,
                    borderRadiusAll: Constant.buttonRadius.xs,
                    child: FxText.labelLarge(
                      "Buy Gold",
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),*/
                ],
              ),
            ),
          );
        });
  }

  Widget coinChart() {
    return SizedBox(
      height: 400,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        margin: EdgeInsets.zero,
        primaryXAxis: NumericAxis(
            isVisible: false,
            majorGridLines: MajorGridLines(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift),
        primaryYAxis: NumericAxis(
            isVisible: true,
            interval: 0.25,
            maximum: max,
            minimum: min,
            axisLine: AxisLine(width: 0),
            majorGridLines: MajorGridLines(width: 0),
            majorTickLines: MajorTickLines(size: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift),
        series: controller.getCoinSeries(),
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }

  Widget intervals() {
    List<Widget> list = [];
    for (int i = 0; i < controller.intervals.length; i++) {
      list.add(FxContainer.rounded(
        onTap: () {
          controller.changeInterval(i);
        },
        paddingAll: 12,
        color: controller.selected == i
            ? theme.colorScheme.primary
            : theme.scaffoldBackgroundColor,
        bordered: true,
        border: Border.all(
            color: controller.selected == i
                ? theme.colorScheme.primary
                : theme.dividerColor),
        child: Center(
            child: FxText.bodySmall(controller.intervals[i],
                fontWeight: 600,
                color: controller.selected == i
                    ? theme.colorScheme.onPrimary
                    : null)),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: list,
    );
  }

  Widget chartOption() {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          color: theme.colorScheme.primary,
        ),
        FxSpacing.width(4),
        FxText.bodyMedium(
          "USD",
          fontWeight: 600,
        ),
        FxSpacing.width(16),
        Icon(
          Icons.check_circle,
          color: theme.colorScheme.primary,
        ),
        FxSpacing.width(4),
        FxText.bodyMedium(
          "Market cap",
          fontWeight: 600,
        ),
      ],
    );
  }
}
