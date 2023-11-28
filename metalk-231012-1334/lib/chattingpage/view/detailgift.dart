import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/ios.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/apis/user_diamond_api.dart';
import 'package:flutter_metalk/components/custom_button.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/components/text_padding.dart';
import 'package:flutter_metalk/extentions/gift_ext.dart';
import 'package:flutter_metalk/model/user_diamond_vo.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

class DetailGiftPage extends StatefulWidget {
  final String targetUserId;

  const DetailGiftPage({super.key,
    required this.targetUserId,
  });

  @override
  State<DetailGiftPage> createState() => _DetailGiftPageState();
}

class _DetailGiftPageState extends State<DetailGiftPage> {
  bool isLoading = true;
  late UserVo _userVo;
  late UserVo _targetUserVo;
  List<dynamic> _giftItems = [];
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

      _giftItems = GiftExt.values.map((e) => {
        'item': e,
        'isChecked': false,
      }).toList();

      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: SvgPicture.asset(
            "assets/image/Ic_toucharea.svg",
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          '선물하기',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: isLoading ? const Loading() : Stack(
        children: [
          Column(
            children: [
              Expanded(child: AutoHeightGridView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: 3,
                itemCount: _giftItems.length,
                builder: (BuildContext context, int index) {
                  dynamic giftItem = _giftItems[index];
                  GiftExt giftExt = giftItem['item'];
                  bool isChecked = giftItem['isChecked'];

                  return GestureDetector(
                    onTap: () {
                      setState(() => giftItem['isChecked'] = !giftItem['isChecked']);
                    },
                    child: IconContainer(
                      image: giftExt.icon,
                      title: giftExt.title,
                      description: "${giftExt.diamond}${giftExt.diamond >= 1000 ? '\n' : ' '}다이아",
                      chackimage: isChecked ? "assets/image/check-circle.svg" : null,
                      decoration: isChecked
                          ? BoxDecoration(
                        color: const Color.fromARGB(
                          255,
                          230,
                          250,
                          249,
                        ),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: const Color.fromARGB(
                            255,
                            3,
                            201,
                            195,
                          ),
                        ),
                      )
                          : BoxDecoration(
                        color: const Color.fromARGB(
                          255,
                          245,
                          245,
                          245,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  );
                },
              )),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: HexColor('#03C9C3'),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CustomButton(
                  onPressed: () => _submitGift(),
                  child: Padding(
                    padding: const EdgeInsets.all(17),
                    child: TextPadding('선물 하기', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white, textAlign: TextAlign.center, height: 1,),
                  ),
                ),
              ),
            ],
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

  Future<void> _submitGift() async {
    setState(() => _isProcessingPurchase = true);

    List<GiftExt> checkedItems = _giftItems.where((element) => element['isChecked']).map((e) => e['item'] as GiftExt).toList();
    if (checkedItems.isEmpty) {
      Fluttertoast.showToast(msg: '한 개 이상 선택해주세요.');
    } else {
      int requireDiamond = 0;
      for (GiftExt item in checkedItems) {
        requireDiamond += item.diamond;
      }

      bool isAble = await UserDiamondApi.isAblePayment(
        userVo: _userVo,
        payment: requireDiamond,
      );

      if (isAble == false) {
        Fluttertoast.showToast(msg: '다이아몬드가 부족하여 구매할 수 없습니다.');
      } else {
        DateTime nowDt = DateTime.now();

        for (GiftExt item in checkedItems) {
          await UserDiamondApi.createUserDiamond(UserDiamondVo(
            userId: _userVo.id,
            cnt: item.diamond,
            isUsed: true,
            createDt: nowDt,
            targetUserId: _targetUserVo.id,
            giftExt: item,
          ));
          await UserDiamondApi.createUserDiamond(UserDiamondVo(
            userId: _targetUserVo.id,
            cnt: item.diamond,
            isUsed: false,
            createDt: nowDt,
            targetUserId: _userVo.id,
            giftExt: item,
          ));
        }

        Fluttertoast.showToast(msg: '선택한 선물을 모두 보냈습니다.');
        for (dynamic item in _giftItems) {
          item['isChecked'] = false;
        }
      }
    }

    setState(() => _isProcessingPurchase = false);
  }
}

class IconContainer extends StatelessWidget {
  final String? image;
  final IconData? icon;
  final String title;
  final String description;
  final String? descriptiontwo;
  final Decoration? decoration;
  final String? chackimage;
  const IconContainer({
    super.key,
    this.icon,
    required this.title,
    required this.description,
    this.descriptiontwo,
    this.image,
    this.decoration,
    this.chackimage,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: ScreenUtil().setHeight(
            64,
          ),
          width: ScreenUtil().setWidth(
            64,
          ),
          decoration: decoration,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              image != null
                  ? Center(
                      child: SvgPicture.asset(
                        image!,
                      ),
                    )
                  : const Text(''),
              chackimage != null
                  ? SvgPicture.asset(
                      chackimage!,
                    )
                  : const Text(''),
            ],
          ),
        ),
        SizedBox(
          height: ScreenUtil().setHeight(
            6,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: ScreenUtil().setSp(
              13,
            ),
          ),
        ),
        Text(
          description,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
