//import 'package:fingold/utils/LocalStore.dart';
import 'package:fingold/utils/commonSync.dart';
import 'package:fingold/utils/config.dart';
import 'package:fingold/wallet/models/marchants.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

class MarchantsController extends FxController {
  CommonSync sync = CommonSync();
  List<Marchants> marchants = [];
  bool refreshing = false;
  int max = 15;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fetchData() async {
    refreshing = true;
    update();
    int now = DateTime.now().millisecondsSinceEpoch;
    int prevSync = await sync.lastSync(marchants: true);
    print("====>${prevSync}");
    int diff = int.parse(((now - prevSync) / 60000).toStringAsFixed(0));

    if (diff > 30) {
      await sync.sync(section: Config.marchants);
    }
    List<dynamic> rawAcc = await sync.retriveData(keyName: Config.marchants);

    marchants = Marchants.getListFromJson(rawAcc);
    refreshing = false;
    update();
  }

  double findAspectRatio() {
    double width = MediaQuery.of(context).size.width;
    return ((width - 72) / 3) / (133);
  }

  @override
  String getTag() {
    return "marchants_controller";
  }
}
