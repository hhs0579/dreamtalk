import 'package:flutter_metalk/extentions/gift_ext.dart';

class UserDiamondVo {
  String? id;
  String userId;
  int cnt;
  bool isUsed;
  DateTime createDt;
  String? targetUserId;
  GiftExt? giftExt;

  UserDiamondVo({
    this.id,
    required this.userId,
    required this.cnt,
    required this.isUsed,
    required this.createDt,
    this.targetUserId,
    this.giftExt,
  });

  factory UserDiamondVo.fromQueryDocumentSnapshot(dynamic snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    return UserDiamondVo(
      id: snapshot.id,
      userId: json['userId'],
      cnt: json['cnt'],
      isUsed: json['isUsed'],
      createDt: json['createDt'].toDate(),
      targetUserId: json['targetUserId'],
      giftExt:
          json['giftExt'] != null ? GiftExt.getValueOf(json['giftExt']) : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'cnt': cnt,
        'isUsed': isUsed,
        'createDt': createDt,
        'targetUserId': targetUserId,
        'giftExt': giftExt?.name,
      };
}
