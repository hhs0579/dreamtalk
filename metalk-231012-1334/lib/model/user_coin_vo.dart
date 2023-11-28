class UserCoinVo {
  String? id;
  String userId;
  int cnt;
  bool isUsed;
  DateTime createDt;
  String? receiveCoinId;

  bool isLoginDay;
  int? loginDay;
  bool isContinuousDay;
  int? continuousDay;

  int? paymentPrice; // 결제 금액
  String? paymentResult;

  UserCoinVo({
    this.id,
    required this.userId,
    required this.cnt,
    required this.isUsed,
    required this.createDt,
    this.receiveCoinId,
    this.isLoginDay = false,
    this.loginDay,
    this.isContinuousDay = false,
    this.continuousDay,
    this.paymentPrice,
    this.paymentResult,
  });

  factory UserCoinVo.fromQueryDocumentSnapshot(dynamic snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    return UserCoinVo(
      id: snapshot.id,
      userId: json['userId'],
      cnt: json['cnt'],
      isUsed: json['isUsed'],
      createDt: json['createDt'].toDate(),
      receiveCoinId: json['receiveCoinId'],
      isLoginDay: json['isLoginDay'],
      loginDay: json['loginDay'],
      isContinuousDay: json['isContinuousDay'],
      continuousDay: json['continuousDay'],
      paymentPrice: json['paymentPrice'],
      paymentResult: json['paymentResult'],
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'cnt': cnt,
    'isUsed': isUsed,
    'createDt': createDt,
    'receiveCoinId': receiveCoinId,
    'isLoginDay': isLoginDay,
    'loginDay': loginDay,
    'isContinuousDay': isContinuousDay,
    'continuousDay': continuousDay,
    'paymentPrice': paymentPrice,
    'paymentResult': paymentResult,
  };

  static Map<int, int> get coinByLoginDay => {
    1: 100,
    2: 100,
    3: 100,
    4: 100,
    5: 100,
    6: 100,
    7: 500,
  };
}