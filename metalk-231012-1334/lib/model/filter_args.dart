import 'package:flutter/cupertino.dart';
import 'package:flutter_metalk/model/age_range_vo.dart';
import 'package:flutter_metalk/model/character_vo.dart';
import 'package:flutter_metalk/model/hobby_vo.dart';
import 'package:flutter_metalk/model/interest_vo.dart';
import 'package:flutter_metalk/model/job_vo.dart';
import 'package:flutter_metalk/model/language_vo.dart';
import 'package:flutter_metalk/providers/base_provider.dart';

class FilterArgs {
  List<AgeRangeVo> ageRangeVoList;
  List<LanguageVo> languageVoList;
  List<InterestVo> interestVoList;
  List<JobVo> jobVoList;
  List<HobbyVo> hobbyVoList;
  List<CharacterVo> characterVoList;

  FilterArgs({
    required this.ageRangeVoList,
    required this.languageVoList,
    required this.interestVoList,
    required this.jobVoList,
    required this.hobbyVoList,
    required this.characterVoList,
  });

  static FilterArgs initFilter(BuildContext context) {
    return FilterArgs(
      ageRangeVoList: BaseProvider.getAgeRangeVoList(context),
      languageVoList: BaseProvider.getLanguageVoList(context),
      interestVoList: BaseProvider.getInterestVoList(context),
      jobVoList: BaseProvider.getJobVoList(context),
      hobbyVoList: BaseProvider.getHobbyVoList(context),
      characterVoList: BaseProvider.getCharacterVoList(context),
    );
  }

  FilterArgs.clone(FilterArgs filterArgs): this(
    ageRangeVoList: filterArgs.ageRangeVoList.map((e) => AgeRangeVo.clone(e)).toList(),
    languageVoList: filterArgs.languageVoList.map((e) => LanguageVo.clone(e)).toList(),
    interestVoList: filterArgs.interestVoList.map((e) => InterestVo.clone(e)).toList(),
    jobVoList: filterArgs.jobVoList.map((e) => JobVo.clone(e)).toList(),
    hobbyVoList: filterArgs.hobbyVoList.map((e) => HobbyVo.clone(e)).toList(),
    characterVoList: filterArgs.characterVoList.map((e) => CharacterVo.clone(e)).toList(),
  );

  bool isCheckAge(int? age) {
    if (age != null) {
      List<AgeRangeVo> checkedList = ageRangeVoList.where((element) => element.isChecked).toList();
      if (checkedList.isEmpty) return true;
      for (AgeRangeVo ageRangeVo in checkedList) {
        if (ageRangeVo.minAge <= age && ageRangeVo.maxAge >= age) {
          return true;
        }
      }
    }
    return false;
  }

  bool isCheckLanguage(List<String>? idList, List<dynamic> targetList) {
    if (idList != null) {
      List<dynamic> checkedList = targetList.where((element) => element.isChecked).toList();
      if (checkedList.isEmpty) return true;
      for (dynamic item in checkedList) {
        if (idList.indexWhere((element) => element == item.id) >= 0) {
          return true;
        }
      }
    }
    return false;
  }

  int getCheckedFilterCount() {
    int cnt = 0;

    cnt += ageRangeVoList.where((element) => element.isChecked).length;
    cnt += languageVoList.where((element) => element.isChecked).length;
    cnt += interestVoList.where((element) => element.isChecked).length;
    cnt += jobVoList.where((element) => element.isChecked).length;
    cnt += hobbyVoList.where((element) => element.isChecked).length;
    cnt += characterVoList.where((element) => element.isChecked).length;

    return cnt;
  }
}