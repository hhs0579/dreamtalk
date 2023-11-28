import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/apis/user_coin_api.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/model/coin_item.dart';
import 'package:flutter_metalk/model/user_coin_vo.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/utils/purchase_utils.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CoinPage extends StatefulWidget {
  const CoinPage({super.key});

  @override
  State<CoinPage> createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  final List<CoinItem> _coinItems = [];
  bool isLoading = true;
  late UserVo _userVo;

  bool _isProcessingPurchase = false;
  StreamSubscription? _purchaseUpdatedSubscription;
  StreamSubscription? _purchaseErrorSubscription;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    UserVo? userVo = await UserApi.getUserIfNotToLogin();
    if (userVo == null) return;
    _userVo = userVo;

    await PurchaseUtils.init();
    if (!mounted) return;

    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen((PurchasedItem? purchasedItem) async {
      debugPrint('purchaseUpdated() - purchasedItem: $purchasedItem');

      bool isPurchased = false;

      if (purchasedItem != null) {
        if (Platform.isIOS) {
          isPurchased = purchasedItem.transactionStateIOS == TransactionState.purchased;
        } else {
          isPurchased = purchasedItem.purchaseStateAndroid == PurchaseState.purchased;
        }

        if (isPurchased) {
          CoinItem coinItem = _coinItems.firstWhere((element) => element.iapItem.productId == purchasedItem.productId);

          String? res = await FlutterInappPurchase.instance.finishTransaction(purchasedItem, isConsumable: true);
          debugPrint('finishTransaction() res: $res');

          await UserCoinApi.createUserCoin(UserCoinVo(
            userId: _userVo.id,
            cnt: coinItem.coin + coinItem.bonus,
            isUsed: false,
            createDt: DateTime.now(),
            paymentPrice: coinItem.price,
            paymentResult: purchasedItem.toString(),
          ));

          if (mounted) {
            Fluttertoast.showToast(msg: '정상적으로 결제되었습니다.');
          }
        }
      }
      if (mounted) setState(() => _isProcessingPurchase = false);
    });

    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen((purchaseError) {
      debugPrint('purchaseError() - purchase-error: $purchaseError');
      setState(() => _isProcessingPurchase = false);
    });

    List<IAPItem> items = await FlutterInappPurchase.instance.getProducts(PurchaseUtils.storeProductIdList);
    for (IAPItem item in items) {
      debugPrint('item: ${item.toJson()}');
    }
    _coinItems.addAll(items.map((e) => CoinItem(
      price: PurchaseUtils.getPriceByIAPItem(e),
      iapItem: e,
    )));
    _coinItems.sort((a, b) => a.price > b.price ? 1 : -1);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
          '코인 구매',
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
                6,
              ),
              left: ScreenUtil().setWidth(
                20,
              ),
              right: ScreenUtil().setWidth(
                20,
              ),
            ),
            child: isLoading ? const Loading() : ListView.builder(
              itemCount: _coinItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    if (index > 0)...[
                      const SizedBox(height: 10,),
                    ],
                    _widgetCoin(_coinItems[index]),
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

  Future<void> _onPaymentEvent(CoinItem coinItem) async {
    debugPrint('_onPressedHeart()');
    String? productId = coinItem.iapItem.productId;
    if (productId == null) {
      Fluttertoast.showToast(msg: '상품 ID 값이 올바르지 않습니다.');
      return;
    }
    debugPrint('requestPurchase() start');
    setState(() => _isProcessingPurchase = true);
    FlutterInappPurchase.instance.requestPurchase(productId);
  }

  @override
  void dispose() {
    _purchaseUpdatedSubscription?.cancel();
    _purchaseErrorSubscription?.cancel();
    super.dispose();
  }

  Widget _widgetCoin(CoinItem coinItem) {
    return GestureDetector(
      onTap: () => _onPaymentEvent(coinItem),
      child: CashContainer(
        container: coinItem.isPopular ? Container(
          width: ScreenUtil().setWidth(
            33,
          ),
          height: ScreenUtil().setHeight(
            20,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(
                255,
                255,
                109,
                109,
              ),
            ),
            borderRadius: BorderRadius.circular(
              100,
            ),
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              '인기',
              style: TextStyle(
                color: const Color.fromARGB(
                  255,
                  255,
                  109,
                  109,
                ),
                fontSize: ScreenUtil().setSp(
                  12,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ) : null,
        moneywidth: ScreenUtil().setWidth(
          85,
        ),
        moneyheight: ScreenUtil().setHeight(
          34,
        ),
        title: "${Utils.numberFormat(coinItem.coin)}C",
        description: "${Utils.numberFormat(coinItem.bonus)}C 보너스",
        money: "₩${Utils.numberFormat(coinItem.price)}",
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
    return Center(
      child: Container(
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
              top: ScreenUtil().setHeight(
                23.5,
              ),
              left: ScreenUtil().setWidth(
                18.5,
              ),
              child: SvgPicture.asset(
                "assets/image/bigcoin.svg",
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
                44,
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
                236,
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
                    // Image.asset(
                    //   "/Users/chlwlsgur1/FlutterProject/flutter_metalk/images/coinsss.png",
                    // ),
                    Text(
                      money,
                      style: TextStyle(
                        color: const Color.fromARGB(
                          255,
                          2,
                          121,
                          117,
                        ),
                        fontWeight: FontWeight.w700,
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
              top: ScreenUtil().setHeight(
                20,
              ),
              left: ScreenUtil().setWidth(
                148,
              ),
              child: Container(
                child: container,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
