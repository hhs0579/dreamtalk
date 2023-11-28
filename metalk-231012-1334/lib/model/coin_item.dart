import 'package:collection/collection.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class CoinItem {
  int price;
  late int coin;
  late int bonus;
  bool isPopular;
  IAPItem iapItem;

  CoinItem({
    required this.price,
    int? coin,
    int? bonus,
    this.isPopular = false,
    required this.iapItem,
  }) {
    this.coin = coin ?? coinByPrice(price);
    this.bonus = bonus ?? bonusByPrice(price);
  }

  Map<int, int> get priceToCoinMap => {
    3300: 1000,
    5500: 1650,
    11000: 3300,
    33000: 10000,
    55000: 17000,
    110000: 33000,
    300000: 91000,
  };
  int coinByPrice(int price) => priceToCoinMap[priceToCoinMap.keys.firstWhereOrNull((element) => element == price) ?? priceToCoinMap.keys.first]!;

  Map<int, int> get priceToBonusMap => {
    3300: 50,
    5500: 70,
    11000: 150,
    33000: 500,
    55000: 750,
    110000: 1500,
    300000: 4500,
  };
  int bonusByPrice(int price) => priceToBonusMap[priceToBonusMap.keys.firstWhereOrNull((element) => element == price) ?? priceToBonusMap.keys.first]!;
}