import 'dart:ui';

import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_metalk/apis/chatting_api.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/apis/user_coin_api.dart';
import 'package:flutter_metalk/chattingpage/view/confirmation.dart';
import 'package:flutter_metalk/chattingpage/view/detailgift.dart';
import 'package:flutter_metalk/components/image_padding.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/components/send_diamond_modal.dart';
import 'package:flutter_metalk/components/user_item.dart';
import 'package:flutter_metalk/extentions/gender_ext.dart';
import 'package:flutter_metalk/model/chatting_vo.dart';
import 'package:flutter_metalk/model/user_coin_vo.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/profile/womanprofile/coinsettingpage.dart';
import 'package:flutter_metalk/providers/chat_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class DatailChattingPage extends StatefulWidget {
  final String targetUserId;

  const DatailChattingPage({
    super.key,
    required this.targetUserId,
  });

  @override
  State<DatailChattingPage> createState() => _DatailChattingPageState();
}

class _DatailChattingPageState extends State<DatailChattingPage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool addbutton = false;
  String userddiamondint = '';

  bool _isLoading = true;
  late UserVo _userVo;
  late UserVo _targetUserVo;
  List<ChattingVo> _chattingVoList = [];
  ChatProvider? _chatProvider;

  @override
  void dispose() {
    _focusNode.dispose();
    _messageController.dispose();
    _chatProvider?.removeListener(_chatProviderListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _chatProviderListener() {
    debugPrint('[detailchatting] _chatProviderListener()');
    _reloadList();
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

      _chatProvider = Provider.of<ChatProvider>(context, listen: false);
      _chatProvider!.addListener(_chatProviderListener);

      _reloadList();
    }
  }

  Future<void> _reloadList() async {
    _chattingVoList = await ChattingApi.getChattingList(
      userId: _userVo.id,
      targetUserId: _targetUserVo.id,
    );
    _chattingVoList.sort((a, b) => a.createDt.isBefore(b.createDt) ? 1 : -1);

    ChattingApi.updateAllRead(
      userId: _userVo.id,
      otherUserId: _targetUserVo.id,
    );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          addbutton = false;
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: addbutton ? false : true,
        backgroundColor: Colors.white,
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20.0),
            child: Container(
              color: const Color.fromARGB(
                255,
                229,
                229,
                229,
              ),
              width: ScreenUtil().setWidth(
                375,
              ),
              height: ScreenUtil().setHeight(
                1,
              ),
            ),
          ),
          title: _isLoading ? const Loading(size: 15,) : UserItem(
            userVo: _targetUserVo,
            isChatPage: true,
          ),
        ),
        body: _isLoading ? const Loading() : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _chattingVoList.length,
                reverse: true,
                itemBuilder: (BuildContext context, int index) {
                  ChattingVo chattingVo = _chattingVoList[index];

                  return Column(
                    children: [
                      if (index == _chattingVoList.length - 1)...[
                        const SizedBox(height: 21,),
                      ],
                      if (chattingVo.senderId == _userVo.id)...[
                        _widgetMyChat(chattingVo: chattingVo),
                      ]else...[
                        _widgetOtherChat(chattingVo: chattingVo),
                      ],
                      if (index == 0)...[
                        const SizedBox(height: 21,),
                      ],
                    ],
                  );
                },
              ),
            ),
            _widgetBottomBox(),
          ],
        ),
      ),
    );
  }

  Widget _widgetBoxItem({
    required GestureTapCallback onTap,
    required String svgImgPath,
    required String title,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            svgImgPath,
            width: 64,
            height: 64,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8,),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              letterSpacing: -.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetBottomBox() {
    List<Widget> boxItems = [];
    if (_userVo.userGender == GenderExt.male) {
      boxItems.addAll([
        _widgetBoxItem(
          onTap: () => SendDiamondModal.showModal(context,
            userId: _userVo.id,
            targetUserVo: _targetUserVo,
          ),
          svgImgPath: 'assets/image/chattingdiamond.svg',
          title: '다이아 보내기',
        ),
        _widgetBoxItem(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CoinConfirmation(
                targetUserId: _targetUserVo.id,
              ),
            ),
          ),
          svgImgPath: 'assets/image/chattingbigcoin.svg',
          title: '코인 확인하기',
        ),
        _widgetBoxItem(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => DetailGiftPage(
                targetUserId: _targetUserVo.id,
              ),
            ),
          ),
          svgImgPath: 'assets/image/chattinggift.svg',
          title: '선물하기',
        ),
      ]);
    } else {
      boxItems.addAll([
        _widgetBoxItem(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const CoinSettingPage(),
            ),
          ),
          svgImgPath: 'assets/image/chat-coin-setting.svg',
          title: '코인 설정하기',
        ),
      ]);
    }

    return Stack(
      children: [
        Container(
          color: Colors.white,
          height: addbutton ? MediaQuery.of(context).size.height / 2.1 : 0.0,
          width: MediaQuery.of(context).size.width / 1.0,
          child: Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(70),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AutoHeightGridView(
                itemCount: boxItems.length,
                crossAxisSpacing: 21,
                crossAxisCount: 4,
                mainAxisSpacing: 20,
                builder: (BuildContext context, int index) {
                  return boxItems[index];
                },
              ),
            ),
          ),
        ),
        Container(
          height: ScreenUtil().setHeight(
            66,
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 10.0,
                offset: const Offset(
                  10,
                  -10,
                ), // changes position of shadow
              ),
            ],
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(
                16,
              ),
              top: ScreenUtil().setHeight(
                10,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: SizedBox(
                    height: ScreenUtil().setHeight(
                      32,
                    ),
                    width: ScreenUtil().setWidth(
                      32,
                    ),
                    child: FloatingActionButton(
                      backgroundColor:
                      const Color.fromARGB(255, 235, 235, 235),
                      onPressed: () {
                        setState(() {
                          addbutton = true;
                        });
                        _focusNode.unfocus();
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(
                    10,
                  ),
                ),
                Container(
                  width: ScreenUtil().setWidth(
                    249,
                  ),
                  height: ScreenUtil().setHeight(
                    42,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: HexColor('#E5E5E5')),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Center(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      maxLength: 100,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(
                          13,
                        ),
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        counterText: '',
                        hintText: "메세지를 작성해주세요...",
                        hintStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(13,),
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(
                    10,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(
                      2,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () => _sendMessage(),
                    child: SvgPicture.asset(
                      "assets/image/send.svg",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _widgetOtherChat({
    required ChattingVo chattingVo,
  }) {
    return Column(
      children: [
        const SizedBox(height: 4,),
        Padding(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(
              20,
            ),
          ),
          child: Row(
            children: [
              ImagePadding(
                _targetUserVo.profileImgUrl,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
                isNetwork: true,
                isCircle: true,
                defaultColor: Colors.grey,
              ),
              SizedBox(
                width: ScreenUtil().setWidth(
                  8,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Bubble(
                            nip: BubbleNip.leftBottom,
                            color: const Color.fromARGB(255, 228, 228, 228),
                            child: Text(
                              chattingVo.message,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(
                                2,
                              ),
                              right: 5,
                            ),
                            child: Text(
                              chattingVo.createDtStr,
                              style: TextStyle(
                                color: const Color.fromARGB(
                                  255,
                                  163,
                                  163,
                                  163,
                                ),
                                fontSize: ScreenUtil().setSp(
                                  11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _widgetMyChat({
    required ChattingVo chattingVo,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 4,),
        Container(
          padding: const EdgeInsets.only(right: 20),
          child: Bubble(
            nip: BubbleNip.rightBottom,
            color: const Color.fromARGB(255, 3, 181, 176,),
            child: Text(
              chattingVo.message,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(
                  14,
                ),
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(
              2,
            ),
            right: ScreenUtil().setWidth(
              20,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (chattingVo.id == null)...[
                const Loading(size: 11,),
              ]else...[
                Text(
                  '${chattingVo.createDtStr}${chattingVo.isRead ? ' 읽음' : ''}',
                  style: TextStyle(
                    color: const Color.fromARGB(
                      255,
                      163,
                      163,
                      163,
                    ),
                    fontSize: ScreenUtil().setSp(
                      11,
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }

  void _addChattingToList(ChattingVo chattingVo) {
    _chattingVoList.add(chattingVo);
    _chattingVoList.sort((a, b) => a.createDt.isBefore(b.createDt) ? 1 : -1);
    setState(() => {});
  }

  Future<void> _sendMessage() async {
    String message = _messageController.text;
    if (message.isEmpty) {
      Fluttertoast.showToast(msg: '메세지를 먼저 입력해주세요.');
      return;
    }

    DateTime nowDt = DateTime.now();
    if (_userVo.userGender == GenderExt.male) {
      bool isFirstMsg = _chattingVoList.isEmpty;
      int requireMsgCoin = isFirstMsg ? _targetUserVo.firstMsgCoin : _targetUserVo.msgCoin;
      bool isAble = await UserCoinApi.isAblePaymentCoin(
        userVo: _userVo,
        paymentCoin: requireMsgCoin,
      );
      if (isAble == false) {
        Fluttertoast.showToast(msg: '코인이 부족하여 메세지를 보낼 수 없습니다.');
        return;
      } else {
        UserCoinVo userCoinVo = await UserCoinApi.createUserCoin(UserCoinVo(
          userId: _userVo.id,
          cnt: requireMsgCoin,
          isUsed: true,
          createDt: nowDt,
        ));
        await UserCoinApi.createUserCoin(UserCoinVo(
          userId: _targetUserVo.id,
          cnt: requireMsgCoin,
          isUsed: false,
          createDt: nowDt,
          receiveCoinId: userCoinVo.id,
        ));
      }
    }

    _messageController.text = '';
    _focusNode.unfocus();

    ChattingVo chattingVo = ChattingVo(
      id: null,
      senderId: _userVo.id,
      receiverId: _targetUserVo.id,
      message: message,
      createDt: nowDt,
      isRead: false,
    );
    _addChattingToList(chattingVo);
    ChattingVo savedChattingVo = await ChattingApi.sendChatting(
      chattingVo: chattingVo,
      targetUserVo: _targetUserVo,
    );
    if (mounted) {
      ChattingVo? existChattingVo = _chattingVoList.firstWhereOrNull((element) {
        return element.id == null
            && element.createDt.isAtSameMomentAs(chattingVo.createDt);
      });
      if (existChattingVo != null) {
        existChattingVo.id = savedChattingVo.id;
      } else {
        _reloadList();
      }
      setState(() {});
    }
  }
}