import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/auth/phoneprofilethree.dart';
import 'package:flutter_metalk/components/container_widget.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/model/character_vo.dart';
import 'package:flutter_metalk/model/hobby_vo.dart';
import 'package:flutter_metalk/model/ideal_vo.dart';
import 'package:flutter_metalk/model/interest_vo.dart';
import 'package:flutter_metalk/model/job_vo.dart';
import 'package:flutter_metalk/model/language_vo.dart';
import 'package:flutter_metalk/model/profile_create.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/providers/base_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PhoneProfileTwo extends StatefulWidget {
  final ProfileCreate profileCreate;

  const PhoneProfileTwo({super.key,
    required this.profileCreate,
  });

  @override
  State<PhoneProfileTwo> createState() => _PhoneProfileTwoState();
}

class _PhoneProfileTwoState extends State<PhoneProfileTwo> {
  bool _isLoading = true;
  late UserVo _userVo;

  List<InterestVo> _interestVoList = [];
  List<LanguageVo> _languageVoList = [];
  List<IdealVo> _idealVoList = [];
  List<JobVo> _jobVoList = [];
  List<HobbyVo> _hobbyVoList = [];
  List<CharacterVo> _characterVoList = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    UserVo? userVo = await UserApi.getUser();
    if (userVo == null) {
      Fluttertoast.showToast(msg: '로그인 후 사용 가능한 기능입니다.');
      Future.delayed(Duration.zero, () => Navigator.pop(context));
      return;
    }
    _userVo = userVo;

    _interestVoList = BaseProvider.getInterestVoList(context);
    _languageVoList = BaseProvider.getLanguageVoList(context);
    _idealVoList = BaseProvider.getIdealVoList(context);
    _jobVoList = BaseProvider.getJobVoList(context);
    _hobbyVoList = BaseProvider.getHobbyVoList(context);
    _characterVoList = BaseProvider.getCharacterVoList(context);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? const Loading() : SafeArea(
        // 로딩바
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(),
                child: SizedBox(
                  width: ScreenUtil().setWidth(
                    335,
                  ),
                  height: ScreenUtil().setHeight(
                    4,
                  ),
                  child: const LinearProgressIndicator(
                    value: 0.65,
                    backgroundColor: Color.fromARGB(
                      255,
                      229,
                      229,
                      229,
                    ),
                    color: Colors.black45,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(
                        255,
                        3,
                        201,
                        195,
                      ),
                    ),
                    minHeight: 5.0,
                    semanticsLabel: 'semanticsLabel',
                    semanticsValue: 'semanticsValue',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(6),
                  right: ScreenUtil().setWidth(
                    20,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '2/3',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            12,
                          ),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Text(
                '당신에 대해 알려주세요!',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setWidth(
                    20,
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(
                  2,
                ),
              ),
              Text(
                '비슷한 성향의 사람과 매칭 될 수 있는 확률이 높아져요!',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtil().setSp(
                    14,
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(
                  24,
                ),
              ),

              Expanded(child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '관심사',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(
                          16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        2,
                      ),
                    ),
                    const Text(
                      '5개까지 선택할 수 있어요.',
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        12,
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (InterestVo item in _interestVoList)...[
                          ContainerWidget(
                            onTap: () {if (item.isChecked == true || _isAbleMoreCheck(maxLength: 5, list: _interestVoList)) setState(() => item.isChecked = !item.isChecked);},
                            isChecked: item.isChecked,
                            image: item.iconUrl,
                            title: item.title,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        24,
                      ),
                    ),
                    Text(
                      '언어',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(
                          16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(2),
                    ),
                    Text(
                      '5개까지 선택할 수 있어요.',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(
                          14,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        12,
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (LanguageVo item in _languageVoList)...[
                          ContainerWidget(
                            onTap: () {if (item.isChecked == true || _isAbleMoreCheck(maxLength: 5, list: _languageVoList)) setState(() => item.isChecked = !item.isChecked);},
                            isChecked: item.isChecked,
                            image: item.iconUrl,
                            title: item.title,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        24,
                      ),
                    ),
                    Text(
                      '이상형',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(
                          16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        2,
                      ),
                    ),
                    Text(
                      '5개까지 선택할 수 있어요.',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            14,
                          ),
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        12,
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (IdealVo item in _idealVoList)...[
                          ContainerWidget(
                            onTap: () {if (item.isChecked == true || _isAbleMoreCheck(maxLength: 5, list: _idealVoList)) setState(() => item.isChecked = !item.isChecked);},
                            isChecked: item.isChecked,
                            title: item.title,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        24,
                      ),
                    ),
                    Text(
                      '직업',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(
                          16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        2,
                      ),
                    ),
                    Text(
                      '1개까지 선택할 수 있어요 (중복선택 불가능)',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(
                          14,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        12,
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (JobVo item in _jobVoList)...[
                          ContainerWidget(
                            onTap: () {if (item.isChecked == true || _isAbleMoreCheck(maxLength: 1, list: _jobVoList)) setState(() => item.isChecked = !item.isChecked);},
                            isChecked: item.isChecked,
                            title: item.title,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        24,
                      ),
                    ),
                    Text(
                      '취미',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(
                          16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '5개까지 선택할 수 있어요.',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(
                          14,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        12,
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (HobbyVo item in _hobbyVoList)...[
                          ContainerWidget(
                            onTap: () {if (item.isChecked == true || _isAbleMoreCheck(maxLength: 5, list: _hobbyVoList)) setState(() => item.isChecked = !item.isChecked);},
                            isChecked: item.isChecked,
                            title: item.title,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        24,
                      ),
                    ),
                    Text(
                      '성격',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(
                          16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        2,
                      ),
                    ),
                    Text(
                      '3개까지 선택할 수 있어요.',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(
                          14,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        12,
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (CharacterVo item in _characterVoList)...[
                          ContainerWidget(
                            onTap: () {if (item.isChecked == true || _isAbleMoreCheck(maxLength: 3, list: _characterVoList)) setState(() => item.isChecked = !item.isChecked);},
                            isChecked: item.isChecked,
                            title: item.title,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(
                        height: ScreenUtil().setHeight(
                          40,
                        )),
                  ],
                ),
              )),
              GestureDetector(
                onTap: () => _onSubmit(),
                child: Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(
                    56,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      3,
                      201,
                      195,
                    ),
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '다음',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(
                          16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isAbleMoreCheck({
    required int maxLength,
    required List list,
  }) {
    bool result = list.where((element) => element.isChecked).length < maxLength;
    if (result == false) Fluttertoast.showToast(msg: '$maxLength개 이상 선택할 수 없습니다.');
    return result;
  }

  void _onSubmit() {
    List<InterestVo> interestVoList = _interestVoList.where((element) => element.isChecked).toList();
    List<LanguageVo> languageVoList = _languageVoList.where((element) => element.isChecked).toList();
    List<IdealVo> idealVoList = _idealVoList.where((element) => element.isChecked).toList();
    List<JobVo> jobVoList = _jobVoList.where((element) => element.isChecked).toList();
    List<HobbyVo> hobbyVoList = _hobbyVoList.where((element) => element.isChecked).toList();
    List<CharacterVo> characterVoList = _characterVoList.where((element) => element.isChecked).toList();

    if (interestVoList.isEmpty) {
      Fluttertoast.showToast(msg: '관심사를 최소 1개 이상 선택해주세요.');
      return;
    }
    if (languageVoList.isEmpty) {
      Fluttertoast.showToast(msg: '언어를 최소 1개 이상 선택해주세요.');
      return;
    }
    if (idealVoList.isEmpty) {
      Fluttertoast.showToast(msg: '이상형을 최소 1개 이상 선택해주세요.');
      return;
    }
    if (jobVoList.isEmpty) {
      Fluttertoast.showToast(msg: '직업을 최소 1개 이상 선택해주세요.');
      return;
    }
    if (hobbyVoList.isEmpty) {
      Fluttertoast.showToast(msg: '취미를 최소 1개 이상 선택해주세요.');
      return;
    }
    if (characterVoList.isEmpty) {
      Fluttertoast.showToast(msg: '성격을 최소 1개 이상 선택해주세요.');
      return;
    }

    ProfileCreate profileCreate = widget.profileCreate;
    profileCreate.interestVoList = interestVoList;
    profileCreate.languageVoList = languageVoList;
    profileCreate.idealVoList = idealVoList;
    profileCreate.jobVoList = jobVoList;
    profileCreate.hobbyVoList = hobbyVoList;
    profileCreate.characterVoList = characterVoList;

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => PhoneProfileThree(
          profileCreate: profileCreate,
        ),
      ),
    );
  }
}