import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/colors/colors.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/model/product.card.dart';
import 'package:flutter_metalk/model/profile_create.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'phoneprofiletwo.dart';

class PhoneProfile extends StatefulWidget {
  const PhoneProfile({super.key});

  @override
  State<PhoneProfile> createState() => _PhoneProfileState();
}

class _PhoneProfileState extends State<PhoneProfile> {
  bool _isLoading = true;
  late UserVo _userVo;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _manBox = false;
  bool _womanBox = false;
  bool isNicknameLengthValid = false;
  bool isNicknameCharactersValid = false;
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

    setState(() => _isLoading = false);
  }

  //남자박스
  void genderWoman() {
    if (!_manBox) {
      _womanBox = !_womanBox;
    }
    if (_manBox) {
      _manBox = !_manBox;
    }
    if (!_womanBox) {
      _womanBox = !_womanBox;
    }
  }

  //여자박스
  void genderman() {
    // gender = _man;
    if (!_womanBox) {
      _manBox = !_manBox;
    }
    if (_womanBox) {
      _womanBox = !_womanBox;
    }
    if (!_manBox) {
      _manBox = !_manBox;
    }
  }

  void validateNickname(String value) {
    isNicknameLengthValid = value.length >= 2;
  }

  void validateNickname2(String value) {
    // 한글 자음과 모음의 범위를 정의합니다.

    // 정규 표현식을 사용하여 단일 자음 또는 모음, 불완전한 조합을 검사합니다.
    RegExp regExp = RegExp(r'^[\uAC00-\uD7A3]+$');

    // 입력된 값이 정규 표현식에 매칭되는지 검사합니다.
    isNicknameCharactersValid = regExp.hasMatch(value);
  }

  Future<void> profileauth() async {
    UserModel models = UserModel();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    models.uid = FirebaseAuth.instance.currentUser!.uid; // 현재유저 uid
    models.name = _nameController.text; //현재유저 이메일
    await firebaseFirestore
        .collection("user") //컬렉션
        .doc(FirebaseAuth.instance.currentUser!.uid) //문서추가
        .set(models.toMap()); //user 정보들추가
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: _isLoading
                      ? const Loading()
                      : Padding(
                          padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(
                              8,
                            ),
                            left: ScreenUtil().setWidth(
                              20,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: const SizedBox(
                                  height: 30,
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(
                                  335,
                                ),
                                height: ScreenUtil().setHeight(
                                  8,
                                ),
                                child: LinearProgressIndicator(
                                  value: 0.3,
                                  backgroundColor: Colors.grey,
                                  color: Colors.black45,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      ColorList.primary),
                                  minHeight: 5.0,
                                  semanticsLabel: 'semanticsLabel',
                                  semanticsValue: 'semanticsValue',
                                ),
                              ),

                              SizedBox(
                                height: ScreenUtil().setHeight(
                                  24,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '프로필',
                                        style: TextStyle(
                                          color: ColorList.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: ScreenUtil().setSp(
                                            20,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '을',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: ScreenUtil().setSp(
                                            20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '완성해주세요!',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenUtil().setSp(
                                        20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: ScreenUtil().setHeight(
                                  18,
                                ),
                              ),
                              Text(
                                '닉네임',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(
                                    14,
                                  ),
                                ),
                              ),

                              //이메일주소
                              SizedBox(
                                height: ScreenUtil().setHeight(
                                  8,
                                ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.white,
                                    width: ScreenUtil().setWidth(
                                      335,
                                    ),
                                    child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          validateNickname(value);
                                          validateNickname2(value);
                                        });
                                      },
                                      textInputAction: TextInputAction.next,
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: '닉네임을 입력해주세요',
                                        hintStyle: TextStyle(
                                          fontSize: ScreenUtil().setSp(
                                            14,
                                          ),
                                          color: const Color.fromARGB(
                                            255,
                                            163,
                                            163,
                                            163,
                                          ),
                                        ),
                                        suffixIcon:
                                            _nameController.text.isNotEmpty
                                                ? GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _nameController.clear();
                                                      });
                                                    },
                                                    child: const Icon(
                                                      Icons.clear,
                                                      color: Colors.grey,
                                                    ),
                                                  )
                                                : null,
                                      ),
                                    ),
                                  ),

                                  if (!isNicknameLengthValid)
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(top: 10),
                                      child: const Text(
                                        '2글자 이상 작성하세요.',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  // 길이 검사는 통과했지만, 문자 검사가 실패했을 때 메시지
                                  if (isNicknameLengthValid &&
                                      !isNicknameCharactersValid)
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(top: 10),
                                      child: const Text(
                                        '사용할 수 없는 별명이에요.',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  if (isNicknameLengthValid &&
                                      isNicknameCharactersValid)
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(top: 10),
                                      child: const Text(
                                        '좋은 이름이군요. 사용 가능해요',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(
                                  20,
                                ),
                              ),
                              const Text(
                                '생년월일',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(
                                    255,
                                    23,
                                    23,
                                    23,
                                  ),
                                ),
                              ),

                              //이메일주소
                              SizedBox(
                                height: ScreenUtil().setHeight(
                                  8,
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(
                                  335,
                                ),
                                height: ScreenUtil().setHeight(
                                  48,
                                ),
                                child: TextFormField(
                                  controller: _birthController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    //누를떄 컨테이너 모양

                                    hintText: 'ex) 19921192',
                                    hintStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(
                                        14,
                                      ),
                                      color: const Color.fromARGB(
                                        255,
                                        163,
                                        163,
                                        163,
                                      ),
                                    ),
                                  ),
                                  onChanged: ((value) {
                                    setState(
                                      () {
                                        // userId = value;
                                      },
                                    );
                                  }),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(
                                  20,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 0,
                                ),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _manBox = !_manBox;
                                          genderman();
                                          print(_manBox);
                                        });
                                      },
                                      child: Container(
                                        height: ScreenUtil().setHeight(
                                          48,
                                        ),
                                        width: ScreenUtil().setWidth(
                                          162,
                                        ),
                                        decoration: BoxDecoration(
                                          border: _manBox
                                              ? Border.all(
                                                  color:
                                                      const Color(0xff6C5FBC))
                                              : Border.all(
                                                  color: const Color.fromARGB(
                                                    255,
                                                    229,
                                                    229,
                                                    229,
                                                  ),
                                                ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: _manBox
                                              ? ColorList.primary
                                              : null,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '남',
                                            style: TextStyle(
                                              color: _manBox
                                                  ? Colors.white
                                                  : const Color.fromARGB(
                                                      255,
                                                      82,
                                                      82,
                                                      82,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(
                                        11,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _womanBox = !_womanBox;
                                          genderWoman();
                                          print(_womanBox);
                                        });
                                      },
                                      child: Container(
                                        height: ScreenUtil().setHeight(
                                          48,
                                        ),
                                        width: ScreenUtil().setWidth(
                                          162,
                                        ),
                                        decoration: BoxDecoration(
                                          border: _womanBox
                                              ? Border.all(
                                                  color:
                                                      const Color(0xff6C5FBC))
                                              : Border.all(
                                                  color: const Color.fromARGB(
                                                    255,
                                                    229,
                                                    229,
                                                    229,
                                                  ),
                                                ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: _womanBox
                                              ? ColorList.primary
                                              : null,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '여',
                                            style: TextStyle(
                                              color: _womanBox
                                                  ? Colors.white
                                                  : const Color.fromARGB(
                                                      255,
                                                      82,
                                                      82,
                                                      82,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: ScreenUtil().setHeight(
                                  20,
                                ),
                              ),
                              const Text(
                                '위치',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(
                                    255,
                                    23,
                                    23,
                                    23,
                                  ),
                                ),
                              ),

                              //이메일주소
                              Container(
                                color: Colors.white,
                                height: ScreenUtil().setHeight(
                                  8,
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(
                                  335,
                                ),
                                height: ScreenUtil().setHeight(
                                  48,
                                ),
                                child: TextFormField(
                                  controller: _locationController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    //누를떄 컨테이너 모양

                                    hintText: '서울시 강남구',
                                    hintStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(
                                        14,
                                      ),
                                      color: const Color.fromARGB(
                                        255,
                                        163,
                                        163,
                                        163,
                                      ),
                                    ),
                                  ),
                                  onChanged: ((value) {
                                    setState(
                                      () {
                                        // userId = value;
                                      },
                                    );
                                  }),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(
                                  40,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _onSubmit(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                decoration: BoxDecoration(
                  color: (isNicknameLengthValid &&
                          isNicknameCharactersValid &&
                          (_manBox || _womanBox))
                      ? ColorList.primary
                      : const Color(0xffE6E6F6),
                ),
                child: const Center(
                  child: Text(
                    '다음',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    String name = _nameController.text;
    if (Utils.isValidate(name: '이름', value: name) == false) return;

    String? gender = _manBox
        ? 'male'
        : _womanBox
            ? 'female'
            : null;
    if (gender == null) {
      Fluttertoast.showToast(msg: '성별을 선택해주세요.');
      return;
    }
    String birth = _birthController.text;
    if (Utils.isValidate(
            name: '생년월일', value: birth, isCheckNum: true, length: 8) ==
        false) return;
    birth = Utils.getExistDateByProfileBirth(birth);
    String location = _locationController.text;
    if (Utils.isValidate(name: '위치', value: location) == false) return;

    Utils.hideKeyboard();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => PhoneProfileTwo(
          profileCreate: ProfileCreate(
            name: name,
            gender: gender,
            birth: birth,
            location: location,
          ),
        ),
      ),
    );
  }
}
