enum GenderExt {
  female(icon: 'female-icon.png'),
  male(icon: 'male-icon.png'),
  ;

  final String icon;

  const GenderExt({
    required this.icon,
  });

  static GenderExt getValueOf(String? enumStr) {
    return GenderExt.values.firstWhere((element) => element.name == enumStr,
        orElse: () => GenderExt.values.first);
  }
}