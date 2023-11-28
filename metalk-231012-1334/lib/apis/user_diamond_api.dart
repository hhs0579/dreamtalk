import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/extentions/level_value_ext.dart';
import 'package:flutter_metalk/model/user_diamond_vo.dart';
import 'package:flutter_metalk/model/user_vo.dart';

class UserDiamondApi {
  static final CollectionReference _ref = FirebaseFirestore.instance.collection('userDiamonds');

  static Future<List<UserDiamondVo>> getUserDiamonds(String userId, {
    bool? isUsed,
    bool? isNullTargetUserId,
    bool isOrderByCreateDt = false,
  }) async {
    Query query =  _ref.where('userId', isEqualTo: userId);
    if (isUsed != null) {
      query = query.where('isUsed', isEqualTo: isUsed);
    }
    if (isNullTargetUserId != null) {
      query = query.where('targetUserId', isNull: isNullTargetUserId);
    }

    QuerySnapshot querySnapshot = await query.get();
    List<UserDiamondVo> resultList = List<UserDiamondVo>.from(querySnapshot.docs.map((e) => UserDiamondVo.fromQueryDocumentSnapshot(e)));
    if (isOrderByCreateDt) {
      resultList.sort((a, b) => a.createDt.isAfter(b.createDt) ? 1 : -1);
    }
    return resultList;
  }

  static Future<UserDiamondVo> createUserDiamond(UserDiamondVo userDiamondVo) async {
    if (userDiamondVo.isUsed) {
      UserVo? userVo = await UserApi.getUser(
        isRequiredUserCoins: false,
        isRequiredUserDiamonds: false,
      );
      if (userVo != null) {
        UserApi.updateUserLevel(userVo.id,
          level: LevelValueExt.getLevelByUsedPoint(userVo.levelCoin, userVo.levelDiamond).level,
          levelDiamond: userVo.levelDiamond + userDiamondVo.cnt,
        );
      }
    }

    DocumentReference res = await _ref.add(userDiamondVo.toMap());
    return UserDiamondVo.fromQueryDocumentSnapshot(await res.get());
  }

  static Future<bool> isAblePayment({
    required UserVo userVo,
    required int payment,
  }) async {
    userVo.userDiamonds = await getUserDiamonds(userVo.id);
    return userVo.getRemainDiamond() >= payment;
  }
}