import 'dart:math';

import 'package:fingold/theme/app_theme.dart';
import 'package:fingold/utils/commonSync.dart';
import 'package:fingold/utils/config.dart';
import 'package:fingold/wallet/models/rates.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/coin.dart';

class SplineAreaData {
  SplineAreaData(this.x, this.y);

  final double x;
  final double y;
}

class SingleCoinController extends FxController {
  SingleCoinController();

  List<String> intervals = [];
  int selected = 1;
  List<Rates> rates = [];
  CommonSync sync = CommonSync();
  @override
  void initState() {
    super.initState();
    save = false;
    intervals = ["1hr", "1d", "1w", "1m", "1y", "All"];
    //fetchData();
  }

  void changeInterval(int index) {
    if (selected != index) {
      selected = index;
      update();
    }
  }

  fetchData() async {
    List<dynamic> rawRates = await sync.retriveData(keyName: Config.rates);

    rates = Rates.getListFromJson(rawRates);
    print("fetched");

    update();
  }

  List<ChartSeries<SplineAreaData, double>> getCoinSeries() {
    return <ChartSeries<SplineAreaData, double>>[
      SplineAreaSeries<SplineAreaData, double>(
        dataSource: generateChartData(),
        gradient: LinearGradient(
          colors: [
            AppTheme.nftTheme.colorScheme.primary.withAlpha(100),
            AppTheme.nftTheme.colorScheme.primary.withAlpha(60),
            AppTheme.nftTheme.colorScheme.primary.withAlpha(40),
            AppTheme.nftTheme.colorScheme.primary.withAlpha(20),
            AppTheme.nftTheme.colorScheme.primary.withAlpha(0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderColor: AppTheme.customTheme.fitnessPrimary,
        borderWidth: 2,
        xValueMapper: (SplineAreaData sales, _) => sales.x,
        yValueMapper: (SplineAreaData sales, _) => sales.y,
      ),
    ];
  }

  List<SplineAreaData> generateChartData() {
    List<SplineAreaData> data = [];

    int i = 0;

    rates.forEach((element) {
      data.add(SplineAreaData((i).toDouble(), element.ask));

      i++;
    });
    return data;

    /*
    return List.generate(
        16,
        (index) => SplineAreaData(
            (index).toDouble(), (5000 + random.nextInt(800)).toDouble()));
  
    */
  }

  void goBack() {
    Navigator.pop(context);
  }

  @override
  String getTag() {
    return "single_coin_controller";
  }
}
