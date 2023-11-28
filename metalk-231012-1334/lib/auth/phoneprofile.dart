import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
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
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: _isLoading ? const Loading() : Padding(
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
                  SizedBox(
                    width: ScreenUtil().setWidth(
                      335,
                    ),
                    height: ScreenUtil().setHeight(
                      4,
                    ),
                    child: const LinearProgressIndicator(
                      value: 0.3,
                      backgroundColor: Colors.grey,
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

                  Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(
                        6,
                      ),
                      right: ScreenUtil().setWidth(
                        20,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '1/3',
                          style: TextStyle(
                            color: const Color.fromARGB(
                              255,
                              115,
                              115,
                              115,
                            ),
                            fontSize: ScreenUtil().setSp(
                              12,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(
                      24,
                    ),
                  ),
                  Text(
                    '프로필을 완성해주세요!',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(
                        20,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: ScreenUtil().setHeight(
                      18,
                    ),
                  ),
                  Text(
                    '이름',
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

                  SizedBox(
                    width: ScreenUtil().setWidth(
                      335,
                    ),
                    height: ScreenUtil().setHeight(
                      48,
                    ),
                    child: TextFormField(
                      onChanged: (value) => setState(() => {}),
                      textInputAction: TextInputAction.next,
                      controller: _nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(
                          255,
                          250,
                          250,
                          250,
                        ),
                        //누를떄 컨테이너 모양
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromARGB(
                              255,
                              229,
                              229,
                              229,
                            ),
                          ),
                        ),
                        //누르기 전 컨테이너 모양
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromARGB(
                              255,
                              229,
                              229,
                              229,
                            ),
                          ),
                        ),
                        hintText: '홍길동',
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
                    ),
                  ),

                  SizedBox(
                    height: ScreenUtil().setHeight(
                      20,
                    ),
                  ),
                  Text(
                    '아이디',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(
                        14,
                      ),
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(
                        255,
                        23,
                        23,
                        23,
                      ),
                    ),
                  ),

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
                      textInputAction: TextInputAction.next,
                      controller: _idController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(
                          255,
                          250,
                          250,
                          250,
                        ),
                        //누를떄 컨테이너 모양
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromARGB(
                              255,
                              229,
                              229,
                              229,
                            ),
                          ),
                        ),
                        //누르기 전 컨테이너 모양
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromARGB(
                              255,
                              229,
                              229,
                              229,
                            ),
                          ),
                        ),
                        hintText: '아이디 입력',
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
                  Text(
                    '이메일',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(
                        14,
                      ),
                    ),
                  ),

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
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(
                          255,
                          250,
                          250,
                          250,
                        ),
                        //누를떄 컨테이너 모양
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromARGB(
                              255,
                              229,
                              229,
                              229,
                            ),
                          ),
                        ),
                        //누르기 전 컨테이너 모양
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromARGB(
                              255,
                              229,
                              229,
                              229,
                            ),
                          ),
                        ),
                        hintText: 'abc@gmail.com',
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
                  Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(
                        20,
                      ),
                    ),
                    child: const Text(
                      '성별',
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
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(
                      8,
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
                                      color: const Color.fromARGB(
                                        255,
                                        3,
                                        201,
                                        195,
                                      ),
                                    )
                                  : Border.all(
                                      color: const Color.fromARGB(
                                        255,
                                        229,
                                        229,
                                        229,
                                      ),
                                    ),
                              borderRadius: BorderRadius.circular(8),
                              color: _manBox
                                  ? const Color.fromARGB(
                                      255,
                                      230,
                                      250,
                                      249,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '남',
                                style: TextStyle(
                                  color: _manBox
                                      ? const Color.fromARGB(
                                          255,
                                          3,
                                          201,
                                          195,
                                        )
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
                                      color: const Color.fromARGB(
                                        255,
                                        3,
                                        201,
                                        195,
                                      ),
                                    )
                                  : Border.all(
                                      color: const Color.fromARGB(
                                        255,
                                        229,
                                        229,
                                        229,
                                      ),
                                    ),
                              borderRadius: BorderRadius.circular(8),
                              color: _womanBox
                                  ? const Color.fromARGB(
                                      255,
                                      230,
                                      250,
                                      249,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '여',
                                style: TextStyle(
                                  color: _womanBox
                                      ? const Color.fromARGB(
                                          255,
                                          3,
                                          201,
                                          195,
                                        )
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
                        fillColor: const Color.fromARGB(
                          255,
                          250,
                          250,
                          250,
                        ),
                        //누를떄 컨테이너 모양
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromARGB(
                              255,
                              229,
                              229,
                              229,
                            ),
                          ),
                        ),
                        //누르기 전 컨테이너 모양
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromARGB(
                              255,
                              229,
                              229,
                              229,
                            ),
                          ),
                        ),
                        hintText: '19921192',
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
                      controller: _locationController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(
                          255,
                          250,
                          250,
                          250,
                        ),
                        //누를떄 컨테이너 모양
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromARGB(
                              255,
                              229,
                              229,
                              229,
                            ),
                          ),
                        ),
                        //누르기 전 컨테이너 모양
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          borderSide: BorderSide(
                            color: Color.fromARGB(
                              255,
                              229,
                              229,
                              229,
                            ),
                          ),
                        ),
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
                  GestureDetector(
                    onTap: () => _onSubmit(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                        color: const Color.fromARGB(
                          255,
                          3,
                          201,
                          195,
                        ),
                      ),
                      width: ScreenUtil().setWidth(
                        335,
                      ),
                      height: ScreenUtil().setHeight(
                        56,
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
                  SizedBox(
                    height: ScreenUtil().setHeight(
                      350,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    String name = _nameController.text;
    if (Utils.isValidate(name: '이름', value: name) == false) return;
    String id = _idController.text;
    if (Utils.isValidate(name: '아이디', value: id) == false) return;
    String email = _emailController.text;
    if (Utils.isValidate(name: '이메일', value: email, isCheckEmail: true) == false) return;
    String? gender = _manBox ? 'male' : _womanBox ? 'female' : null;
    if (gender == null) {
      Fluttertoast.showToast(msg: '성별을 선택해주세요.');
      return;
    }
    String birth = _birthController.text;
    if (Utils.isValidate(name: '생년월일', value: birth, isCheckNum: true, length: 8) == false) return;
    birth = Utils.getExistDateByProfileBirth(birth);
    String location = _locationController.text;
    if (Utils.isValidate(name: '위치', value: location) == false) return;

    Utils.hideKeyboard();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
        PhoneProfileTwo(profileCreate: ProfileCreate(
          name: name,
          id: id,
          email: email,
          gender: gender,
          birth: birth,
          location: location,
        ),),
      ),
    );
  }
}
