import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/apis/user_diamond_api.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/model/user_diamond_vo.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

class SendDiamondModal {
  static void showModal(BuildContext context, {
    required String userId,
    required UserVo targetUserVo,
  }) {
    final TextEditingController diamondController = TextEditingController();

    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return FutureBuilder(
              future: UserApi.getUserById(userId),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                bool isLoading = snapshot.hasData == false;
                UserVo? userVo = snapshot.data as UserVo?;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.black.withOpacity(.01),
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
                      padding: EdgeInsets.only(top: 20, right: 20, left: 20,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: isLoading ? const Loading() : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '다이아몬드 몇개를 보내시겠습니까?',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight:
                              FontWeight.bold,
                              fontSize:
                              ScreenUtil().setSp(
                                20,
                              ),
                            ),
                          ),
                          SizedBox(
                            height:
                            ScreenUtil().setHeight(
                              12,
                            ),
                          ),
                          Container(
                            width:
                            ScreenUtil().setWidth(
                              335,
                            ),
                            height:
                            ScreenUtil().setHeight(
                              48,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(
                                  8.0),
                              color:
                              const Color.fromARGB(
                                255,
                                250,
                                250,
                                250,
                              ),
                              border: Border.all(
                                color: const Color
                                    .fromARGB(
                                  255,
                                  229,
                                  229,
                                  229,
                                ),
                              ),
                            ),
                            child: Center(
                              //상대유저 다이아값
                              child: TextField(
                                controller: diamondController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) => setState(() => {}),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(
                            height:
                            ScreenUtil().setHeight(
                              8,
                            ),
                          ),
                          //내 다이아 보유개수
                          Padding(
                            padding: EdgeInsets.only(
                              left:
                              ScreenUtil().setWidth(
                                80,
                              ),
                            ),
                            child: Text(
                              '다이아몬드 보유 갯수: ${Utils.numberFormat(userVo!.getRemainDiamond())}개',
                              style: TextStyle(
                                fontSize:
                                ScreenUtil().setSp(
                                  14,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height:
                            ScreenUtil().setHeight(
                              28,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  width: ScreenUtil()
                                      .setWidth(
                                    164,
                                  ),
                                  height: ScreenUtil()
                                      .setHeight(
                                    56,
                                  ),
                                  decoration:
                                  BoxDecoration(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      16,
                                    ),
                                    color: const Color
                                        .fromARGB(
                                      255,
                                      245,
                                      245,
                                      245,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '취소',
                                      style: TextStyle(
                                        color:
                                        Colors.black,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        fontSize:
                                        ScreenUtil()
                                            .setSp(
                                          14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil()
                                    .setWidth(
                                  7,
                                ),
                              ),
                              Opacity(
                                opacity: diamondController.text.isNotEmpty ? 1 : 0.5,
                                child: GestureDetector(
                                  onTap: () => onSendDiamond(context, diamond: diamondController.text, userVo: userVo, targetUserVo: targetUserVo),
                                  child: Container(
                                    width: ScreenUtil()
                                        .setWidth(
                                      164,
                                    ),
                                    height: ScreenUtil()
                                        .setHeight(
                                      56,
                                    ),
                                    decoration:
                                    BoxDecoration(
                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                        16,
                                      ),
                                      color: diamondController.text.isNotEmpty
                                          ? HexColor('#03C9C3')
                                          : const Color.fromARGB(255, 177, 238, 236,).withOpacity(0.5,),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '확인',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                          fontSize:
                                          ScreenUtil()
                                              .setSp(
                                            14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20,),
                        ],
                      ),
                    )
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  static Future<void> onSendDiamond(BuildContext context, {
    required String diamond,
    required UserVo userVo,
    required UserVo targetUserVo,
  }) async {
    Utils.hideKeyboard();
    FocusNode().unfocus();
    if (diamond.isEmpty) {
      Fluttertoast.showToast(msg: '갯수를 입력해주세요.');
      return;
    }

    int? diamondNum = int.tryParse(diamond);
    if (diamondNum == null) {
      Fluttertoast.showToast(msg: '정수형만 입력해주세요.');
      return;
    }

    if (diamondNum > userVo.getRemainDiamond()) {
      Fluttertoast.showToast(msg: '최대 ${Utils.numberFormat(userVo.getRemainDiamond())}개 이상 사용할 수 없습니다.');
      return;
    }

    Navigator.pop(context);

    bool isAble = await UserDiamondApi.isAblePayment(
      userVo: userVo,
      payment: diamondNum,
    );

    if (isAble) {
      DateTime nowDt = DateTime.now();
      await UserDiamondApi.createUserDiamond(UserDiamondVo(
        userId: userVo.id,
        cnt: diamondNum,
        isUsed: true,
        createDt: nowDt,
        targetUserId: targetUserVo.id,
      ));
      await UserDiamondApi.createUserDiamond(UserDiamondVo(
        userId: targetUserVo.id,
        cnt: diamondNum,
        isUsed: false,
        createDt: nowDt,
        targetUserId: userVo.id,
      ));

      Fluttertoast.showToast(msg: '다이아몬드 ${Utils.numberFormat(diamondNum)}개를 보냈습니다.');
    } else {
      Fluttertoast.showToast(msg: '다이아몬드가 부족합니다.\n충전 후 다시 시도해주세요.');
    }
  }
}