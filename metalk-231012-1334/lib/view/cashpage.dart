import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/apis/user_diamond_api.dart';
import 'package:flutter_metalk/chattingpage/view/detailprofile.dart';
import 'package:flutter_metalk/components/user_item.dart';
import 'package:flutter_metalk/extentions/gender_ext.dart';
import 'package:flutter_metalk/model/user_diamond_vo.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/profile/manprofile/diamondpage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

class CashPage extends StatefulWidget {
  const CashPage({super.key});

  @override
  State<CashPage> createState() => _CashPageState();
}

class _CashPageState extends State<CashPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          '다이아몬드 선물 리스트',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: ScreenUtil().setSp(
              18,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(
            8,
          ),
        ),
        child: FutureBuilder(
          future: UserApi.getUserIfNotToLogin(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            UserVo? userVo = snapshot.hasData ? snapshot.data : null;
            if (userVo == null) return Container();

            return FutureBuilder(
              future: UserDiamondApi.getUserDiamonds(userVo.id,
                isUsed: userVo.userGender == GenderExt.male,
                isNullTargetUserId: false,
                isOrderByCreateDt: true,
              ),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                List<UserDiamondVo> userDiamondVoList = snapshot.hasData ? snapshot.data : [];

                return ListView.separated(
                  itemCount: userDiamondVoList.length,
                  itemBuilder: (BuildContext context, int index) {
                    UserDiamondVo userDiamondVo = userDiamondVoList[index];

                    return FutureBuilder(
                      future: UserApi.getUserById(userDiamondVo.targetUserId!),
                      builder: (BuildContext context, AsyncSnapshot<UserVo?> snapshot) {
                        UserVo? targetUserVo = snapshot.hasData ? snapshot.data : null;
                        if (targetUserVo == null) return Container();

                        return UserItem(
                          userVo: targetUserVo,
                          isDiamondGiftPage: true,
                        );
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(thickness: 1, height: 1, color: HexColor('#F5F5F5'),);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}