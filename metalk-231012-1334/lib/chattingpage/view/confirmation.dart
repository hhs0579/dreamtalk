import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/components/image_padding.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/components/text_padding.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CoinConfirmation extends StatefulWidget {
  final String targetUserId;

  const CoinConfirmation({super.key,
    required this.targetUserId,
  });

  @override
  State<CoinConfirmation> createState() => _CoinConfirmationState();
}

class _CoinConfirmationState extends State<CoinConfirmation> {
  bool _isLoading = true;
  late UserVo _userVo;
  late UserVo _targetUserVo;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    UserVo? userVo = await UserApi.getUserIfNotToLogin();
    if (userVo == null) return;
    _userVo = userVo;

    userVo = await UserApi.getUserById(widget.targetUserId,
      myUserVo: _userVo,
    );
    if (mounted) {
      if (userVo == null) {
        Fluttertoast.showToast(msg: '해당 사용자를 찾을 수 없습니다.');
        Navigator.pop(context);
        return;
      }
      _targetUserVo = userVo;

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: SvgPicture.asset(
            "assets/image/Ic_toucharea.svg",
          ),
        ),
        title: Text(
          '메세지 코인 확인하기',
          style: TextStyle(
              fontSize: ScreenUtil().setSp(
                18,
              ),
              color: Colors.black,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: _isLoading ? const Loading() : Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(
            48,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                '${_targetUserVo.userName}님의 기본 메세지 코인',
                style: TextStyle(
                  color: const Color.fromARGB(
                    255,
                    64,
                    64,
                    64,
                  ),
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(
                    16,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(
                20,
              ),
            ),
            Stack(
              children: [
                const ImagePadding('coin-bg.png', width: 140, height: 140,),
                Positioned(
                  top: 45,
                  left: 2,
                  width: 140,
                  child: Center(
                    child: TextPadding(Utils.numberFormat(_targetUserVo.msgCoin), fontWeight: FontWeight.w900, fontSize: 28, color: Colors.white, height: 1,),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setHeight(
                400,
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      3,
                      201,
                      195,
                    ),
                    borderRadius: BorderRadius.circular(
                      16,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
