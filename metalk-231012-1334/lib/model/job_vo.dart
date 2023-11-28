class JobVo {
  String id;
  String title;
  DateTime createDt;

  // local values
  bool isChecked;

  JobVo({
    required this.id,
    required this.title,
    required this.createDt,
    this.isChecked = false,
  });

  JobVo.clone(JobVo vo): this(
    id: vo.id,
    title: vo.title,
    createDt: vo.createDt,
    isChecked: vo.isChecked,
  );

  factory JobVo.fromQueryDocumentSnapshot(dynamic snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    return JobVo(
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