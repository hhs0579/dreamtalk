class HobbyVo {
  String id;
  String title;
  DateTime createDt;

  // local values
  bool isChecked;

  HobbyVo({
    required this.id,
    required this.title,
    required this.createDt,
    this.isChecked = false,
  });

  HobbyVo.clone(HobbyVo vo): this(
    id: vo.id,
    title: vo.title,
    createDt: vo.createDt,
    isChecked: vo.isChecked,
  );

  factory HobbyVo.fromQueryDocumentSnapshot(dynamic snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    return HobbyVo(
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