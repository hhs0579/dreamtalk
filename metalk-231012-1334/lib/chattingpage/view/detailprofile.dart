import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/chattingpage/view/detailchatting.dart';
import 'package:flutter_metalk/chattingpage/view/detailgift.dart';
import 'package:flutter_metalk/components/container_widget.dart';
import 'package:flutter_metalk/components/image_padding.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/components/text_padding.dart';
import 'package:flutter_metalk/extentions/audio_state_ext.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/providers/base_provider.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:flutter_metalk/model/character_vo.dart';
import 'package:flutter_metalk/model/hobby_vo.dart';
import 'package:flutter_metalk/model/ideal_vo.dart';
import 'package:flutter_metalk/model/interest_vo.dart';
import 'package:flutter_metalk/model/language_vo.dart';

class DetailProfilePage extends StatefulWidget {
  final String userId;
  final bool isShowChat;

  const DetailProfilePage({super.key,
    required this.userId,
    this.isShowChat = true,
  });

  @override
  State<DetailProfilePage> createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  bool _isLoading = true;
  late UserVo _userVo;
  late UserVo _targetUserVo;

  AudioPlayer? _audioPlayer;
  AudioStateExt _audioStateExt = AudioStateExt.stop;
  Duration? _playDuration;
  late Duration _totalDuration;

  List<InterestVo> _interestVoList = [];
  List<LanguageVo> _languageVoList = [];
  List<IdealVo> _idealVoList = [];
  List<HobbyVo> _hobbyVoList = [];
  List<CharacterVo> _characterVoList = [];

  final GlobalKey<CarouselSliderState> _sliderKey = GlobalKey();
  int _current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  } //애니메이션

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _audioPlayer?.stop();
    super.dispose();
  }

  Future<void> _initData() async {
    UserVo? userVo = await UserApi.getUserIfNotToLogin();
    if (userVo == null) return;
    _userVo = userVo;

    userVo = await UserApi.getUserById(widget.userId,
      myUserVo: _userVo,
    );
    if (!mounted) return;
    if (userVo == null) {
      Fluttertoast.showToast(msg: '해당 사용자를 찾을 수 없습니다.');
      Navigator.pop(context);
      return;
    }
    _targetUserVo = userVo;

    _interestVoList = BaseProvider.getInterestVoList(context);
    _languageVoList = BaseProvider.getLanguageVoList(context);
    _idealVoList = BaseProvider.getIdealVoList(context);
    _hobbyVoList = BaseProvider.getHobbyVoList(context);
    _characterVoList = BaseProvider.getCharacterVoList(context);

    if (_targetUserVo.voiceMessageUrl != null) {
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
      await _audioPlayer!.setUrl(_targetUserVo.voiceMessageUrl!);
      _totalDuration = _audioPlayer!.duration!;
    }

    setState(() => _isLoading = false);
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
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: _isLoading ? const Loading() : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: ScreenUtil().setWidth(
                375,
              ),
              height: ScreenUtil().setHeight(
                300,
              ),
              child: Stack(
                children: [
                  //이미지페이지 애니메이션
                  CarouselSlider.builder(
                    key: _sliderKey,
                    itemCount: _targetUserVo.imageUrlList!.length,
                    itemBuilder:
                        (BuildContext context, int index, int pageViewIndex) {
                      return Stack(
                        children: [
                          Image.network(
                            _targetUserVo.imageUrlList![index],
                            fit: BoxFit.fill,
                            width: ScreenUtil().setWidth(
                              375,
                            ),
                            height: ScreenUtil().setHeight(
                              300,
                            ),
                          ),

                          if (index == 0)
                            Positioned(
                              top: ScreenUtil().setHeight(
                                200,
                              ),
                              left: ScreenUtil().setWidth(
                                110,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${_targetUserVo.userName}, ",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(
                                            24,
                                          ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${_targetUserVo.age}세",
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
                                      ImagePadding(_targetUserVo.userGender.icon, width: 24, height: 24,),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setWidth(
                                      6,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(
                                        10,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/image/mapgray.svg",
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(
                                            2,
                                          ),
                                        ),
                                        Text(
                                          _targetUserVo.distanceStr,
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(
                                              12,
                                            ),
                                            color: const Color.fromARGB(
                                              255,
                                              229,
                                              229,
                                              229,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(
                                            6,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          "assets/image/globe-light.svg",
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(
                                            2,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: ScreenUtil().setHeight(
                                              2,
                                            ),
                                          ),
                                          child: Text(
                                            '${_targetUserVo.firstLanguage(context)}',
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(
                                                12,
                                              ),
                                              color: const Color.fromARGB(
                                                255,
                                                229,
                                                229,
                                                229,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(
                                            6,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          "assets/image/smallcoin.svg",
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(
                                            2,
                                          ),
                                        ),
                                        Text(
                                          Utils.numberFormat(_targetUserVo.getRemainCoin()),
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              229,
                                              229,
                                              229,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          //뒤로가기아이콘
                          Positioned(
                            top: ScreenUtil().setHeight(
                              55,
                            ),
                            left: ScreenUtil().setWidth(
                              14,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(
                                "assets/image/profileback.svg",
                              ),
                            ),
                          ),
                          if (_userVo.id != _targetUserVo.id)...[
                            //프로필설정컨테이너
                            Positioned(
                              top: ScreenUtil().setHeight(
                                60,
                              ),
                              left: ScreenUtil().setWidth(
                                259,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => DetailGiftPage(
                                        targetUserId: _targetUserVo.id,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: ScreenUtil().setWidth(
                                    100,
                                  ),
                                  height: ScreenUtil().setHeight(
                                    34,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(
                                      0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: SvgPicture.asset(
                                          "assets/image/gift.svg",
                                        ),
                                      ),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(
                                          4,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: ScreenUtil().setHeight(
                                            10,
                                          ),
                                        ),
                                        child: const Text(
                                          '선물 보내기',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]
                        ],
                      );
                    },
                    options: CarouselOptions(
                      viewportFraction: 1.0, // 화면비율
                      enableInfiniteScroll: true,
                      enlargeCenterPage: false,
                      autoPlay: false,
                      scrollDirection: Axis.horizontal,
                      reverse: false,
                      height: MediaQuery.of(context).size.height / 2.50,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    top: ScreenUtil().setHeight(
                      265,
                    ),
                    left: ScreenUtil().setWidth(
                      175,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: map<Widget>(
                        _targetUserVo.imageUrlList!,
                        (index, url) {
                          return Container(
                            width: ScreenUtil().setWidth(
                              6,
                            ),
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
                                  ? const Color.fromARGB(255, 3, 201, 195)
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
            //첫번쨰 컨테이너박스
            Padding(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(
                  8,
                ),
                top: ScreenUtil().setHeight(
                  12,
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
                    left: ScreenUtil().setWidth(
                      20,
                    ),
                    bottom: ScreenUtil().setHeight(
                      12,
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
                          const Expanded(child: SizedBox()),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: HexColor('#FAFAFA'),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                width: 1,
                                color: HexColor('#E5E5E5'),
                              ),
                            ),
                            child: Row(
                              children: [
                                ImagePadding(_targetUserVo.levelExt.icon, width: 20, height: 20,),
                                const SizedBox(width: 4,),
                                TextPadding('LV. ${_targetUserVo.level}', fontWeight: FontWeight.w600, fontSize: 13, color: HexColor('#171717'),),
                                const SizedBox(width: 8,),
                                const ImagePadding('question.png', width: 16.5, height: 16.5,),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20,),
                        ],
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(
                          8,
                        ),
                      ),
                      Text(
                        _targetUserVo.description ?? '',
                        style: TextStyle(
                          color: const Color.fromARGB(
                            255,
                            64,
                            64,
                            64,
                          ),
                          fontWeight: FontWeight.w700,
                          fontSize: ScreenUtil().setSp(
                            14,
                          ),
                        ),
                      ),
                      if (_targetUserVo.voiceMessageUrl != null)...[
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            14,
                          ),
                        ),
                        Container(
                          height: ScreenUtil().setHeight(
                            60,
                          ),
                          width: ScreenUtil().setHeight(
                            335,
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
            //두번쨰 컨테이너박스
            Center(
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
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(
                          19,
                        ),
                        left: ScreenUtil().setWidth(
                          20,
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/image/smile.svg",
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(
                              4,
                            ),
                          ),
                          const Text(
                            '저는 이런 사람이에요',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (InterestVo item in _interestVoList.where((element) => (_targetUserVo.interestIdList ?? []).contains(element.id)))...[
                              ContainerWidget(
                                onTap: () => {},
                                isChecked: false,
                            
                                title: item.title,
                              ),
                            ],
                            for (LanguageVo item in _languageVoList.where((element) => (_targetUserVo.languageIdList ?? []).contains(element.id)))...[
                              ContainerWidget(
                                onTap: () => {},
                                isChecked: false,
                                image: item.iconUrl,
                                title: item.title,
                              ),
                            ],
                            for (HobbyVo item in _hobbyVoList.where((element) => (_targetUserVo.hobbyIdList ?? []).contains(element.id)))...[
                              ContainerWidget(
                                onTap: () => {},
                                isChecked: false,
                                title: item.title,
                              ),
                            ],
                            for (CharacterVo item in _characterVoList.where((element) => (_targetUserVo.characterIdList ?? []).contains(element.id)))...[
                              ContainerWidget(
                                onTap: () => {},
                                isChecked: false,
                                title: item.title,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: ScreenUtil().setHeight(
                8,
              ),
            ),
            Center(
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
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/image/love.svg",
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(
                            4,
                          ),
                        ),
                        Text(
                          '이런 사람을 찾고 있어요',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(
                              16,
                            ),
                          ),
                        ),
                      ],
                    ),),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        12,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (IdealVo item in _idealVoList.where((element) => (_targetUserVo.idealIdList ?? []).contains(element.id)))...[
                              ContainerWidget(
                                onTap: () => {},
                                isChecked: false,
                                title: item.title,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(
                38,
              ),
            ),
            if (_userVo.id != _targetUserVo.id && widget.isShowChat)...[
              Container(
                color: Colors.white,
                width: ScreenUtil().setWidth(
                  375,
                ),
                height: ScreenUtil().setHeight(
                  106,
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => DatailChattingPage(
                            targetUserId: _targetUserVo.id,
                          ),
                        ),
                      );
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
                          '채팅하기',
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
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getCurrentDuration() {
    Duration? playDuration = _playDuration;
    int second = 0;

    if (playDuration != null && _audioStateExt == AudioStateExt.play) {
      second = playDuration.inSeconds;
    }

    return '0:${second.toString().padLeft(2, '0')} ';
  }
}

//컨테이너 박스 ( )
class PersonContainer extends StatelessWidget {
  final String title;
  final String? image;
  final double width;
  final double height;

  const PersonContainer({
    super.key,
    required this.title,
    this.image,
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
      child: Padding(
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(
            11.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null
                ? Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(2.5),
                    ),
                    child: Image.asset(
                      image!,
                      width: 16,
                      height: 16,
                      fit: BoxFit.contain,
                    ),
                  )
                : const Text(''),
            SizedBox(
              width: ScreenUtil().setWidth(
                3,
              ),
            ),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                    // fontSize: ScreenUtil().setSp(
                    //   14,
                    // ),
                    color: Color.fromARGB(
                      255,
                      23,
                      23,
                      23,
                    ),
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
