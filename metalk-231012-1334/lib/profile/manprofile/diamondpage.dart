import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/apis/user_coin_api.dart';
import 'package:flutter_metalk/apis/user_diamond_api.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/model/diamond_item.dart';
import 'package:flutter_metalk/model/user_coin_vo.dart';
import 'package:flutter_metalk/model/user_diamond_vo.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/utils/utils.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DiamondPage extends StatefulWidget {
  const DiamondPage({super.key});

  @override
  State<DiamondPage> createState() => _DiamondPageState();
}

class _DiamondPageState extends State<DiamondPage> {
  List<DiamondItem> _diamondItems = [];
  bool isLoading = true;
  late UserVo _userVo;

  bool _isProcessingPurchase = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    UserVo? userVo = await UserApi.getUserIfNotToLogin();
    if (userVo == null) return;
    _userVo = userVo;

    _diamondItems.addAll([
      DiamondItem(coin: 3000),
      DiamondItem(coin: 5000),
      DiamondItem(coin: 10000),
      DiamondItem(coin: 30000),
      DiamondItem(coin: 90000),
    ]);

    setState(() => isLoading = false);
  }

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
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: SvgPicture.asset(
            "assets/image/Ic_toucharea.svg",
          ),
        ),
        title: Text(
          '다이아몬드 구매',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: ScreenUtil().setSp(
              18,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(
                20,
              ),
            ),
            child: isLoading ? const Loading() : ListView.builder(
              itemCount: _diamondItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    if (index > 0)...[
                      const SizedBox(height: 10,),
                    ],
                    _widgetDiamond(_diamondItems[index]),
                  ],
                );
              },
            ),
          ),
          if (_isProcessingPurchase)...[
            Positioned.fill(child: Container(
              color: Colors.black.withOpacity(.6),
              child: const Center(
                child: Loading(color: Colors.white,),
              ),
            ))
          ]
        ],
      ),
    );
  }

  Future<void> _onPaymentEvent(DiamondItem diamondItem) async {
    setState(() => _isProcessingPurchase = true);

    bool isAble = await UserCoinApi.isAblePaymentCoin(
      userVo: _userVo,
      paymentCoin: diamondItem.coin,
    );
    if (isAble) {
      DateTime nowDt = DateTime.now();

      await UserCoinApi.createUserCoin(UserCoinVo(
        userId: _userVo.id,
        cnt: diamondItem.coin,
        isUsed: true,
        createDt: nowDt,
      ));
      await UserDiamondApi.createUserDiamond(UserDiamondVo(
        userId: _userVo.id,
        cnt: diamondItem.coin + diamondItem.bonus,
        isUsed: false,
        createDt: nowDt,
      ));

      Fluttertoast.showToast(msg: '정상적으로 결제되었습니다.');
    } else {
      Fluttertoast.showToast(msg: '코인이 부족하여 구매할 수 없습니다.\n코인 충전 후 다시 진행해주세요.');
    }

    setState(() => _isProcessingPurchase = false);
  }

  Widget _widgetDiamond(DiamondItem diamondItem) {
    return GestureDetector(
      onTap: () => _onPaymentEvent(diamondItem),
      child: CashContainer(
        moneywidth: ScreenUtil().setWidth(
          98,
        ),
        moneyheight: ScreenUtil().setHeight(
          34,
        ),
        title: "${Utils.numberFormat(diamondItem.diamond)} 다이아",
        description: "${Utils.numberFormat(diamondItem.bonus)} 다이아 보너스",
        money: "${Utils.numberFormat(diamondItem.coin)}C",
      ),
    );
  }
}

class CashContainer extends StatelessWidget {
  final String title;
  final String? image;
  final String description;
  final Widget? container;
  final double? moneywidth;
  final double? moneyheight;
  final String money;

  const CashContainer({
    super.key,
    required this.title,
    this.image,
    required this.description,
    this.container,
    this.moneywidth,
    this.moneyheight,
    required this.money,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: ScreenUtil().setWidth(
        335,
      ),
      height: ScreenUtil().setHeight(
        82,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          16,
        ),
        color: const Color.fromARGB(
          255,
          243,
          252,
          252,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: ScreenUtil().setHeight(25.67),
            left: ScreenUtil().setWidth(
              18.5,
            ),
            child: SvgPicture.asset(
              "assets/image/mandiamond.svg",
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(
              20,
            ),
            left: ScreenUtil().setWidth(
              68,
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: ScreenUtil().setSp(
                  18,
                ),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(
              47,
            ),
            left: ScreenUtil().setWidth(
              68,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/image/plus.svg",
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(
                    2,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(
                      13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(
              24,
            ),
            left: ScreenUtil().setWidth(
              223,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  217,
                  247,
                  246,
                ),
                borderRadius: BorderRadius.circular(
                  100,
                ),
              ),
              width: moneywidth,
              height: moneyheight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/image/mancoin.svg",
                  ),
                  Text(
                    money,
                    style: TextStyle(
                      color: const Color.fromARGB(
                        255,
                        2,
                        121,
                        117,
                      ),
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(
                        16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //인기컨테이너
          Positioned(
            top: 22,
            left: 167,
            child: Container(
              child: container,
            ),
          ),
        ],
      ),
    );
  }
}
