import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/auth/phoneprofile.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/components/text_padding.dart';
import 'package:flutter_metalk/utils/firebase_utils.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  bool _isSendingCode = false;
  String? _verificationId;
  int? _forceResendingToken;
  Timer? _timeoutTimer;
  int _remainTimeoutSecond = 0;
  final int _verifyTimeoutSecond = 120;
  late String _userEmail;
  bool _isVerifyingCode = false;

  @override
  void initState() {
    super.initState();
    _userEmail = FirebaseAuth.instance.currentUser!.email!;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () => _onBackPressed(),
              child: const Icon(
                Icons.arrow_back_ios_new_sharp,
                color: Colors.grey,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: const Text(
              '휴대전화 인증',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: double.infinity,),
                    if (_verificationId == null)...[
                      ..._widgetSend(),
                    ]else...[
                      ..._widgetVerifyCode(),
                    ],
                  ],
                ),
              ),
              if (_isSendingCode || _isVerifyingCode)...[
                Positioned.fill(child: Container(
                  color: Colors.black.withOpacity(.7),
                  child: const Center(child: Loading(color: Colors.white,),),
                )),
              ],
            ],
          ),
        ),
      ),
      onWillPop: () async {
        return _onBackPressed();
      },
    );
  }

  bool _onBackPressed() {
    if (_verificationId != null) {
      _isSendingCode = false;
      _timeoutTimer?.cancel();
      setState(() => _verificationId = null);
    } else {
      Navigator.pop(context);
    }
    return false;
  }

  List<Widget> _widgetVerifyCode() {
    return [
      const Text(
        '보내드린 인증번호\n6자리를 입력해주세요',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      const Text(
        '인증번호',
        style: TextStyle(
          fontWeight: FontWeight.w800,
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        width: MediaQuery.of(context).size.width / 1.1,
        child: TextFormField(
          controller: _codeController,
          focusNode: _codeFocusNode,
          maxLength: 6,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            hintText: '인증번호 6자리',
            hintStyle: TextStyle(
              fontSize: 13.0,
            ),
          ),
          onChanged: ((value) => setState(() => {})),
        ),
      ),
      const SizedBox(height: 5,),
      TextPadding('남은 시간 $_remainTimeoutSecond초', fontSize: 12,),
      const SizedBox(
        height: 20,
      ),
      GestureDetector(
        onTap: () => _verifyCode(),
        child: Container(
          width: MediaQuery.of(context).size.width / 1.1,
          height: 50,
          decoration: BoxDecoration(
            color: _codeController.text.isNotEmpty ? const Color.fromARGB(
              255,
              21,
              213,
              213,
            ) : const Color(0xffB1EEEC),
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          child: const Center(
            child: Text(
              '확인',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
              ),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.question_mark,
            size: 13,
          ),
          const Text(
            '인증문자를 받지 못하셨나요?',
            style: TextStyle(
              fontSize: 13.0,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () => _resendVerifyCode(),
            child: Column(
              children: [
                const Text(
                  '인증문자 재발송',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  color: Colors.grey,
                  width: MediaQuery.of(context).size.width / 4.7,
                  height: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _widgetSend() {
    return [
      const Text(
        '휴대폰 번호를 인증해주세요!',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      const Text(
        '휴대폰 번호',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
        width: MediaQuery.of(context).size.width / 1.1,
        child: TextFormField(
          controller: _phoneController,
          maxLength: 11,
          keyboardType: TextInputType.number,
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
            hintText: '- 없이 숫자만 입력',

            hintStyle: TextStyle(
              fontSize: 13.0,
            ),
          ),
          onChanged: ((value) => setState(() => {})),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      GestureDetector(
        onTap: () => _onSendVerify(),
        child: Container(
          width: MediaQuery.of(context).size.width / 1.1,
          height: 50,
          decoration: BoxDecoration(
            color: _isAblePhone() ? const Color.fromARGB(
              255,
              21,
              213,
              213,
            ) : const Color(0xffB1EEEC),
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          child: const Center(
            child: Text(
              '인증문자 받기',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  bool _isAblePhone() {
    return _phoneController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _startTimeoutTimer() {
    if (mounted == false) return;
    _timeoutTimer?.cancel();
    setState(() => _remainTimeoutSecond = _verifyTimeoutSecond);
    _timeoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_remainTimeoutSecond > 0) {
          setState(() => _remainTimeoutSecond--);
        } else {
          _verifyPhoneTimeoutEvent();
        }
      } else {
        _timeoutTimer?.cancel();
      }
    });
  }

  void _verifyPhoneTimeoutEvent({
    bool isRefreshToken = false,
  }) {
    if (mounted) {
      if (isRefreshToken) _forceResendingToken = null;
      _timeoutTimer?.cancel();
      if (_verificationId != null) {
        _isSendingCode = false;
        Fluttertoast.showToast(msg: '인증번호 입력 시간이 초과되었습니다.\n다시 시도해주세요.');
        setState(() => _verificationId = null);
      }
    }
  }

  void _verifyPhoneCodeSent(String verificationId, int? forceResendingToken) {
    if (mounted) {
      Fluttertoast.showToast(msg: '인증번호를 발송하였습니다.');
      setState(() {
        _codeController.text = '';
        _isSendingCode = false;
      });
      setState(() {
        _verificationId = verificationId;
        _forceResendingToken = forceResendingToken;
      });
      _startTimeoutTimer();
    }
  }

  Future<void> _onSendVerify() async {
    String phoneNumberStr = _phoneController.text;
    int? phoneNumber = int.tryParse(phoneNumberStr);
    if (phoneNumberStr.isEmpty) {
      Fluttertoast.showToast(msg: '휴대폰 번호를 입력해주세요.');
      return;
    } else if (phoneNumberStr.length != 11) {
      Fluttertoast.showToast(msg: '휴대폰 번호는 11자리만 입력해주세요\n예) 01012345678');
      return;
    } else if (phoneNumber == null) {
      Fluttertoast.showToast(msg: '휴대폰 번호는 숫자만 입력해주세요.');
      return;
    } else if (_isSendingCode) {
      Fluttertoast.showToast(msg: '인증 코드를 발송 중입니다.\n잠시만 기다려주세요.');
      return;
    }

    Utils.hideKeyboard();
    setState(() => _isSendingCode = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumberStr.replaceFirst('0', '+82'),
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
        debugPrint('verificationCompleted()');
        Logger().i(phoneAuthCredential);
      },
      verificationFailed: (FirebaseAuthException error) {
        debugPrint('verificationFailed()');
        Logger().i(error);
        Fluttertoast.showToast(msg: '인증 번호 발송에 실패하였습니다.\n오류 코드: ${error.code}\n메시지: ${error.message}');
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        debugPrint('codeSent() - verificationId: $verificationId, forceResendingToken: $forceResendingToken');
        _verifyPhoneCodeSent(verificationId, forceResendingToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint('codeAutoRetrievalTimeout() - verificationId: $verificationId');
        _verifyPhoneTimeoutEvent();
      },
      timeout: Duration(seconds: _verifyTimeoutSecond),
      forceResendingToken: _forceResendingToken,
    );
  }

  Future<void> _resendVerifyCode() async {
    _onSendVerify();
  }

  Future<void> _verifyCode() async {
    String codeStr = _codeController.text;
    int? code = int.tryParse(codeStr);
    if (codeStr.isEmpty) {
      Fluttertoast.showToast(msg: '코드를 입력해주세요.');
      return;
    } else if (codeStr.length != 6) {
      Fluttertoast.showToast(msg: '코드는 6자리만 입력해주세요.');
      return;
    } else if (code == null) {
      Fluttertoast.showToast(msg: '코드는 숫자만 입력해주세요.');
      return;
    } else if (_isVerifyingCode) {
      Fluttertoast.showToast(msg: '인증 문자 확인 중입니다.\n잠시만 기다려주세요.');
      return;
    }

    setState(() => _isVerifyingCode = true);
    _codeFocusNode.unfocus();
    Utils.hideKeyboard();

    String verificationId = _verificationId!;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: codeStr,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      await FirebaseAuth.instance.currentUser?.delete();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _userEmail,
        password: FirebaseUtils.socialLoginPassword,
      );
      await UserApi.updateVerifyPhone(
        userId: FirebaseAuth.instance.currentUser!.uid,
        isVerifyPhone: true,
        phone: _phoneController.text,
      );

      Fluttertoast.showToast(msg: '인증되었습니다.');
      Future.delayed(Duration.zero, () => Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const PhoneProfile(),
        ),
      ));
    } catch (e) {
      Fluttertoast.showToast(msg: '인증번호가 다릅니다.\n정확한 인증번호를 입력해주세요.');
    }
    setState(() => _isVerifyingCode = false);
  }
}
