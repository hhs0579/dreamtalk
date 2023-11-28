class AgeRangeVo {
  String title;
  int minAge;
  int maxAge;

  // local values
  bool isChecked;

  AgeRangeVo({
    required this.title,
    required this.minAge,
    required this.maxAge,
    this.isChecked = false,
  });

  AgeRangeVo.clone(AgeRangeVo ageRangeVo): this(
    title: ageRangeVo.title,
    minAge: ageRangeVo.minAge,
    maxAge: ageRangeVo.maxAge,
    isChecked: ageRangeVo.isChecked,
  );
}