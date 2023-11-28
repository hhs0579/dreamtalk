enum LevelExt {
  bronze(minLevel: 1, icon: 'bronze-icon.png', title: '브론즈', feeReducePer: 20),
  silver(minLevel: 10, icon: 'silver-icon.png', title: '실버', feeReducePer: 18),
  gold(minLevel: 20, icon: 'gold-icon.png', title: '골드', feeReducePer: 16),
  ruby(minLevel: 30, icon: 'ruby-icon.png', title: '루비', feeReducePer: 14),
  emerald(minLevel: 40, icon: 'emerald-icon.png', title: '에메랄드', feeReducePer: 12),
  sapphire(minLevel: 50, icon: 'sapphire-icon.png', title: '사파이어', feeReducePer: 10),
  ;

  final String icon;
  final String title;
  final double feeReducePer; // 수수료
  final int minLevel;

  const LevelExt({
    required this.icon,
    required this.title,
    required this.feeReducePer,
    required this.minLevel,
  });

  LevelExt? get nextLevelExt => LevelExt.values.indexWhere((element) => element == this) + 1 < LevelExt.values.length ? LevelExt.values[LevelExt.values.indexWhere((element) => element == this) + 1] : null;

  static LevelExt getValueOf(String? enumStr) {
    return LevelExt.values.firstWhere((element) => element.name == enumStr,
        orElse: () => LevelExt.values.first);
  }

  static LevelExt getLevelExtByLevel(int level) {
    for (var levelExt in LevelExt.values.reversed) {
      if (level >= levelExt.minLevel) {
        return levelExt;
      }
    }
    return LevelExt.values.first;
  }

  static bool levelIsDiamond(int level) {
    return level >= 50;
  }
}