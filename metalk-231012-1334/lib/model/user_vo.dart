import 'package:flutter/cupertino.dart';
import 'package:flutter_metalk/configs/global_config.dart';
import 'package:flutter_metalk/extentions/gender_ext.dart';
import 'package:flutter_metalk/extentions/level_ext.dart';
import 'package:flutter_metalk/extentions/level_value_ext.dart';
import 'package:flutter_metalk/model/filter_args.dart';
import 'package:flutter_metalk/model/user_coin_vo.dart';
import 'package:flutter_metalk/model/user_diamond_vo.dart';
import 'package:flutter_metalk/providers/base_provider.dart';
import 'package:flutter_metalk/utils/utils.dart';

class UserVo {
  String id;
  String loginType;
  String email;
  String? phone;
  bool isVerifyPhone;
  DateTime createDt;
  DateTime? lastLoginDt;
  DateTime? blockEndDt;

  // step 1
  String? userName;
  String? userId;
  String? userEmail;
  GenderExt userGender; // male, female
  String? birth; // yyyyMMdd
  String? location; // 위치 (ex: 서울시 강남구)

  // step 2
  List<String>? interestIdList;
  List<String>? languageIdList;
  List<String>? idealIdList;
  List<String>? jobIdList;
  List<String>? hobbyIdList;
  List<String>? characterIdList;

  // step 3
  List<String>? imageUrlList;
  String? description;
  String? voiceMessageUrl;

  bool isOnline;
  double? latitude;
  double? longitude;
  int msgCoin;
  int firstMsgCoin;
  String? fbToken;
  bool isVerifyExchange;

  int level;
  int levelCoin;
  int levelDiamond;

  // local values
  List<UserCoinVo> userCoins = [];
  List<UserDiamondVo> userDiamonds = [];
  double? distanceBetween; // meters

  UserVo({
    required this.id,
    required this.loginType,
    required this.email,
    this.phone,
    this.isVerifyPhone = false,
    required this.createDt,
    this.lastLoginDt,
    this.blockEndDt,
    this.userName,
    this.userId,
    this.userEmail,
    this.userGender = GenderExt.male,
    this.birth,
    this.location,
    this.interestIdList,
    this.languageIdList,
    this.idealIdList,
    this.jobIdList,
    this.hobbyIdList,
    this.characterIdList,
    this.imageUrlList,
    this.description,
    this.voiceMessageUrl,
    this.isOnline = false,
    this.latitude,
    this.longitude,
    this.msgCoin = GlobalConfig.defaultMsgCoin,
    this.firstMsgCoin = GlobalConfig.defaultMsgCoin,
    this.fbToken,
    this.isVerifyExchange = false,
    this.level = 1,
    this.levelCoin = 0,
    this.levelDiamond = 0,
  });

  factory UserVo.fromQueryDocumentSnapshot(dynamic snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    DateTime? lastLoginDt = json['lastLoginDt']?.toDate();

    return UserVo(
      id: snapshot.id,
      loginType: json['loginType'],
      email: json['email'],
      phone: json['phone'],
      isVerifyPhone: json['isVerifyPhone'],
      createDt: json['createDt'].toDate(),
      lastLoginDt: lastLoginDt,
      blockEndDt: json['blockEndDt']?.toDate(),
      userName: json['userName'],
      userId: json['userId'],
      userEmail: json['userEmail'],
      userGender: GenderExt.getValueOf(json['userGender']),
      birth: json['birth'],
      location: json['location'],
      interestIdList: json['interestIdList'] != null
          ? List<String>.from(json['interestIdList'].map((e) => e))
          : null,
      languageIdList: json['languageIdList'] != null
          ? List<String>.from(json['languageIdList'].map((e) => e))
          : null,
      idealIdList: json['idealIdList'] != null
          ? List<String>.from(json['idealIdList'].map((e) => e))
          : null,
      jobIdList: json['jobIdList'] != null
          ? List<String>.from(json['jobIdList'].map((e) => e))
          : null,
      hobbyIdList: json['hobbyIdList'] != null
          ? List<String>.from(json['hobbyIdList'].map((e) => e))
          : null,
      characterIdList: json['characterIdList'] != null
          ? List<String>.from(json['characterIdList'].map((e) => e))
          : null,
      imageUrlList: json['imageUrlList'] != null
          ? List<String>.from(json['imageUrlList'].map((e) => e))
          : null,
      description: json['description'],
      voiceMessageUrl: json['voiceMessageUrl'],
      isOnline: lastLoginDt != null &&
          lastLoginDt.difference(DateTime.now()).inSeconds.abs() <=
              GlobalConfig.onlineLastLoginSecond,
      latitude: json['latitude'],
      longitude: json['longitude'],
      msgCoin: json['msgCoin'] ?? GlobalConfig.defaultMsgCoin,
      firstMsgCoin: json['firstMsgCoin'] ?? GlobalConfig.defaultMsgCoin,
      fbToken: json['fbToken'],
      isVerifyExchange: json['isVerifyExchange'] ?? false,
      level: json['level'] ?? 1,
      levelCoin: json['levelCoin'] ?? 0,
      levelDiamond: json['levelDiamond'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'loginType': loginType,
        'email': email,
        'phone': phone,
        'isVerifyPhone': isVerifyPhone,
        'createDt': createDt,
        'lastLoginDt': lastLoginDt,
        'userName': userName,
        'userId': userId,
        'userEmail': userEmail,
        'userGender': userGender.name,
        'birth': birth,
        'location': location,
        'interestIdList': interestIdList,
        'languageIdList': languageIdList,
        'idealIdList': idealIdList,
        'jobIdList': jobIdList,
        'hobbyIdList': hobbyIdList,
        'characterIdList': characterIdList,
        'imageUrlList': imageUrlList,
        'description': description,
        'voiceMessageUrl': voiceMessageUrl,
      };

  bool isCompleteProfile() {
    bool isCompleteStep1 =
        userName != null && birth != null && location != null;

    bool isCompleteStep2 = (interestIdList ?? []).isNotEmpty &&
        (languageIdList ?? []).isNotEmpty &&
        (idealIdList ?? []).isNotEmpty &&
        (jobIdList ?? []).isNotEmpty &&
        (hobbyIdList ?? []).isNotEmpty &&
        (characterIdList ?? []).isNotEmpty;

    bool isCompleteStep3 =
        (imageUrlList ?? []).isNotEmpty && description != null;

    return isCompleteStep1 && isCompleteStep2 && isCompleteStep3;
  }

  String get profileImgUrl =>
      imageUrlList?.first ?? GlobalConfig.defaultUserImgUrl;
  DateTime? get birthDt => birth == null
      ? null
      : DateTime.parse(
          '${birth!.substring(0, 4)}-${birth!.substring(4, 6)}-${birth!.substring(6, 8)}');
  int? get age => birthDt == null ? null : Utils.calculateAge(birthDt!);

  bool isPassFilterArgs(FilterArgs filterArgs) {
    return filterArgs.isCheckAge(age) &&
        filterArgs.isCheckLanguage(languageIdList, filterArgs.languageVoList) &&
        filterArgs.isCheckLanguage(interestIdList, filterArgs.interestVoList) &&
        filterArgs.isCheckLanguage(jobIdList, filterArgs.jobVoList) &&
        filterArgs.isCheckLanguage(hobbyIdList, filterArgs.hobbyVoList) &&
        filterArgs.isCheckLanguage(characterIdList, filterArgs.characterVoList);
  }

  String? firstLanguage(BuildContext context) {
    return BaseProvider.getFirstLanguageTitleByUserLanguageList(context, this);
  }

  int getRemainCoin() {
    int resultCnt = 0;

    for (UserCoinVo coin in userCoins) {
      if (coin.isUsed) {
        resultCnt -= coin.cnt;
      } else {
        resultCnt += coin.cnt;
      }
    }

    return resultCnt;
  }

  int getRemainDiamond() {
    int resultCnt = 0;

    for (UserDiamondVo item in userDiamonds) {
      if (item.isUsed) {
        resultCnt -= item.cnt;
      } else {
        resultCnt += item.cnt;
      }
    }

    return resultCnt;
  }

  int getUseTotalCoin() {
    int resultCnt = 0;

    for (UserCoinVo coin in userCoins.where((element) => element.isUsed)) {
      resultCnt += coin.cnt;
    }

    return resultCnt;
  }

  int getUseTotalDiamond() {
    int resultCnt = 0;

    for (UserDiamondVo item
        in userDiamonds.where((element) => element.isUsed)) {
      resultCnt += item.cnt;
    }

    return resultCnt;
  }

  String get distanceStr => Utils.getDistanceResponseString(distanceBetween);
  LevelExt get levelExt => LevelExt.getLevelExtByLevel(level);
  LevelValueExt get levelValueExt =>
      LevelValueExt.getCurrentLevelByLevel(level);

  bool get isBlock => blockEndDt != null && blockEndDt!.isAfter(DateTime.now());
}
