enum FcmTypeExt {
  message(),
  read(),
  ;

  const FcmTypeExt();

  static FcmTypeExt getValueOf(String? enumStr) {
    return FcmTypeExt.values.firstWhere((element) => element.name == enumStr,
        orElse: () => FcmTypeExt.values.first);
  }
}