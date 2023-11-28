import 'package:flutter/cupertino.dart';
import 'package:flutter_metalk/apis/character_api.dart';
import 'package:flutter_metalk/apis/hobby_api.dart';
import 'package:flutter_metalk/apis/ideal_api.dart';
import 'package:flutter_metalk/apis/interest_api.dart';
import 'package:flutter_metalk/apis/job_api.dart';
import 'package:flutter_metalk/apis/language_api.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/model/age_range_vo.dart';
import 'package:flutter_metalk/model/character_vo.dart';
import 'package:flutter_metalk/model/hobby_vo.dart';
import 'package:flutter_metalk/model/ideal_vo.dart';
import 'package:flutter_metalk/model/interest_vo.dart';
import 'package:flutter_metalk/model/job_vo.dart';
import 'package:flutter_metalk/model/language_vo.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BaseProvider with ChangeNotifier {
  List<InterestVo> interestVoList = [];
  List<LanguageVo> languageVoList = [];
  List<IdealVo> idealVoList = [];
  List<JobVo> jobVoList = [];
  List<HobbyVo> hobbyVoList = [];
  List<CharacterVo> characterVoList = [];
  List<AgeRangeVo> ageRangeVoList = [
    AgeRangeVo(title: '20세 ~ 22세', minAge: 20, maxAge: 22),
    AgeRangeVo(title: '23세 ~ 26세', minAge: 23, maxAge: 26),
    AgeRangeVo(title: '27세 ~ 29세', minAge: 27, maxAge: 29),
    AgeRangeVo(title: '30대', minAge: 30, maxAge: 39),
    AgeRangeVo(title: '40대', minAge: 40, maxAge: 49),
  ];
  Position? currentPosition;

  static Future<void> initDefaultList(BuildContext context) async {
    Provider.of<BaseProvider>(context, listen: false).interestVoList = await InterestApi.getInterests();
    Provider.of<BaseProvider>(context, listen: false).languageVoList = await LanguageApi.getLanguages();
    Provider.of<BaseProvider>(context, listen: false).idealVoList = await IdealApi.getIdeals();
    Provider.of<BaseProvider>(context, listen: false).jobVoList = await JobApi.getJobs();
    Provider.of<BaseProvider>(context, listen: false).hobbyVoList = await HobbyApi.getHobbys();
    Provider.of<BaseProvider>(context, listen: false).characterVoList = await CharacterApi.getCharacters();
    Position? currentPosition = await Utils.getCurrentLocationPosition(context: context);
    if (currentPosition == null) {
      Fluttertoast.showToast(msg: '현재 위치 정보를 찾을 수 없습니다.');
    }
    Provider.of<BaseProvider>(context, listen: false).currentPosition = currentPosition;
    await UserApi.refreshMyLocation(context, existCurrentPosition: currentPosition);
    await UserApi.refreshFirebaseToken();
  }

  static List<InterestVo> getInterestVoList(BuildContext context) => Provider.of<BaseProvider>(context, listen: false).interestVoList.map((e) => InterestVo.clone(e)).toList();
  static List<LanguageVo> getLanguageVoList(BuildContext context) => Provider.of<BaseProvider>(context, listen: false).languageVoList.map((e) => LanguageVo.clone(e)).toList();
  static List<IdealVo> getIdealVoList(BuildContext context) => Provider.of<BaseProvider>(context, listen: false).idealVoList.map((e) => IdealVo.clone(e)).toList();
  static List<JobVo> getJobVoList(BuildContext context) => Provider.of<BaseProvider>(context, listen: false).jobVoList.map((e) => JobVo.clone(e)).toList();
  static List<HobbyVo> getHobbyVoList(BuildContext context) => Provider.of<BaseProvider>(context, listen: false).hobbyVoList.map((e) => HobbyVo.clone(e)).toList();
  static List<CharacterVo> getCharacterVoList(BuildContext context) => Provider.of<BaseProvider>(context, listen: false).characterVoList.map((e) => CharacterVo.clone(e)).toList();
  static List<AgeRangeVo> getAgeRangeVoList(BuildContext context) => Provider.of<BaseProvider>(context, listen: false).ageRangeVoList.map((e) => AgeRangeVo.clone(e)).toList();

  static String? getFirstLanguageTitleByUserLanguageList(BuildContext context, UserVo userVo) {
    List<String>? languageIdList = userVo.languageIdList;
    if (languageIdList != null && languageIdList.isNotEmpty) {
      String languageId = languageIdList.first;
      return getLanguageVoList(context).firstWhereOrNull((e) => e.id == languageId)?.title;
    }
    return null;
  }
}