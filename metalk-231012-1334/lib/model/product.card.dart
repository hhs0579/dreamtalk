class UserModel {
  String? uid; //user id
  String? name; // 이름
  String? userid; // 이름
  String? email; //이메일
  String? gender; //성별
  String? date; //생년월일
  String? location; //위치
  String? interest; //관심사
  String? language; //언어
  String? idealtype; //이상형
  String? job; //직업
  String? hobby; //취미
  String? personality; //성격
  String? image; //사진
  String? description; //자신에대해설명

  UserModel({
    this.uid,
    this.name,
    this.userid,
    this.email,
    this.gender,
    this.date,
    this.location,
    this.interest,
    this.language,
    this.idealtype,
    this.job,
    this.hobby,
    this.personality,
    this.image,
    this.description,
  });
  // 서버에서 데이터 수신
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      name: map['이름'],
      userid: map['아이디'],
      email: map['이메일'],
      gender: map['성별'],
      date: map['생년월일'],
      location: map['위치'],
      interest: map['관심사'],
      language: map['언어'],
      idealtype: map['이상형'],
      job: map['직업'],
      hobby: map['취미'],
      personality: map['성격'],
      image: map['사진'],
      description: map['자기소개'],
    );
  }

  // 우리 서버에 데이터 보내기
  Map<String, dynamic> toMap() {
    return {
      'uid': userid,
      '이메일': email,
      '이름': name,
      '성별': gender,
      '생년월일': date,
      '위치': location,
      '관심사': interest,
      '언어': language,
      '이상형': idealtype,
      '직업': job,
      '취미': hobby,
      '성격': personality,
      '사진': image,
      '자기소개': description,
    };
  }
}
