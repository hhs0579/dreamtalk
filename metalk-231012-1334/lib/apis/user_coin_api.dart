import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/extentions/level_value_ext.dart';
import 'package:flutter_metalk/model/user_coin_vo.dart';
import 'package:flutter_metalk/model/user_vo.dart';

class UserCoinApi {
  static final CollectionReference _userCoinsRef = FirebaseFirestore.instance.collection('userCoins');

  static Future<List<UserCoinVo>> getUserCoins(String userId) async {
    QuerySnapshot querySnapshot = await _userCoinsRef
        .where('userId', isEqualTo: userId)
        .get();
    return List<UserCoinVo>.from(querySnapshot.docs.map((e) => UserCoinVo.fromQueryDocumentSnapshot(e)));
  }

  static Future<UserCoinVo> createUserCoin(UserCoinVo userCoinVo) async {
    if (userCoinVo.isUsed) {
      UserVo? userVo = await UserApi.getUser(
        isRequiredUserCoins: false,
        isRequiredUserDiamonds: false,
      );
      if (userVo != null) {
        UserApi.updateUserLevel(userVo.id,
          level: LevelValueExt.getLevelByUsedPoint(userVo.levelCoin, userVo.levelDiamond).level,
          levelCoin: userVo.levelCoin + userCoinVo.cnt,
        );
      }
    }

    DocumentReference res = await _userCoinsRef.add(userCoinVo.toMap());
    return UserCoinVo.fromQueryDocumentSnapshot(await res.get());
  }

  static Future<bool> isAblePaymentCoin({
    required UserVo userVo,
    required int paymentCoin,
  }) async {
    userVo.userCoins = await getUserCoins(userVo.id);
    return userVo.getRemainCoin() >= paymentCoin;
  }
}