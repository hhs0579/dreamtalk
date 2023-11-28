import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/exchange_api.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/apis/user_coin_api.dart';
import 'package:flutter_metalk/components/custom_border.dart';
import 'package:flutter_metalk/components/image_padding.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/components/notice_box.dart';
import 'package:flutter_metalk/components/select_bank_modal.dart';
import 'package:flutter_metalk/components/text_padding.dart';
import 'package:flutter_metalk/components/waiting_verify_exchange_modal.dart';
import 'package:flutter_metalk/model/bank_item.dart';
import 'package:flutter_metalk/model/exchange_vo.dart';
import 'package:flutter_metalk/model/user_coin_vo.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

class ExChangePage extends StatefulWidget {
  const ExChangePage({super.key});

  @override
  _ExChangePageState createState() => _ExChangePageState();
}

class _ExChangePageState extends State<ExChangePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool correction = true;

  bool isLoading = true;
  late UserVo _userVo;

  bool _isProcessing = false;
  final TextEditingController _coinController = TextEditingController();
  final TextEditingController _bankOwnerNameController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();

  List<ExchangeVo> _exchangeVoList = [];

  Future<void> _initData() async {
    UserVo? userVo = await UserApi.getUserIfNotToLogin();
    if (userVo == null) return;
    if (mounted) {
      _userVo = userVo;

      if (_userVo.isVerifyExchange == false) {
        WaitingVerifyExchangeModal.showModal(context);
      }

      _initExchangeList();
    }
  }

  Future<void> _initExchangeList() async {
    _exchangeVoList = await ExchangeApi.getExchanges(_userVo.id);
    _exchangeVoList.sort((a, b) => a.createDt.isBefore(b.createDt) ? 1 : -1);
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SvgPicture.asset(
            "assets/image/Ic_toucharea.svg",
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          '환전 신청',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          indicatorColor: const Color.fromARGB(
            255,
            113,
            213,
            203,
          ),
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 2,
          tabs: [
            Tab(
              child: Text(
                '환전 신청',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(
                    14,
                  ),
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(
                    255,
                    34,
                    34,
                    34,
                  ),
                ),
              ),
            ),
            Tab(
              child: Text(
                '환전 내역',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(
                    14,
                  ),
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(
                    255,
                    34,
                    34,
                    34,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading ? const Loading() : TabBarView(
        controller: _tabController,
        children: [
          _widgetExOnePage(),
          _widgetExTwoPage(),
        ],
      ),
    );
  }

  Widget _widgetExTwoPage() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        itemCount: _exchangeVoList.length,
        itemBuilder: (BuildContext context, int index) {
          ExchangeVo exchangeVo = _exchangeVoList[index];

          return Column(
            children: [
              if (index > 0)...[
                const SizedBox(height: 10,),
              ],
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: HexColor('#FAFAFA'),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Wrap(
                          children: [
                            TextPadding('${Utils.numberFormat(exchangeVo.coin)}C', fontWeight: FontWeight.w600, fontSize: 18, color: HexColor('#171717'),),
                            const SizedBox(width: 7,),
                            const ImagePadding('exchange-icon.png', width: 24, height: 24,),
                            const SizedBox(width: 7,),
                            TextPadding('₩${Utils.numberFormat(exchangeVo.money)}', fontWeight: FontWeight.w600, fontSize: 18, color: HexColor('#171717'),),
                          ],
                        )),
                        Container(
                          decoration: BoxDecoration(
                            color: exchangeVo.isComplete ? HexColor('#03C9C3') : HexColor('#737373'),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: TextPadding(exchangeVo.isComplete ? '환전 완료' : '환전 대기', fontWeight: FontWeight.w600, fontSize: 12, color: Colors.white, height: 1,),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    TextPadding(exchangeVo.createDtStr, fontWeight: FontWeight.w500, fontSize: 13, color: HexColor('#525252'),),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _widgetExOnePage() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                const ImagePadding('exchange-info.png', width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 20),),
                const CustomBorder(),
                Padding(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "환전할 코인금액을 입력하세요.",
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
                      const Text(
                        "최소 10,000코인 이상 환전이 가능해요!",
                        style: TextStyle(
                          color: Color.fromARGB(
                            255,
                            82,
                            82,
                            82,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(
                          24,
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(
                          335,
                        ),
                        height: ScreenUtil().setHeight(
                          48,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(
                            255,
                            250,
                            250,
                            250,
                          ),
                          border: Border.all(
                            color: const Color.fromARGB(
                              255,
                              229,
                              229,
                              229,
                            ),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(
                                  16,
                                ),
                                right: ScreenUtil().setWidth(
                                  14,
                                ),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/image/smallcoin.svg",
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(
                                      2,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _coinController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 13,
                                      onChanged: (value) {
                                        String parseValue = value.isNotEmpty ? Utils.parseOnlyNumber(value) : '0';
                                        int intValue = int.parse(parseValue);
                                        int beforeSelection = _coinController.selection.baseOffset;
                                        _coinController.text = Utils.numberFormat(intValue);
                                        int nextSelection = beforeSelection + 1;
                                        if (nextSelection > _coinController.text.length) {
                                          nextSelection = _coinController.text.length;
                                        }
                                        _coinController.selection = TextSelection.fromPosition(TextPosition(offset: nextSelection));
                                        setState(() {});
                                      },
                                      decoration: const InputDecoration(
                                        counterText: '',
                                        hintText: "1,000",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "C",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(
                                        14,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(
                          37,
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(
                          335,
                        ),
                        height: ScreenUtil().setHeight(
                          48,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(
                            255,
                            245,
                            245,
                            245,
                          ),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(
                                  16,
                                ),
                                right: ScreenUtil().setWidth(
                                  14,
                                ),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/image/ww.svg",
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(
                                      2,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        hintText: _getExchangeMoney(),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "원",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 23, 23, 23),
                                      fontSize: ScreenUtil().setSp(
                                        14,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              left: ScreenUtil().setWidth(
                                150,
                              ),
                              bottom: ScreenUtil().setHeight(
                                37,
                              ),
                              child: SvgPicture.asset(
                                "assets/image/arrow.svg",
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(
                          12,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '수수료 포함 차감될 Coin',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 63, 63, 63),
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(
                                13,
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
                              '${_coinController.text.isNotEmpty ? Utils.numberFormat(int.parse(Utils.parseOnlyNumber(_coinController.text))) : 0} Coin',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: ScreenUtil().setSp(
                                  13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(
                          6,
                        ),
                      ),
                      Text(
                        '${_userVo.levelExt.title}등급 현금 지급 수수료 ${_userVo.levelExt.feeReducePer}%',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            13,
                          ),
                          color: const Color.fromARGB(
                            255,
                            115,
                            115,
                            115,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(
                    30,
                  ),
                ),
                //입금될 통장 계좌 정보
                Padding(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(
                      20,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "입금될 통장 계좌 정보",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(
                                20,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(
                          24,
                        ),
                      ),
                      Text(
                        "통장 소유주",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            14,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(
                          8,
                        ),
                      ),
                      //수정완료
                      correction
                          ? Container(
                        width: ScreenUtil().setWidth(
                          335,
                        ),
                        height: ScreenUtil().setHeight(
                          48,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(
                              255,
                              229,
                              229,
                              229,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                          color: const Color.fromARGB(
                            255,
                            250,
                            250,
                            250,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(
                              16,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _bankOwnerNameController,
                                  decoration: InputDecoration(
                                    hintText: "임보람",
                                    hintStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(
                                        14,
                                      ),
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          : Container(
                        width: ScreenUtil().setWidth(
                          335,
                        ),
                        height: ScreenUtil().setHeight(
                          48,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(
                              255,
                              229,
                              229,
                              229,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                          color: const Color.fromARGB(
                            255,
                            245,
                            245,
                            245,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(
                              16,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '임보람',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(
                                    14,
                                  ),
                                  color: const Color.fromARGB(
                                    255,
                                    163,
                                    163,
                                    163,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(
                          20,
                        ),
                      ),
                      Text(
                        "은행명",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            14,
                          ),
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(
                            255,
                            23,
                            23,
                            23,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(
                          8,
                        ),
                      ),
                      correction
                          ? GestureDetector(
                        onTap: () => SelectBankModal.showModal(context,
                          onPressed: (BankItem bankItem) {
                            setState(() => _bankNameController.text = bankItem.name);
                          },
                        ),
                        child: Container(
                          width: ScreenUtil().setWidth(
                            335,
                          ),
                          height: ScreenUtil().setHeight(
                            48,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(
                                255,
                                229,
                                229,
                                229,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(
                              255,
                              250,
                              250,
                              250,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(
                                16,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _bankNameController.text.isEmpty ? '은행명을 선택해주세요' : _bankNameController.text,
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(
                                      14,
                                    ),
                                    color: _bankNameController.text.isEmpty ? Colors.grey : const Color.fromARGB(
                                      255,
                                      23,
                                      23,
                                      23,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: ScreenUtil().setWidth(
                                      21,
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/image/chevron-down.svg",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      //수정완료
                          : Container(
                        width: ScreenUtil().setWidth(
                          335,
                        ),
                        height: ScreenUtil().setHeight(
                          48,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(
                              255,
                              229,
                              229,
                              229,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(
                            255,
                            245,
                            245,
                            245,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(
                              16,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '농협은행',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(
                                    14,
                                  ),
                                  color: const Color.fromARGB(
                                    255,
                                    163,
                                    163,
                                    163,
                                  ),
                                ),
                              ),
                              // SvgPicture.asset(
                              //   "assets/image/chevron-down.svg",
                              // ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(
                          20,
                        ),
                      ),
                      Text(
                        "계좌번호",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(
                            14,
                          ),
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(
                            255,
                            23,
                            23,
                            23,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(
                          8,
                        ),
                      ),
                      correction
                          ? Container(
                        width: ScreenUtil().setWidth(
                          335,
                        ),
                        height: ScreenUtil().setHeight(
                          48,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(
                              255,
                              229,
                              229,
                              229,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(
                            255,
                            250,
                            250,
                            250,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(
                              16,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _bankAccountController,
                                  decoration: InputDecoration(
                                    hintText: "351-1234-1234-34",
                                    hintStyle: TextStyle(
                                      fontSize: ScreenUtil().setSp(
                                        14,
                                      ),
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          : Container(
                        width: ScreenUtil().setWidth(
                          335,
                        ),
                        height: ScreenUtil().setHeight(
                          48,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(
                              255,
                              229,
                              229,
                              229,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(
                            255,
                            245,
                            245,
                            245,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(
                              16,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '351-1234-1234-34',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(
                                    14,
                                  ),
                                  color: const Color.fromARGB(
                                    255,
                                    163,
                                    163,
                                    163,
                                  ),
                                ),
                              ),
                            ],
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
                          335,
                        ),
                        height: ScreenUtil().setHeight(
                          172,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 248, 246, 246),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: ScreenUtil().setHeight(
                                16,
                              ),
                              left: ScreenUtil().setWidth(
                                16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/image/mono.svg",
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(
                                          4,
                                        ),
                                      ),
                                      Text(
                                        '유의사항',
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
                                    ],
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(
                                      8,
                                    ),
                                  ),
                                  const NoticeBox(
                                    title: "현금 지급 신청은 늘 가능합니다.",
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  const NoticeBox(
                                    title: "현금 지급 수수료는 레벨등급에 따라 차등 적용됩니다.",
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  const NoticeBox(
                                    title:
                                    "현금 지급 신청 후 공요일을 제외한\n일주일 내내 입금 처리 됩니다..",
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  const NoticeBox(
                                    title:
                                    "환전 금액이 5만원 이상 초과될 시에는, 3.3%사업소득세\n원천징수 후 입금 처리됩니다.",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(
                          56,
                        ),
                      ),

                      GestureDetector(
                        onTap: () => _onSubmitExchange(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
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
                          child: const Center(
                            child: Text(
                              '환전하기',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
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
        ),
        if (_isProcessing)...[
          Positioned.fill(child: Container(
            color: Colors.black.withOpacity(.6),
            child: const Center(
              child: Loading(color: Colors.white,),
            ),
          ))
        ]
      ],
    );
  }

  String _getExchangeMoney() {
    String coin = _coinController.text;
    if (coin.isEmpty) {
      return '1,000';
    } else {
      int intValue = int.parse(Utils.parseOnlyNumber(coin));
      int remainValue = (intValue * ((100 - _userVo.levelExt.feeReducePer) / 100)).floor();
      return Utils.numberFormat(remainValue);
    }
  }

  Future<void> _onSubmitExchange() async {
    setState(() => _isProcessing = true);
    Utils.hideKeyboard();
    FocusNode().unfocus();

    String coinStr = _coinController.text;
    int? coin = coinStr.isNotEmpty ? int.tryParse(Utils.parseOnlyNumber(coinStr)) : null;
    String moneyStr = _getExchangeMoney();
    int? money = moneyStr.isNotEmpty ? int.tryParse(Utils.parseOnlyNumber(moneyStr)) : null;
    String bankOwnerName = _bankOwnerNameController.text;
    String bankName = _bankNameController.text;
    String bankAccount = _bankAccountController.text;

    if (_userVo.isVerifyExchange == false) {
      Fluttertoast.showToast(msg: '현재 인증 대기중입니다.');
    } else if (coinStr.isEmpty || coin == null || coin < 10000) {
      Fluttertoast.showToast(msg: '환전할 코인을 최소 10,000코인 이상 입력해주세요.');
    } else if (money == null) {
      Fluttertoast.showToast(msg: '지급 금액이 잘못되었습니다.');
    } else if (bankOwnerName.isEmpty) {
      Fluttertoast.showToast(msg: '통장 소유주를 입력해주세요.');
    } else if (bankName.isEmpty) {
      Fluttertoast.showToast(msg: '은행명을 선택해주세요.');
    } else if (bankAccount.isEmpty) {
      Fluttertoast.showToast(msg: '계좌번호를 입력해주세요.');
    } else {
      bool isAble = await UserCoinApi.isAblePaymentCoin(
        userVo: _userVo,
        paymentCoin: coin,
      );
      if (isAble == false) {
        Fluttertoast.showToast(msg: '코인이 부족하여 구매할 수 없습니다.\n코인 충전 후 다시 진행해주세요.');
      } else {
        DateTime nowDt = DateTime.now();

        UserCoinVo userCoinVo = await UserCoinApi.createUserCoin(UserCoinVo(
          userId: _userVo.id,
          cnt: coin,
          isUsed: true,
          createDt: nowDt,
        ));
        await ExchangeApi.createExchange(ExchangeVo(
          userId: _userVo.id,
          coin: coin,
          money: money,
          level: _userVo.level,
          levelExt: _userVo.levelExt,
          feeReducePer: _userVo.levelExt.feeReducePer,
          createDt: nowDt,
          userCoinId: userCoinVo.id!,
        ));

        _coinController.text = '';
        _bankOwnerNameController.text = '';
        _bankNameController.text = '';
        _bankAccountController.text = '';

        await _initExchangeList();

        Fluttertoast.showToast(msg: '환전 신청 되었습니다.');
      }
    }

    setState(() => _isProcessing = false);
  }
}
