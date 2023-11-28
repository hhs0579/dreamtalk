class InterestVo {
  String id;
  String iconUrl;
  String title;
  DateTime createDt;

  // local values
  bool isChecked;

  InterestVo({
    required this.id,
    required this.iconUrl,
    required this.title,
    required this.createDt,
    this.isChecked = false,
  });

  InterestVo.clone(InterestVo interestVo): this(
    id: interestVo.id,
    iconUrl: interestVo.iconUrl,
    title: interestVo.title,
    createDt: interestVo.createDt,
    isChecked: interestVo.isChecked,
  );

  factory InterestVo.fromQueryDocumentSnapshot(dynamic snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    return InterestVo(
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