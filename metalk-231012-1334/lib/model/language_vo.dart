class LanguageVo {
  String id;
  String iconUrl;
  String title;
  DateTime createDt;

  // local values
  bool isChecked;

  LanguageVo({
    required this.id,
    required this.iconUrl,
    required this.title,
    required this.createDt,
    this.isChecked = false,
  });

  LanguageVo.clone(LanguageVo vo): this(
    id: vo.id,
    iconUrl: vo.iconUrl,
    title: vo.title,
    createDt: vo.createDt,
    isChecked: vo.isChecked,
  );

  factory LanguageVo.fromQueryDocumentSnapshot(dynamic snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    return LanguageVo(
      id: snapshot.id,
      iconUrl: json['iconUrl'],
      title: json['title'],
      createDt: json['createDt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
    'iconUrl': iconUrl,
    'title': title,
    'createDt': createDt,
  };
}