class InterestVo {
  String id;

  String title;
  DateTime createDt;

  // local values
  bool isChecked;

  InterestVo({
    required this.id,
    required this.title,
    required this.createDt,
    this.isChecked = false,
  });

  InterestVo.clone(InterestVo interestVo)
      : this(
          id: interestVo.id,
          title: interestVo.title,
          createDt: interestVo.createDt,
          isChecked: interestVo.isChecked,
        );

  factory InterestVo.fromQueryDocumentSnapshot(dynamic snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    return InterestVo(
      id: snapshot.id,
      title: json['title'],
      createDt: json['createDt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'createDt': createDt,
      };
}
