import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_coin_api.dart';
import 'package:flutter_metalk/apis/user_diamond_api.dart';
import 'package:flutter_metalk/extentions/gender_ext.dart';
import 'package:flutter_metalk/extentions/level_value_ext.dart';
import 'package:flutter_metalk/loginpage.dart';
import 'package:flutter_metalk/model/filter_args.dart';
import 'package:flutter_metalk/model/profile_create.dart';
import 'package:flutter_metalk/model/user_coin_vo.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/utils/firebase_utils.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class UserApi {
  static final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');

  static Future<UserVo?> getUser({
    bool isRequiredUserCoins = true,
    bool isRequiredUserDiamonds = true,
  }) async {
    DocumentSnapshot documentSnapshot =
        await _usersRef.doc(FirebaseAuth.instance.currentUser?.uid).get();
    if (documentSnapshot.exists) {
      UserVo userVo = UserVo.fromQueryDocumentSnapshot(documentSnapshot);

      if (isRequiredUserCoins) {
        userVo.userCoins = await UserCoinApi.getUserCoins(userVo.id);
      }
      if (isRequiredUserDiamonds) {
        userVo.userDiamonds = await UserDiamondApi.getUserDiamonds(userVo.id);
      }

      return userVo;
    } else {
      return null;
    }
  }

  static Future<UserVo?> getUserById(
    String id, {
    bool isIncludeCoins = true,
    bool isIncludeDiamonds = true,
    UserVo? myUserVo,
  }) async {
    DocumentSnapshot documentSnapshot = await _usersRef.doc(id).get();
    if (documentSnapshot.exists) {
      UserVo userVo = UserVo.fromQueryDocumentSnapshot(documentSnapshot);

      if (isIncludeCoins) {
        userVo.userCoins = await UserCoinApi.getUserCoins(userVo.id);
      }
      if (isIncludeDiamonds) {
        userVo.userDiamonds = await UserDiamondApi.getUserDiamonds(userVo.id);
      }
      if (myUserVo != null) {
        if (userVo.latitude != null &&
            userVo.longitude != null &&
            myUserVo.latitude != null &&
            myUserVo.longitude != null) {
          userVo.distanceBetween = GeolocatorPlatform.instance.distanceBetween(
              myUserVo.latitude!,
              myUserVo.longitude!,
              userVo.latitude!,
              userVo.longitude!);
        }
      }

      return userVo;
    } else {
      return null;
    }
  }

  static Future<UserVo?> getUserIfNotToLogin() async {
    UserVo? userVo = await UserApi.getUser();
    if (userVo == null) {
      Fluttertoast.showToast(msg: '로그인 후 사용 가능한 기능입니다.');
      Future.delayed(
          Duration.zero,
          () => Utils.navigatorPush(Get.context!, const LoginPage(),
              isRemoveUntil: true));
    }
    return userVo;
  }

  static Future<List<UserVo>> getUsers(
    UserVo myUserVo, {
    bool isCompleteProfile = true,
    bool isOrderByCreateDt = false,
    UserVo? ignoreUserVo,
    FilterArgs? filterArgs,
    UserVo? onlyOtherUserGender,
  }) async {
    Query query = _usersRef;
    if (onlyOtherUserGender != null) {
      GenderExt otherGenderExt =
          onlyOtherUserGender.userGender == GenderExt.male
              ? GenderExt.female
              : GenderExt.male;
      query = query.where('userGender', isEqualTo: otherGenderExt.name);
    }
    if (isOrderByCreateDt) {
      query = query.orderBy('createDt', descending: true);
    }
    QuerySnapshot querySnapshot = await query.get();
    List<UserVo> userVoList = List<UserVo>.from(
        querySnapshot.docs.map((e) => UserVo.fromQueryDocumentSnapshot(e)));

    if (isCompleteProfile) {
      userVoList =
          userVoList.where((userVo) => userVo.isCompleteProfile()).toList();
    }
    if (ignoreUserVo != null) {
      userVoList =
          userVoList.where((userVo) => userVo.id != ignoreUserVo.id).toList();
    }
    if (filterArgs != null) {
      userVoList = userVoList
          .where((userVo) => userVo.isPassFilterArgs(filterArgs))
          .toList();
    }

    for (UserVo userVo in userVoList) {
      userVo.userCoins = await UserCoinApi.getUserCoins(userVo.id);
      userVo.userDiamonds = await UserDiamondApi.getUserDiamonds(userVo.id);
      if (userVo.latitude != null &&
          userVo.longitude != null &&
          myUserVo.latitude != null &&
          myUserVo.longitude != null) {
        userVo.distanceBetween = GeolocatorPlatform.instance.distanceBetween(
            myUserVo.latitude!,
            myUserVo.longitude!,
            userVo.latitude!,
            userVo.longitude!);
      }
    }
    return userVoList;
  }

  static Future<UserVo?> updateVerifyPhone({
    required String userId,
    required bool isVerifyPhone,
    required String phone,
  }) async {
    UserVo? userVo = await getUser();
    if (userVo != null) {
      userVo.isVerifyPhone = isVerifyPhone;
      userVo.phone = phone;
      await _usersRef.doc(userId).update(userVo.toMap());
      return (await getUser())!;
    } else {
      return null;
    }
  }

  static Future<UserVo?> updateUser({
    required UserVo user,
  }) async {
    await _usersRef.doc(user.id).update(user.toMap());
    return (await getUser())!;
  }

  static Future<UserVo?> updateUserCreateProfile({
    required UserVo user,
    required ProfileCreate profileCreate,
  }) async {
    // step 1
    user.userName = profileCreate.name;

    user.userGender = GenderExt.getValueOf(profileCreate.gender);
    user.birth = profileCreate.birth;
    user.location = profileCreate.location;

    // step 2
    user.interestIdList =
        profileCreate.interestVoList.map((e) => e.id).toList();
    user.languageIdList =
        profileCreate.languageVoList.map((e) => e.id).toList();
    user.idealIdList = profileCreate.idealVoList.map((e) => e.id).toList();
    user.jobIdList = profileCreate.jobVoList.map((e) => e.id).toList();
    user.hobbyIdList = profileCreate.hobbyVoList.map((e) => e.id).toList();
    user.characterIdList =
        profileCreate.characterVoList.map((e) => e.id).toList();

    // step 3
    user.imageUrlList = profileCreate.imageUrlList;
    user.description = profileCreate.description;
    user.voiceMessageUrl = profileCreate.voiceMessageUrl;

    await _usersRef.doc(user.id).update(user.toMap());
    return (await getUser())!;
  }

  static Future<void> updateLastLogin() async {
    UserVo? userVo = await UserApi.getUser();
    if (userVo != null) {
      await _usersRef.doc(userVo.id).update({
        'lastLoginDt': DateTime.now(),
      });
    }
  }

  static Future<void> refreshMyLocation(
    BuildContext context, {
    Position? existCurrentPosition,
  }) async {
    UserVo? userVo = await UserApi.getUser();
    if (userVo == null) return;

    Position? currentPosition = existCurrentPosition ??
        await Utils.getCurrentLocationPosition(context: context);
    if (currentPosition == null) return;
    double latitude = currentPosition.latitude;
    double longitude = currentPosition.longitude;

    await _usersRef.doc(userVo.id).update({
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  static Future<void> updateMsgCoinByDebounce(
      String userId, int msgCoin) async {
    EasyDebounce.debounce(
        'updateMsgCoinByDebounce', const Duration(milliseconds: 500), () async {
      debugPrint('updateMsgCoinByDebounce($userId, $msgCoin)');
      await _usersRef.doc(userId).update({
        'msgCoin': msgCoin,
      });
    });
  }

  static Future<void> updateFirstMsgCoinByDebounce(
      String userId, int firstMsgCoin) async {
    EasyDebounce.debounce(
        'updateFirstMsgCoinByDebounce', const Duration(milliseconds: 500),
        () async {
      debugPrint('updateFirstMsgCoinByDebounce($userId, $firstMsgCoin)');
      await _usersRef.doc(userId).update({
        'firstMsgCoin': firstMsgCoin,
      });
    });
  }

  static Future<void> refreshFirebaseToken() async {
    UserVo? userVo = await getUser();
    if (userVo == null) return;
    await _usersRef.doc(userVo.id).update({
      'fbToken': await FirebaseUtils.getFirebaseToken(),
    });
  }

  static Future<void> updateUserLevel(
    String userId, {
    int? level,
    int? levelCoin,
    int? levelDiamond,
  }) async {
    Map<String, dynamic> saveData = {};
    if (level != null) {
      saveData['level'] = level;
    }
    if (levelCoin != null) {
      saveData['levelCoin'] = levelCoin;
    }
    if (levelDiamond != null) {
      saveData['levelDiamond'] = levelDiamond;
    }
    await _usersRef.doc(userId).update(saveData);
  }

  static Future<void> initUserLevels() async {
    Logger().d('initUserLevels start');
    QuerySnapshot querySnapshot = await _usersRef.get();
    List<UserVo> users = List<UserVo>.from(
        querySnapshot.docs.map((e) => UserVo.fromQueryDocumentSnapshot(e)));
    for (UserVo user in users) {
      user.userCoins = await UserCoinApi.getUserCoins(user.id);
      user.userDiamonds = await UserDiamondApi.getUserDiamonds(user.id);

      int levelCoin = user.getUseTotalCoin();
      int levelDiamond = user.getUseTotalDiamond();
      LevelValueExt levelValueExt =
          LevelValueExt.getLevelByUsedPoint(levelCoin, levelDiamond);

      await _usersRef.doc(user.id).update({
        'level': levelValueExt.level,
        'levelCoin': levelCoin,
        'levelDiamond': levelDiamond,
      });
      debugPrint('complete user id: ${user.id}');
    }
    Logger().d('initUserLevels end');
  }
}
