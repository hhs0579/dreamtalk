import 'package:flutter_metalk/model/character_vo.dart';
import 'package:flutter_metalk/model/hobby_vo.dart';
import 'package:flutter_metalk/model/ideal_vo.dart';
import 'package:flutter_metalk/model/interest_vo.dart';
import 'package:flutter_metalk/model/job_vo.dart';
import 'package:flutter_metalk/model/language_vo.dart';

class ProfileCreate {
  // step 1
  String name;
  String id;
  String email;
  String gender;
  String birth;
  String location;

  // step 2
  List<InterestVo> interestVoList = [];
  List<LanguageVo> languageVoList = [];
  List<IdealVo> idealVoList = [];
  List<JobVo> jobVoList = [];
  List<HobbyVo> hobbyVoList = [];
  List<CharacterVo> characterVoList = [];

  // step 3
  List<String> imageUrlList = [];
  String? description;
  String? voiceMessageUrl;

  ProfileCreate({
    required this.name,
    required this.id,
    required this.email,
    required this.gender,
    required this.birth,
    required this.location,
  });
}