import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/configs/global_config.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoinSettingPage extends StatefulWidget {
  final bool isFirstMsgCoin;

  const CoinSettingPage({super.key,
    this.isFirstMsgCoin = false,
  });

  @override
  State<CoinSettingPage> createState() => _CoinSettingPageState();
}

class _CoinSettingPageState extends State<CoinSettingPage> {
  bool _isLoading = true;
  late UserVo _userVo;

  late int valueHolder;
  late double valueMin;
  late double valueMax;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    UserVo? userVo = await UserApi.getUserIfNotToLogin();
    if (userVo == null) return;
    _userVo = userVo;

    valueHolder = widget.isFirstMsgCoin ? _userVo.firstMsgCoin : _userVo.msgCoin;
    valueMin = widget.isFirstMsgCoin ? GlobalConfig.firstMsgCoinMin.toDouble() : GlobalConfig.msgCoinMin.toDouble();
    valueMax = widget.isFirstMsgCoin ? GlobalConfig.firstMsgCoinMax.toDouble() : GlobalConfig.msgCoinMax.toDouble();

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
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
        title: const Text(
          '코인 설정하기',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _isLoading ? const Loading() : Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(
            48,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '기본 메세지 코인 설정',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(
                    16,
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(
                  20,
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(
                  117,
                ),
                height: ScreenUtil().setHeight(
                  123,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 148, 233, 225),
                    width: 10,
                  ),
                  color: const Color.fromARGB(255, 31, 190, 174),
                  borderRadius: BorderRadius.circular(
                    70,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$valueHolder',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(
                          28,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Coin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(
                          16,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(
                  52,
                ),
              ),
              Container(
                child: Slider(
                  value: valueHolder.toDouble(),
                  min: valueMin,
                  max: valueMax,
                  divisions: 100,
                  activeColor: const Color.fromARGB(
                    255,
                    3,
                    201,
                    195,
                  ),
                  thumbColor: Colors.white,
                  inactiveColor: const Color.fromARGB(
                    255,
                    163,
                    163,
                    163,
                  ),
                  label: '${valueHolder.round()}',
                  onChanged: (double newValue) {
                    setState(() {
                      valueHolder = newValue.round();
                    });
                    if (widget.isFirstMsgCoin) {
                      UserApi.updateFirstMsgCoinByDebounce(_userVo.id, valueHolder);
                    } else {
                      UserApi.updateMsgCoinByDebounce(_userVo.id, valueHolder);
                    }
                  },
                  semanticFormatterCallback: (double newValue) {
                    return '${newValue.round()}';
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(
                        20,
                      ),
                    ),
                    child: Text(
                      valueMin.toInt().toString(),
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(
                          14,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    ((valueMax + valueMin) / 2).round().toString(),
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(
                        14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: ScreenUtil().setWidth(
                        20,
                      ),
                    ),
                    child: Text(
                      valueMax.toInt().toString(),
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(
                          14,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
