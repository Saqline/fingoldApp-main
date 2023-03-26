import 'package:fingold/utils/config.dart';
import 'package:flutter/material.dart';

class CustomIcon {
  Widget buttonIcon(String code, {Color color = Colors.grey}) {
    IconData icon = Icons.qr_code_scanner_sharp;
    print(code);
    if (code == Config.codeScan) {
      icon = Icons.qr_code_scanner_sharp;
    } else if (code == Config.codeTransfer) {
      icon = Icons.send;
    } else if (code == Config.codeTopup) {
      icon = Icons.add_card;
    } else if (code == Config.codeLiquidate) {
      icon = Icons.water_drop;
    } else if (code == Config.codeSwap) {
      icon = Icons.swap_horizontal_circle;
    } else if (code == Config.codeHistory) {
      icon = Icons.history;
    }
    else if (code == Config.codeInfo) {
      icon = Icons.info;
    }
    return Icon(
      icon,
      color: color,
      size: 64,
    );
  }

  Widget transactionIcon(int type) {
    IconData icon = Icons.send;
    Color color = Colors.grey;
    if (type == Config.transfer) {
      icon = Icons.send;
      color = Config.cTransfer;
    } else if (type == Config.tupup) {
      icon = Icons.add_card;
      color = Config.cTopup;
    } else if (type == Config.liquidate) {
      icon = Icons.water_drop;
      color = Config.cliquidate;
    } else if (type == Config.swap) {
      icon = Icons.swap_horizontal_circle;
      color = Config.cSwap;
    }
    return Icon(
      icon,
      color: color,
      size: 16,
    );
  }
}
