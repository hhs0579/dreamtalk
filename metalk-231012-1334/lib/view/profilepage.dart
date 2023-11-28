import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/bottomnavigation/root_tab.dart';
import 'package:flutter_metalk/components/custom_button.dart';
import 'package:flutter_metalk/components/custom_modals.dart';
import 'package:flutter_metalk/components/image_padding.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/components/logout_modal.dart';
import 'package:flutter_metalk/components/text_padding.dart';
import 'package:flutter_metalk/extentions/audio_state_ext.dart';
import 'package:flutter_metalk/extentions/gender_ext.dart';
import 'package:flutter_metalk/extentions/level_ext.dart';
import 'package:flutter_metalk/extentions/level_value_ext.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/profile/manprofile/coinpage.dart';
import 'package:flutter_metalk/profile/manprofile/diamondpage.dart';
import 'package:flutter_metalk/profile/settingpage.dart';
import 'package:flutter_metalk/profile/womanprofile/coinsettingpage.dart';
import 'package:flutter_metalk/profile/womanprofile/exchange/exchangepage.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<CarouselSliderState> _sliderKey = GlobalKey();
  bool _isLoading = true;
  late UserVo _userVo;

  int _current = 0;

  AudioPlayer? _audioPlayer;
  AudioStateExt _audioStateExt = AudioStateExt.stop;
  Duration? _playDuration;
  late Duration _totalDuration;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  } //애니메이션

  double value = 0.3;

  String _getCurrentDuration() {
    Duration? playDuration = _playDuration;
    int second = 0;

    if (playDuration != null && _audioStateExt == AudioStateExt.play) {
      second = playDuration.inSeconds;
    }

    return '0:${second.toString().padLeft(2, '0')} ';
  }

  @override
  void dispose() {
    _audioPlayer?.stop();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    UserVo? userVo = await UserApi.getUserIfNotToLogin();
    if (userVo == null) return;
    _userVo = userVo;

    if (_userVo.voiceMessageUrl != null) {
      if (_audioPlayer == null) {
        _audioPlayer = AudioPlayer();
        _audioPlayer!.playerStateStream.listen((event) {
          if (event.playing && event.processingState == ProcessingState.completed) {
            debugPrint('complete audio');
            _stopPlayRecordeFile();
          }
        });
        _audioPlayer!.positionStream.listen((event) {
          setState(() => _playDuration = event);
        });
      }
      await _audioPlayer!.setUrl(_userVo.voiceMessageUrl!);
      _totalDuration = _audioPlayer!.duration!;
    }

    setState(() => _isLoading = false);
  }

  Future<void> _reloadOnlyUser() async {
    UserVo? userVo = await UserApi.getUserIfNotToLogin();
    if (userVo == null) return;
    _userVo = userVo;
    setState(() => {});
  }

  Future<void> _stopPlayRecordeFile() async {
    debugPrint('_stopPlayRecordeFile()');
    await _audioPlayer?.stop();
    await _audioPlayer?.seek(const Duration(seconds: 0));
    setState(() => _audioStateExt = AudioStateExt.stop);
  }

  Future<void> _playRecordeFile() async {
    try {
      _audioPlayer!.play();
      setState(() => _audioStateExt = AudioStateExt.play);
    } catch (e) {
      Logger().e(e);
      debugPrint(e.toString());
      Fluttertoast.showToast(msg: '오디오 플레이어 재생 실패하였습니다..\n잠시 후 다시 시도해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 234, 234),
      body: _isLoading ? const Loading() : SingleChildScrollView(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Stack(
                  children: [
                    //이미지페이지 애니메이션
                    CarouselSlider.builder(
                      key: _sliderKey,
                      itemCount: _userVo.imageUrlList!.length,
                      itemBuilder:
                          (BuildContext context, int index, int pageViewIndex) {
                        return Container(
                          child: Stack(
                            children: [
                              Image.network(
                                _userVo.imageUrlList![index],
                                fit: BoxFit.fill,
                                height: ScreenUtil().setHeight(
                                  300,
                                ),
                                width: ScreenUtil().setWidth(
                                  375,
                                ),
                              ),
                              Positioned(
                                top: ScreenUtil().setHeight(
                                  55,
                                ),
                                left: ScreenUtil().setWidth(
                                  14,
                                ),
                                child: GestureDetector(
                                  onTap: () => Utils.navigatorPush(context, const RootTab(), isRemoveUntil: true),
                                  child: SvgPicture.asset(
                                    "assets/image/profileback.svg",
                                  ),
                                ),
                              ),
                              Positioned(
                                top: ScreenUtil().setHeight(
                                  60,
                                ),
                                left: ScreenUtil().setWidth(
                                  259,
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    dynamic result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const ProfileSettingPage(),
                                      ),
                                    );
                                    if (result != null && result.runtimeType == true.runtimeType && result == true) {
                                      setState(() => _isLoading = true);
                                      _initData();
                                    }
                                  },
                                  child: Container(
                                    width: width / 3.5,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(
                                        0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/image/profilepen.svg",
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(
                                            4,
                                          ),
                                        ),
                                        Text(
                                          '프로필 설정',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: ScreenUtil().setSp(
                                              13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (index == 0)
                                Positioned(
                                  top: ScreenUtil().setHeight(
                                    210,
                                  ),
                                  left: ScreenUtil().setWidth(
                                    110,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "${_userVo.userName}, ",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "${_userVo.age}세",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: ScreenUtil().setWidth(
                                              6,
                                            ),
                                          ),
                                          ImagePadding(_userVo.userGender.icon, width: 24, height: 24,),
                                        ],
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(
                                          6,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/image/globe-light.svg",
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: ScreenUtil().setWidth(
                                              2,
                                            ),
                                          ),
                                          Text(
                                            '${_userVo.firstLanguage(context)}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          SvgPicture.asset(
                                            "assets/image/smallcoin.svg",
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            Utils.numberFormat(_userVo.getRemainCoin()),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                      options: CarouselOptions(
                        viewportFraction: 1.0, // 화면비율
                        enableInfiniteScroll: true,
                        enlargeCenterPage: false, //페이지 넘어갈때 간격
                        autoPlay: false,
                        scrollDirection: Axis.horizontal,
                        reverse: false,
                        height: ScreenUtil().setHeight(
                          300,
                        ),
                        onPageChanged: (index, int) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),
                    Positioned(
                      top: ScreenUtil().setHeight(
                        275,
                      ),
                      left: 182,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: map<Widget>(
                          _userVo.imageUrlList!,
                          (index, url) {
                            return Container(
                              width: ScreenUtil().setWidth(6),
                              height: ScreenUtil().setHeight(
                                6,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(
                                  2,
                                ),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == index
                                    ? Colors.teal
                                    : Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              _widgetLevelBox(),

              SizedBox(
                height: ScreenUtil().setHeight(
                  8,
                ),
              ),

              //두번쨰 컨테이너박스
              Padding(
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(
                    8,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                  width: ScreenUtil().setWidth(
                    359,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(
                        12,
                      ),
                      bottom: ScreenUtil().setHeight(
                        12,
                      ),
                      left: ScreenUtil().setWidth(
                        20,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/image/messageteal.svg",
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '내 소개',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(
                                  16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            8,
                          ),
                        ),
                        Text(
                          _userVo.description ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: ScreenUtil().setSp(
                              14,
                            ),
                            color: const Color.fromARGB(
                              255,
                              64,
                              64,
                              64,
                            ),
                          ),
                        ),
                        if (_userVo.voiceMessageUrl != null)...[
                          SizedBox(
                            height: ScreenUtil().setHeight(
                              16,
                            ),
                          ),
                          Container(
                            height: ScreenUtil().setHeight(
                              60,
                            ),
                            width: ScreenUtil().setHeight(
                              319,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                255,
                                250,
                                250,
                                250,
                              ),
                              borderRadius: BorderRadius.circular(
                                12,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: ScreenUtil().setHeight(
                                    10,
                                  ),
                                  left: ScreenUtil().setWidth(
                                    12,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_audioStateExt == AudioStateExt.play) {
                                        _stopPlayRecordeFile();
                                      } else {
                                        _playRecordeFile();
                                      }
                                    },
                                    child: ImagePadding(
                                      _audioStateExt.profileIcon,
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(
                                    10,
                                  ),
                                ),
                                Positioned(
                                  top: ScreenUtil().setHeight(
                                    14,
                                  ),
                                  left: ScreenUtil().setWidth(
                                    62,
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/image/radio.svg",
                                  ),
                                ),
                                Positioned(
                                  left: 256,
                                  top: 22,
                                  child: Row(
                                    children: [
                                      Text(
                                        _getCurrentDuration(),
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            23,
                                            23,
                                            23,
                                          ),
                                          fontSize: ScreenUtil().setSp(
                                            12,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '/ 0:${_totalDuration.inSeconds.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            64,
                                            64,
                                            64,
                                          ),
                                          fontSize: ScreenUtil().setSp(
                                            12,
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
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(
                  8,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(
                    8,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                  width: ScreenUtil().setWidth(
                    359,
                  ),
                  height: ScreenUtil().setHeight(
                    130,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(
                        20,
                      ),
                      top: ScreenUtil().setHeight(
                        16,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_userVo.userGender == GenderExt.male)...[
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => const CoinPage(),
                                ),
                              );
                              _reloadOnlyUser();
                            },
                            child: Container(
                              width: ScreenUtil().setWidth(
                                98,
                              ),
                              height: ScreenUtil().setHeight(
                                98,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    214,
                                    247,
                                    246,
                                  ),
                                ),
                                color: const Color.fromARGB(
                                  255,
                                  243,
                                  252,
                                  252,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/image/bigcoin.svg",
                                    width: 40,
                                    height: 40,
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(
                                      6,
                                    ),
                                  ),
                                  const Text(
                                    '코인 구매',
                                    style: TextStyle(
                                      color: Color.fromARGB(
                                        255,
                                        2,
                                        161,
                                        156,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => const DiamondPage(),
                                ),
                              );
                              _reloadOnlyUser();
                            },
                            child: Container(
                              width: ScreenUtil().setWidth(
                                98,
                              ),
                              height: ScreenUtil().setHeight(
                                98,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    214,
                                    247,
                                    246,
                                  ),
                                ),
                                color: const Color.fromARGB(
                                  255,
                                  243,
                                  252,
                                  252,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/image/mandiamond.svg",
                                    width: 40,
                                    height: 40,
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(
                                      6,
                                    ),
                                  ),
                                  const Text(
                                    '다이아몬드 구매',
                                    style: TextStyle(
                                      color: Color.fromARGB(
                                        255,
                                        2,
                                        161,
                                        156,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12,),
                          Container(
                            width: ScreenUtil().setWidth(
                              98,
                            ),
                            height: ScreenUtil().setHeight(
                              98,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(
                                  255,
                                  214,
                                  247,
                                  246,
                                ),
                              ),
                              color: const Color.fromARGB(
                                255,
                                243,
                                252,
                                252,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/image/sevese.svg",
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(
                                    6,
                                  ),
                                ),
                                const Text(
                                  '고객 서비스',
                                  style: TextStyle(
                                    color: Color.fromARGB(
                                      255,
                                      2,
                                      161,
                                      156,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]else...[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const ExChangePage(),
                                ),
                              );
                            },
                            child: Container(
                              width: ScreenUtil().setWidth(
                                98,
                              ),
                              height: ScreenUtil().setHeight(
                                98,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    214,
                                    247,
                                    246,
                                  ),
                                ),
                                color: const Color.fromARGB(
                                  255,
                                  243,
                                  252,
                                  252,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/image/bigww.svg",
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(
                                      6,
                                    ),
                                  ),
                                  const Text(
                                    '환전신청',
                                    style: TextStyle(
                                      color: Color.fromARGB(
                                        255,
                                        2,
                                        161,
                                        156,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(
                              12,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  const CoinSettingPage(
                                    isFirstMsgCoin: true,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: ScreenUtil().setWidth(
                                98,
                              ),
                              height: ScreenUtil().setHeight(
                                98,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    214,
                                    247,
                                    246,
                                  ),
                                ),
                                color: const Color.fromARGB(
                                  255,
                                  243,
                                  252,
                                  252,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/image/coins.svg",
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(
                                      6,
                                    ),
                                  ),
                                  const Text(
                                    '코인설정',
                                    style: TextStyle(
                                      color: Color.fromARGB(
                                        255,
                                        2,
                                        161,
                                        156,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(
                              12,
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(
                              98,
                            ),
                            height: ScreenUtil().setHeight(
                              98,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(
                                  255,
                                  214,
                                  247,
                                  246,
                                ),
                              ),
                              color: const Color.fromARGB(
                                255,
                                243,
                                252,
                                252,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/image/sevese.svg",
                                ),
                                SizedBox(
                                  height: ScreenUtil().setHeight(
                                    6,
                                  ),
                                ),
                                const Text(
                                  '고객 서비스',
                                  style: TextStyle(
                                    color: Color.fromARGB(
                                      255,
                                      2,
                                      161,
                                      156,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: ScreenUtil().setHeight(
                  8,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(
                    8,
                  ),
                  right: ScreenUtil().setWidth(
                    8,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(
                        20,
                      ),
                      right: ScreenUtil().setWidth(
                        20,
                      ),
                      top: ScreenUtil().setHeight(
                        16,
                      ),
                      bottom: ScreenUtil().setHeight(
                        16,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => LogoutModal.showModal(context, () => Utils.logout(context)),
                      child: Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(
                          40,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(
                              255,
                              214,
                              247,
                              246,
                            ),
                          ),
                          color: const Color.fromARGB(
                            255,
                            243,
                            252,
                            252,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '로그아웃',
                              style: TextStyle(
                                color: Color.fromARGB(
                                  255,
                                  2,
                                  161,
                                  156,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: ScreenUtil().setHeight(
                  8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _widgetLevelBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextPadding(_userVo.levelExt.title, fontWeight: FontWeight.w800, fontSize: 20, color: Colors.black, height: 1.2,),
                      const SizedBox(width: 6,),
                      Container(
                        decoration: BoxDecoration(
                          color: HexColor('#F3FCFC'),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: HexColor('#E6FAF9')),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        child: TextPadding('Lv.${_userVo.level}', fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black,),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      TextPadding('사용${LevelExt.levelIsDiamond(_userVo.level) ? '다이아' : '코인'}', fontWeight: FontWeight.w600, fontSize: 12, color: HexColor('#737373'), height: 1.2,),
                      const SizedBox(width: 2,),
                      SvgPicture.asset(LevelExt.levelIsDiamond(_userVo.level) ? 'assets/image/mandiamond.svg' : 'assets/image/smallsmailcoin.svg', width: 15, height: 15, fit: BoxFit.contain,),
                      const SizedBox(width: 2,),
                      TextPadding(
                        LevelExt.levelIsDiamond(_userVo.level)
                          ? '${Utils.numberFormat(_userVo.levelDiamond)}D'
                          : '${Utils.numberFormat(_userVo.levelCoin)}C',
                        fontWeight: FontWeight.w700, fontSize: 14, color: HexColor('#171717'), height: 1,),
                    ],
                  ),
                  const SizedBox(height: 8,),
                  LinearProgressIndicator(
                    value: _getLevelProgressValue(),
                    backgroundColor: const Color.fromARGB(255, 229, 229, 229,),
                    color: Colors.black45,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 3, 201, 195,),
                    ),
                    minHeight: 8.0,
                    semanticsLabel: 'semanticsLabel',
                    semanticsValue: 'semanticsValue',
                  ),
                  const SizedBox(height: 4,),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      TextPadding(_getRemainLevelText(), fontWeight: FontWeight.w500, fontSize: 12, color: HexColor('#525252'),),
                      const SizedBox(width: 4,),
                      CustomButton(
                        onPressed: () => CustomModals.showProfileModalBottomSheet(context),
                        child: SvgPicture.asset("assets/image/questioncirclesolid.svg", width: 14, height: 14, fit: BoxFit.contain,),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 30,),
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              child: ImagePadding(_userVo.levelExt.icon, width: 60, height: 60,),
            ),
          ],
        ),
      ),
    );
  }

  double _getLevelProgressValue() {
    int level = _userVo.level;
    LevelValueExt levelValueExt = _userVo.levelValueExt;
    int levelCoin = _userVo.levelCoin;
    int levelDiamond = _userVo.levelDiamond;

    double remainValue;
    if (level >= 50) {
      remainValue = 1;
    } else if (level == 49) {
      remainValue = levelDiamond / LevelValueExt.lv50.minDiamond;
    } else {
      remainValue = (levelValueExt.minCoin - levelCoin) / LevelValueExt.getNextLevel(levelValueExt)!.minCoin;
    }

    if (remainValue > 1) {
      return 1;
    } else {
      return remainValue;
    }
  }

  String _getRemainLevelText() {
    int level = _userVo.level;
    LevelValueExt levelValueExt = _userVo.levelValueExt;
    LevelValueExt? nextLevelValueExt = LevelValueExt.getNextLevel(levelValueExt);
    int levelCoin = _userVo.levelCoin;
    int levelDiamond = _userVo.levelDiamond;

    if (level >= 50) {
      return '최대 레벨';
    } else if (nextLevelValueExt == null) {
      return '';
    } else if (level == 49) {
      return '${LevelExt.getLevelExtByLevel(nextLevelValueExt.level).title}'
          '(Lv.${nextLevelValueExt.level})까지 '
          '${Utils.numberFormat(nextLevelValueExt.minDiamond - levelDiamond)}Dia'
          '남음';
    } else {
      return '${LevelExt.getLevelExtByLevel(nextLevelValueExt.level).title}'
          '(Lv.${nextLevelValueExt.level})까지 '
          '${Utils.numberFormat(nextLevelValueExt.minCoin - levelCoin)}Coin'
          '남음';
    }
  }
}

//컨테이너 박스 ( )
class PersonContainer extends StatelessWidget {
  final String title;
  final IconData? icon;
  final double width;
  final double height;

  const PersonContainer({
    super.key,
    required this.title,
    this.icon,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 243, 240, 240),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          Text(
            title,
          ),
        ],
      ),
    );
  }
}
