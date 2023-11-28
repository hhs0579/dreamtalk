import 'package:flutter_metalk/extentions/level_ext.dart';
import 'package:intl/intl.dart';

class ExchangeVo {
  String? id;
  String userId;
  int coin;
  int money;
  int level;
  LevelExt levelExt;
  double feeReducePer;
  bool isComplete;
  DateTime createDt;
  String userCoinId;

  ExchangeVo({
    this.id,
    required this.userId,
    required this.coin,
    required this.money,
    required this.level,
    required this.levelExt,
    required this.feeReducePer,
    this.isComplete = false,
    required this.createDt,
    required this.userCoinId,
  });

  factory ExchangeVo.fromQueryDocumentSnapshot(dynamic snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    return ExchangeVo(
      id: snapshot.id,
      userId: json['userId'],
      coin: json['coin'],
      money: json['money'],
      level: json['level'] ?? 1,
      levelExt: LevelExt.getValueOf(json['levelExt']),
      feeReducePer: json['feeReducePer'],
      isComplete: json['isComplete'] ?? false,
      createDt: json['createDt'].toDate(),
      userCoinId: json['userCoinId'],
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'coin': coin,
    'money': money,
    'level': level,
    'levelExt': levelExt.name,
    'feeReducePer': feeReducePer,
    'isComplete': isComplete,
    'createDt': createDt,
    'userCoinId': userCoinId,
  };

  String get createDtStr => DateFormat('yyyy-MM-dd').format(createDt);
}