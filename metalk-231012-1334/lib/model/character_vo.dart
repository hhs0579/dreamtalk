class CharacterVo {
  String id;
  String title;
  DateTime createDt;

  // local values
  bool isChecked;

  CharacterVo({
    required this.id,
    required this.title,
    required this.createDt,
    this.isChecked = false,
  });

  CharacterVo.clone(CharacterVo vo): this(
    id: vo.id,
    title: vo.title,
    createDt: vo.createDt,
    isChecked: vo.isChecked,
  );

  factory CharacterVo.fromQueryDocumentSnapshot(dynamic snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    return CharacterVo(
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