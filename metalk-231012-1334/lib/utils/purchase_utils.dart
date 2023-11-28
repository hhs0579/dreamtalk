import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PurchaseUtils {
  static List<String> get storeProductIdList => [
    'metalk_consumable_3300',
    'metalk_consumable_5500',
    'metalk_consumable_11000',
    'metalk_consumable_33000', // isPopular
    'metalk_consumable_55000',
    'metalk_consumable_110000',
    'metalk_consumable_300000',
  ];

  static Future<void> init() async {
    bool isReady = await FlutterInappPurchase.instance.isReady();
    if (isReady == false) {
      Fluttertoast.showToast(msg: '인앱 구매가 지원되지 않는 기기입니다.');
    }

    var result = await FlutterInappPurchase.instance.initialize();
    debugPrint('FlutterInappPurchase initialize result: $result');
    if (Platform.isIOS) {
      await FlutterInappPurchase.instance.clearTransactionIOS();
    }
  }

  static int getPriceByIAPItem(IAPItem item) {
    return int.parse(item.productId!.replaceAll('metalk_consumable_', ''));
  }

}