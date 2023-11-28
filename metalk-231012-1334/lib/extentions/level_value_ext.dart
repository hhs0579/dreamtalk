enum LevelValueExt {
  lv0(minCoin: 0, level: 0),
  lv1(minCoin: 1000, level: 1),
  lv2(minCoin: 3000, level: 2),
  lv3(minCoin: 6000, level: 3),
  lv4(minCoin: 12000, level: 4),
  lv5(minCoin: 24000, level: 5),
  lv6(minCoin: 36000, level: 6),
  lv7(minCoin: 54000, level: 7),
  lv8(minCoin: 81000, level: 8),
  lv9(minCoin: 121000, level: 9),
  lv10(minCoin: 182000, level: 10),
  lv11(minCoin: 200000, level: 11),
  lv12(minCoin: 220000, level: 12),
  lv13(minCoin: 240000, level: 13),
  lv14(minCoin: 260000, level: 14),
  lv15(minCoin: 280000, level: 15),
  lv16(minCoin: 300000, level: 16),
  lv17(minCoin: 320000, level: 17),
  lv18(minCoin: 340000, level: 18),
  lv19(minCoin: 360000, level: 19),
  lv20(minCoin: 600000, level: 20),
  lv21(minCoin: 800000, level: 21),
  lv22(minCoin: 1000000, level: 22),
  lv23(minCoin: 1200000, level: 23),
  lv24(minCoin: 1400000, level: 24),
  lv25(minCoin: 1600000, level: 25),
  lv26(minCoin: 1800000, level: 26),
  lv27(minCoin: 2000000, level: 27),
  lv28(minCoin: 2200000, level: 28),
  lv29(minCoin: 2400000, level: 29),
  lv30(minCoin: 3000000, level: 30),
  lv31(minCoin: 3200000, level: 31),
  lv32(minCoin: 3400000, level: 32),
  lv33(minCoin: 3600000, level: 33),
  lv34(minCoin: 3800000, level: 34),
  lv35(minCoin: 4000000, level: 35),
  lv36(minCoin: 4200000, level: 36),
  lv37(minCoin: 4400000, level: 37),
  lv38(minCoin: 4600000, level: 38),
  lv39(minCoin: 4800000, level: 39),
  lv40(minCoin: 5000000, level: 40),
  lv41(minCoin: 6000000, level: 41),
  lv42(minCoin: 7000000, level: 42),
  lv43(minCoin: 8000000, level: 43),
  lv44(minCoin: 9000000, level: 44),
  lv45(minCoin: 10000000, level: 45),
  lv46(minCoin: 11000000, level: 46),
  lv47(minCoin: 12000000, level: 47),
  lv48(minCoin: 13000000, level: 48),
  lv49(minCoin: 15000000, level: 49),
  lv50(minDiamond: 500, level: 50),
  ;

  final int minCoin;
  final int minDiamond;
  final int level;

  const LevelValueExt({
    this.minCoin = 0,
    this.minDiamond = 0,
    required this.level,
  });

  static LevelValueExt getCurrentLevelByLevel(int level) {
    return LevelValueExt.values.firstWhere((element) => element.level == level,
        orElse: () => LevelValueExt.values.first);
  }

  static LevelValueExt? getNextLevel(LevelValueExt levelValueExt) {
    int nextIndex = levelValueExt.index + 1;
    if (LevelValueExt.values.length > nextIndex) {
      return LevelValueExt.values[nextIndex];
    }
    return null;
  }

  static LevelValueExt getLevelByUsedPoint(int usedCoin, int usedDiamond) {
    for (LevelValueExt levelValueExt in LevelValueExt.values.reversed) {
      bool isOverCoin = usedCoin >= levelValueExt.minCoin;
      bool isOverDiamond = usedDiamond >= levelValueExt.minDiamond;
      if (isOverCoin && isOverDiamond) {
        return levelValueExt;
      }
    }
    return LevelValueExt.values.first;
  }
}