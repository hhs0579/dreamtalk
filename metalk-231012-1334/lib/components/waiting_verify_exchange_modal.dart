import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WaitingVerifyExchangeModal {
  static void showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          height: ScreenUtil().setHeight(
            254,
          ),
          width: ScreenUtil().setWidth(
            375,
          ),
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5,
                  sigmaY: 5,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(
                    30,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(
                          90,
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/image/alert-circle-solid.svg",
                          ),
                          SizedBox(
                            width:
                            ScreenUtil().setWidth(
                              6,
                            ),
                          ),
                          Text(
                            "현재 인증 대기중입니다.",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                              ScreenUtil().setSp(
                                18,
                              ),
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        6,
                      ),
                    ),
                    Text(
                      '위 이메일 형식대로 보내시거나,',
                      style: TextStyle(
                        color: const Color.fromARGB(
                          255,
                          82,
                          82,
                          82,
                        ),
                        fontSize: ScreenUtil().setSp(
                          13,
                        ),
                      ),
                    ),
                    Text(
                      '이미 보내셨다면 영업일 기준으로',
                      style: TextStyle(
                        color: const Color.fromARGB(
                          255,
                          82,
                          82,
                          82,
                        ),
                        fontSize: ScreenUtil().setSp(
                          13,
                        ),
                      ),
                    ),
                    Text(
                      '인증까지 1~2일이 소요될 수 있으니,',
                      style: TextStyle(
                        color: const Color.fromARGB(
                          255,
                          82,
                          82,
                          82,
                        ),
                        fontSize: ScreenUtil().setSp(
                          13,
                        ),
                      ),
                    ),
                    Text(
                      '후에 다시 한번 시도해주세요.',
                      style: TextStyle(
                        color: const Color.fromARGB(
                          255,
                          82,
                          82,
                          82,
                        ),
                        fontSize: ScreenUtil().setSp(
                          13,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        49,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                            20,
                          ),
                          color: const Color.fromARGB(
                            255,
                            3,
                            201,
                            195,
                          ),
                        ),
                        height: ScreenUtil().setHeight(
                          56,
                        ),
                        width: ScreenUtil().setWidth(
                          335,
                        ),
                        child: Center(
                          child: Text(
                            '확인',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                              ScreenUtil().setSp(
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
            ],
          ),
        );
      },
    );
  }
}