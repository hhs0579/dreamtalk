import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/apis/user_coin_api.dart';
import 'package:flutter_metalk/apis/user_login_date_api.dart';
import 'package:flutter_metalk/components/custom_modals.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/model/user_coin_vo.dart';
import 'package:flutter_metalk/model/user_login_date_vo.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../view/cashpage.dart';
import '../view/chattingpage.dart';
import '../view/mainpage.dart';
import '../view/profilepage.dart';

class RootTab extends StatefulWidget {
  const RootTab({
    super.key,
  });

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initLoginDay();
  }

  Future<void> _initLoginDay() async {
    UserVo? userVo = await UserApi.getUserIfNotToLogin();
    if (userVo == null) return;

    List<UserCoinVo> userCoins = await UserCoinApi.getUserCoins(userVo.id);
    List<UserLoginDateVo> userLoginDateVoList = await UserLoginDateApi.getUserLoginDatesByUserId(userVo.id);
    DateTime nowDt = DateTime.now();
    
    bool isLoginToday = userLoginDateVoList.indexWhere((element) => Utils.isSameDay(element.dt, nowDt)) >= 0;
    if (isLoginToday == false) {
      UserLoginDateVo todayUserLoginDateVo = await UserLoginDateApi.addUserLoginDateByToday(userId: userVo.id);
      userLoginDateVoList.add(todayUserLoginDateVo);
    }

    int maxLoginDay = UserLoginDateVo.getMaxLoginDay(userLoginDateVoList);
    int maxGiveCoinDayCnt = UserCoinVo.coinByLoginDay.length;
    if (maxLoginDay > maxGiveCoinDayCnt) maxLoginDay = maxGiveCoinDayCnt;
    List<UserCoinVo> userCoinsByLoginDay = userCoins.where((element) => element.isLoginDay).toList();
    if (maxLoginDay > userCoinsByLoginDay.length) {
      List<int> giveDayList = List.generate(maxLoginDay, (index) => index + 1);
      for (int dayCnt in giveDayList) {
        bool isExistGaveCoin = userCoinsByLoginDay.indexWhere((element) => element.loginDay == dayCnt) >= 0;
        if (isExistGaveCoin == false) {
          await UserCoinApi.createUserCoin(UserCoinVo(
            userId: userVo.id,
            cnt: UserCoinVo.coinByLoginDay[dayCnt]!,
            isUsed: false,
            createDt: DateTime.now(),
            isLoginDay: true,
            loginDay: dayCnt,
          ));
        }
      }

      int maxContinuousDay = UserLoginDateVo.getMaxContinuous(userLoginDateVoList);
      List<UserCoinVo> userCoinsByContinuousDay = userCoins.where((element) => element.isContinuousDay).toList();
      int bonusDay = 7;
      if (maxContinuousDay == bonusDay) {
        if (userCoinsByContinuousDay.indexWhere((element) => element.continuousDay != bonusDay) < 0) {
          await UserCoinApi.createUserCoin(UserCoinVo(
            userId: userVo.id,
            cnt: 500,
            isUsed: false,
            createDt: DateTime.now(),
            isContinuousDay: true,
            continuousDay: bonusDay,
          ));
        }
      }

      userCoins = await UserCoinApi.getUserCoins(userVo.id);
      Future.delayed(Duration.zero, () => CustomModals.showCheckAttendance(context,
        userVo: userVo,
        maxLoginDay: maxLoginDay,
        maxContinuousDay: maxContinuousDay,
      ));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 3) {
      CustomModals.showProfileModalBottomSheet(context);
    }
  }

  final List<Widget> _bottomNavBarItems = [
    const MainPage(),
    const ChattingPage(),
    const CashPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _bottomNavBarItems.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(
          255,
          3,
          201,
          195,
        ),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/image/thumbs-upsvg.svg",
              color: _selectedIndex == 0
                  ? const Color.fromARGB(
                      255,
                      3,
                      201,
                      195,
                    )
                  : const Color.fromARGB(
                      255,
                      212,
                      212,
                      212,
                    ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  "assets/image/message-bubble.svg",
                  color: _selectedIndex == 1
                      ? const Color.fromARGB(
                          255,
                          3,
                          201,
                          195,
                        )
                      : const Color.fromARGB(
                          255,
                          212,
                          212,
                          212,
                        ),
                ),
                Positioned(
                  bottom: ScreenUtil().setHeight(
                    17,
                  ),
                  left: ScreenUtil().setWidth(
                    17,
                  ),
                  child: Container(
                    width: ScreenUtil().setWidth(
                      8,
                    ),
                    height: ScreenUtil().setHeight(
                      8,
                    ),
                    decoration: _selectedIndex == 1
                        ? BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            color: const Color.fromARGB(
                              255,
                              255,
                              105,
                              105,
                            ),
                            borderRadius: BorderRadius.circular(
                              100,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/image/bottomdiamond.svg",
                color: _selectedIndex == 2
                    ? const Color.fromARGB(
                        255,
                        3,
                        201,
                        195,
                      )
                    : null),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/image/userperson.svg",
              color: _selectedIndex == 3
                  ? const Color.fromARGB(
                      255,
                      3,
                      201,
                      195,
                    )
                  : const Color.fromARGB(
                      255,
                      212,
                      212,
                      212,
                    ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
