import 'package:flutter/material.dart';
import 'package:flutter_metalk/auth/phoneauth.dart';
import 'package:flutter_metalk/loginpage.dart';



class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  bool _manbox = false;
  bool _womanbox = false;

  String _man = '남';
  String _woman = '여';
  //남자박스
  void genderWoman() {
    // gender = _woman;
    if (!_manbox) {
      _womanbox = !_womanbox;
    }
    if (_manbox) {
      _manbox = !_manbox;
    }
    if (!_womanbox) {
      _womanbox = !_womanbox;
    }
  }

  //여자박스
  void genderman() {
    // gender = _man;
    if (!_womanbox) {
      _manbox = !_manbox;
    }
    if (_womanbox) {
      _womanbox = !_womanbox;
    }
    if (!_manbox) {
      _manbox = !_manbox;
    }
  }

  bool _colors = false;
  Color _color = Colors.white;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LoginPage(),
                ),
              );
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color.fromARGB(
                255,
                131,
                128,
                128,
              ),
              size: 19,
            ),
          ),
          title: const Text(
            '회원가입',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 18.0),
                child: Text(
                  '이메일 주소',
                ),
              ),
              //이메일주소
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Container(
                  width: 360,
                  child: TextFormField(
                    // controller: _controlleremail,
                    decoration: const InputDecoration(
                      //누를떄 컨테이너 모양
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      //누르기 전 컨테이너 모양
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintText: 'abc@gmail.com',

                      hintStyle: TextStyle(
                        fontSize: 13.0,
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
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 18.0),
                child: Text(
                  '비밀번호',
                ),
              ),
              //이메일주소
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Container(
                  width: 360,
                  child: TextFormField(
                    // controller: _controlleremail,
                    decoration: const InputDecoration(
                      //누를떄 컨테이너 모양
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      //누르기 전 컨테이너 모양
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintText: '영문 대소문자,숫자,특수문자 포함 8자리 이상',

                      hintStyle: TextStyle(
                        fontSize: 13.0,
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
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 18.0),
                child: Text(
                  '비밀번호 확인',
                ),
              ),
              //이메일주소
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Container(
                  width: 360,
                  child: TextFormField(
                    // controller: _controlleremail,
                    decoration: const InputDecoration(
                      //누를떄 컨테이너 모양
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      //누르기 전 컨테이너 모양
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintText: '비밀번호 확인',

                      hintStyle: TextStyle(
                        fontSize: 13.0,
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
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 18.0),
                child: Text(
                  '이름',
                ),
              ),
              //이메일주소
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Container(
                  width: 360,
                  child: TextFormField(
                    // controller: _controlleremail,
                    decoration: const InputDecoration(
                      //누를떄 컨테이너 모양
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      //누르기 전 컨테이너 모양
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintText: '홍길동',

                      hintStyle: TextStyle(
                        fontSize: 13.0,
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
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 18.0),
                child: Text(
                  '생년월일',
                ),
              ),
              //이메일주소
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Container(
                  width: 360,
                  child: TextFormField(
                    // controller: _controlleremail,
                    decoration: const InputDecoration(
                      //누를떄 컨테이너 모양
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      //누르기 전 컨테이너 모양
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintText: '19921102',

                      hintStyle: TextStyle(
                        fontSize: 13.0,
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
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  '성별',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 0,
                ),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _manbox = !_manbox;
                          genderman();
                          print(_manbox);
                        });
                      },
                      child: Container(
                        height: 50,
                        width: width / 2.3,
                        decoration: BoxDecoration(
                          border: _manbox
                              ? Border.all(color: Colors.teal)
                              : Border.all(
                                  color: Colors.grey,
                                ),
                          borderRadius: BorderRadius.circular(5),
                          color: _manbox
                              ? const Color.fromARGB(
                                  255,
                                  168,
                                  250,
                                  243,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            _man,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _womanbox = !_womanbox;
                          genderWoman();
                          print(_womanbox);
                        });
                      },
                      child: Container(
                        height: 50,
                        width: width / 2.3,
                        child: Center(
                          child: Text(
                            _woman,
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: _womanbox
                              ? Border.all(color: Colors.teal)
                              : Border.all(
                                  color: Colors.grey,
                                ),
                          borderRadius: BorderRadius.circular(5),
                          color: _womanbox
                              ? const Color.fromARGB(
                                  255,
                                  168,
                                  250,
                                  243,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      builder: (context) {
                        return SizedBox(
                          height: 250,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              top: 20.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Text(
                                  '약관동의',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  '코인 충전 및 환전에 대한 금전적 내용에 관한 동의와\n어플에서 공지한 규칙을 위반하였을 시에 발생한\n모든 문제에 대해서는 책임의 소지가 개인에게 있습니다.',
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement<void, void>(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            const PhoneAuth(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 60,
                                    width: width / 1.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        15,
                                      ),
                                      color: const Color.fromARGB(
                                        255,
                                        79,
                                        223,
                                        223,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '동의하고 가입하기',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 79, 223, 223),
                    ),
                    width: MediaQuery.of(context).size.width / 1.1,
                    height: 50,
                    child: const Center(
                      child: Text(
                        '확인',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
