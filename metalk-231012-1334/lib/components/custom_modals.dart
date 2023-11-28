import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_metalk/components/image_padding.dart';
import 'package:flutter_metalk/components/text_padding.dart';
import 'package:flutter_metalk/extentions/level_ext.dart';
import 'package:flutter_metalk/loginpage.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/utils/custom_styles.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomModals {
  //1~7일차 출석체크 모델
  static void showCheckAttendance(BuildContext context, {
    required UserVo userVo,
    required int maxLoginDay,
    required int maxContinuousDay,
  }) {
    int totalCoin = 0;
    if (maxLoginDay >= 7) {
      totalCoin = 600 + 500;
    } else if (maxLoginDay > 0) {
      totalCoin = 100 * maxLoginDay;
    }

    if (maxContinuousDay >= 7) {
      totalCoin += 500;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                color: Colors.black.withOpacity(.6),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 7.0,
                    sigmaY: 7.0,
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
            Container(
              height: ScreenUtil().setHeight(
                662,
              ),
              width: ScreenUtil().setWidth(
                375,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      // left: 20.0,
                      top: ScreenUtil().setHeight(
                        20,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '출석체크',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(
                              20,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            4,
                          ),
                        ),
                        Text(
                          '7일 연속 출석 시 500C 지급',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(
                              14,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            12,
                          ),
                        ),
                        if (maxLoginDay > 0)...[
                          Container(
                            width: ScreenUtil().setWidth(
                              98 * 3 + 12 * 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: const Color(0xffF3FCFC),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                TextPadding('누적 출석 $maxLoginDay일', fontWeight: FontWeight.w700, fontSize: 14, color: const Color(0xff525252),),
                                const SizedBox(height: 4,),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Color(0xff525252),
                                    ),
                                    children: [
                                      const TextSpan(text: '총 '),
                                      TextSpan(text: '${totalCoin}C', style: const TextStyle(color: Color(0xff02A19C))),
                                      const TextSpan(text: ' 적립'),
                                    ]
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12,),
                        ],
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            _widgetCouponContanier(
                              title: '1일차',
                              description: "100c",
                              isActive: maxLoginDay >= 1,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            _widgetCouponContanier(
                              title: '2일차',
                              description: "100c",
                              isActive: maxLoginDay >= 2,
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(
                                12,
                              ),
                            ),
                            _widgetCouponContanier(
                              title: '3일차',
                              description: "100c",
                              isActive: maxLoginDay >= 3,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            12,
                          ),
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            _widgetCouponContanier(
                              title: '4일차',
                              description: "100c",
                              isActive: maxLoginDay >= 4,
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(
                                12,
                              ),
                            ),
                            _widgetCouponContanier(
                              title: '5일차',
                              description: "100c",
                              isActive: maxLoginDay >= 5,
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(
                                12,
                              ),
                            ),
                            _widgetCouponContanier(
                              title: '6일차',
                              description: "100c",
                              isActive: maxLoginDay >= 6,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            12,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28),
                          child: Image.asset(
                            maxLoginDay >= 7 ? 'assets/image/7day-active.png' : "assets/image/iconbuttonseven-4x.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Expanded(child: SizedBox(height: 10,)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: ScreenUtil().setHeight(
                              56,
                            ),
                            width: ScreenUtil().setWidth(
                              335,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(
                                15,
                              ),
                              color: const Color.fromARGB(
                                255,
                                3,
                                201,
                                195,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '확인',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(
                                    16,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // 프로필 바텀시트
  static void showProfileModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                color: Colors.black.withOpacity(.4),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(
                    20,
                  ),
                  top: ScreenUtil().setHeight(
                    20,
                  ),
                  right: ScreenUtil().setWidth(
                    20,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '수수료 감면 혜택 안내',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(
                          20,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        8,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Container(
                        height: ScreenUtil().setHeight(
                          234,
                        ),
                        width: ScreenUtil().setWidth(
                          380,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            255,
                            245,
                            245,
                            245,
                          ),
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(
                              14,
                            ),
                            left: ScreenUtil().setWidth(
                              16,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int index = 0; index < LevelExt.values.length; index++)...[
                                if (index > 0)...[
                                  SizedBox(
                                    height: ScreenUtil().setHeight(
                                      12,
                                    ),
                                  ),
                                ],
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        ImagePadding(LevelExt.values[index].icon, width: 24, height: 24,),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(
                                            8,
                                          ),
                                        ),
                                        Text(
                                          LevelExt.values[index].title,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: ScreenUtil().setSp(
                                              14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(
                                          20,
                                        ),
                                      ),
                                      child: Text(
                                        '${LevelExt.values[index].feeReducePer}%',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: ScreenUtil().setSp(
                                            14,
                                          ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        20,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: const Color.fromARGB(
                                  255,
                                  245,
                                  245,
                                  245,
                                ),
                              ),
                              height: ScreenUtil().setHeight(
                                56,
                              ),
                              width: ScreenUtil().setWidth(
                                164,
                              ),
                              child: Center(
                                child: Text(
                                  '취소',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      82,
                                      82,
                                      82,
                                    ),
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
                            width: ScreenUtil().setWidth(
                              5,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: const Color.fromARGB(255, 3, 201, 195),
                              ),
                              height: ScreenUtil().setHeight(
                                56,
                              ),
                              width: ScreenUtil().setWidth(
                                164,
                              ),
                              child: Center(
                                child: Text(
                                  '확인',
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
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 100,),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  static Widget _widgetCouponContanier({
    required String title,
    required String description,
    required bool isActive,
  }) {
    return CouponContanier(
      width: ScreenUtil().setWidth(
        98,
      ),
      height: ScreenUtil().setHeight(
        98,
      ),
      title: title,
      description: description,
      style: TextStyle(
        color: const Color.fromARGB(
          255,
          2,
          161,
          156,
        ),
        fontWeight: FontWeight.bold,
        fontSize: ScreenUtil().setSp(
          14,
        ),
      ),
      image: "assets/image/coincoin.svg",
      isActive: isActive,
    );
  }

  static showLevelUpModal(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            width: ScreenUtil().setWidth(
              375,
            ),
            height: ScreenUtil().setHeight(
              360,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: ScreenUtil().setWidth(
                    147,
                  ),
                  top: ScreenUtil().setHeight(
                    50,
                  ),
                  child: SvgPicture.asset(
                    "assets/image/level/crown-goldbig.svg",
                  ),
                ),
                Positioned(
                  left: ScreenUtil().setWidth(
                    73,
                  ),
                  top: ScreenUtil().setHeight(
                    140,
                  ),
                  child: Text(
                    '골드 레벨 업! 20다이아 획득,',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(
                        20,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  left: ScreenUtil().setWidth(
                    90,
                  ),
                  top: ScreenUtil().setHeight(
                    174,
                  ),
                  child: Text(
                    'Alex님, Lv20으로 레벨업 되었어요.',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(
                        14,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  left: ScreenUtil().setWidth(
                    70,
                  ),
                  top: ScreenUtil().setHeight(
                    195,
                  ),
                  child: Text(
                    '레벨이 올라가면 다이아몬드를 선물로 드려요.',
                    style: TextStyle(
                      color: const Color.fromARGB(
                        255,
                        64,
                        64,
                        64,
                      ),
                      fontSize: ScreenUtil().setSp(
                        14,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  static showBlockUser(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  child: Text(
                    '해당 계정은 정지된 계정입니다.\n자세한 내용은 고객센터에 문의해주세요.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1.5,
                  color: Colors.grey[100],
                ),
                TextButton(
                  onPressed: () {
                    Utils.navigatorPush(context, const LoginPage(), isRemoveUntil: true);
                  },
                  style: CustomStyles.textButtonZeroSize(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.grey[500],
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Center(
                      child: Text(
                        '확인',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            scrollable: true,
          );
        }
    );
  }
}