import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/bottomnavigation/root_tab.dart';
import 'package:flutter_metalk/components/custom_modals.dart';
import 'package:flutter_metalk/loginpage.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/providers/base_provider.dart';
import 'package:flutter_metalk/utils/firebase_utils.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isCompleteTimer = false;
  bool _isCompleteData = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    _timer = Timer(Duration(milliseconds: 1500), () {
      _isCompleteTimer = true;
      navigate();
    });

    await BaseProvider.initDefaultList(context);
    _isCompleteData = true;
    navigate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void navigate() async {
    debugPrint('navigate() _isCompleteData: $_isCompleteData, _isCompleteTimer: $_isCompleteTimer');
    if (_isCompleteData == false || _isCompleteTimer == false) {
      return;
    }

    UserVo? userVo = await UserApi.getUser();
    if (!mounted) return;
    if (userVo != null && userVo.isBlock) {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      CustomModals.showBlockUser(context);
    } else {
      if (userVo == null
          || userVo.isVerifyPhone == false
          || userVo.isCompleteProfile() == false) {
        Utils.navigatorPush(context, const LoginPage(), isRemoveUntil: true);
      } else {
        Utils.navigatorPush(context, const RootTab(), isRemoveUntil: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //뒤로가기 버튼 방지
      body: WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(
                160,
              ),
            ),
            child: SvgPicture.asset(
              "assets/image/splashscreens.svg",
            ),
          ),
        ),
      ),
    );
  }
}
