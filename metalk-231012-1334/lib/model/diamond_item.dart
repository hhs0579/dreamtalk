import 'package:collection/collection.dart';

class DiamondItem {
  int coin;
  late int diamond;
  late int bonus;

  DiamondItem({
    required this.coin,
    int? diamond,
    int? bonus,
  }) {
    this.diamond = diamond ?? coinByPrice(coin);
    this.bonus = bonus ?? bonusByPrice(coin);
  }

  Map<int, int> get coinToDiamond => {
    3000: 30,
    5000: 50,
    10000: 100,
    30000: 300,
    90000: 900,
  };
  int coinByPrice(int coin) => coinToDiamond[coinToDiamond.keys.firstWhereOrNull((element) => element == coin) ?? coinToDiamond.keys.first]!;

  Map<int, int> get coinToBonusMap => {
    3000: 5,
    5000: 7,
    10000: 15,
    30000: 50,
    90000: 160,
  };
  int bonusByPrice(int coin) => coinToBonusMap[coinToBonusMap.keys.firstWhereOrNull((element) => element == coin) ?? coinToBonusMap.keys.first]!;
}