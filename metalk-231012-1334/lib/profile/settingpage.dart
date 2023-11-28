import 'dart:async';
import 'dart:io';

import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:flutter_metalk/apis/firabase_storage_api.dart';
import 'package:flutter_metalk/components/custom_border.dart';
import 'package:flutter_metalk/components/custom_border.dart';
import 'package:flutter_metalk/components/image_padding.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/auth/phoneprofilethree.dart';
import 'package:flutter_metalk/components/container_widget.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/extentions/audio_state_ext.dart';
import 'package:flutter_metalk/extentions/gender_ext.dart';
import 'package:flutter_metalk/model/image_change_vo.dart';
import 'package:flutter_metalk/model/profile_create.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/profile/womanprofile/coinsettingpage.dart';
import 'package:flutter_metalk/providers/base_provider.dart';
import 'package:flutter_metalk/utils/custom_styles.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_metalk/model/character_vo.dart';
import 'package:flutter_metalk/model/hobby_vo.dart';
import 'package:flutter_metalk/model/ideal_vo.dart';
import 'package:flutter_metalk/model/interest_vo.dart';
import 'package:flutter_metalk/model/job_vo.dart';
import 'package:flutter_metalk/model/language_vo.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class ProfileSettingPage extends StatefulWidget {
  const ProfileSettingPage({super.key});

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  bool _isLoading = true;
  late UserVo _userVo;
  bool _isProcessingSubmit = false;

  // step 1
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // step 2
  List<InterestVo> _interestVoList = [];
  List<LanguageVo> _languageVoList = [];
  List<IdealVo> _idealVoList = [];
  List<JobVo> _jobVoList = [];
  List<HobbyVo> _hobbyVoList = [];
  List<CharacterVo> _characterVoList = [];

  // step 3
  final List<ImageChangeVo> _images = List.generate(5, (index) => ImageChangeVo());
  final TextEditingController _descriptionController = TextEditingController();
  bool _isProcessingRecording = false;
  AnotherAudioRecorder? _recorder;
  Timer? _recorderTimer;
  AudioStateExt _audioStateExt = AudioStateExt.ready;
  late String _recordeFilePath;
  File? _recordeFile;
  AudioPlayer? _audioPlayer;
  int _recordeSecond = 0;
  Duration? _playDuration;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    UserVo? userVo = await UserApi.getUserIfNotToLogin();
    if (userVo == null) return;
    _userVo = userVo;

    List<String>? imageUrlList = _userVo.imageUrlList;
    if (imageUrlList != null) {
      for (int index = 0; index < _images.length; index++) {
        _images[index].originImgUrl = imageUrlList.length > index ? imageUrlList[index] : null;
      }
    }

    _nameController.text = _userVo.userName ?? '';
    _idController.text = _userVo.userId ?? '';
    _emailController.text = _userVo.userEmail ?? '';
    if (_userVo.userGender == GenderExt.male) {
      _manbox = true;
    } else {
      _womanbox = true;
    }
    _birthController.text = _userVo.birth ?? '';
    _locationController.text = _userVo.location ?? '';

    _interestVoList = BaseProvider.getInterestVoList(context).map((e) {
      e.isChecked = (_userVo.interestIdList ?? []).contains(e.id);
      return e;
    }).toList();
    _languageVoList = BaseProvider.getLanguageVoList(context).map((e) {
      e.isChecked = (_userVo.languageIdList ?? []).contains(e.id);
      return e;
    }).toList();
    _idealVoList = BaseProvider.getIdealVoList(context).map((e) {
      e.isChecked = (_userVo.idealIdList ?? []).contains(e.id);
      return e;
    }).toList();
    _jobVoList = BaseProvider.getJobVoList(context).map((e) {
      e.isChecked = (_userVo.jobIdList ?? []).contains(e.id);
      return e;
    }).toList();
    _hobbyVoList = BaseProvider.getHobbyVoList(context).map((e) {
      e.isChecked = (_userVo.hobbyIdList ?? []).contains(e.id);
      return e;
    }).toList();
    _characterVoList = BaseProvider.getCharacterVoList(context).map((e) {
      e.isChecked = (_userVo.characterIdList ?? []).contains(e.id);
      return e;
    }).toList();

    _recordeFilePath = '${(await getApplicationDocumentsDirectory()).path}/audio_message.m4a';
    _descriptionController.text = _userVo.description ?? '';

    setState(() => _isLoading = false);
  }

  String _getCurrentDuration() {
    Duration? playDuration = _playDuration;
    int second = _recordeSecond;

    if (playDuration != null && _audioStateExt == AudioStateExt.play) {
      second = playDuration.inSeconds;
    }

    return '0:${second.toString().padLeft(2, '0')} ';
  }

  Future<void> _stopPlayRecordeFile() async {
    debugPrint('_stopPlayRecordeFile()');
    await _audioPlayer?.stop();
    setState(() => _audioStateExt = AudioStateExt.stop);
  }

  Future<bool> _isAbleRecordingPermissions() async {
    bool hasPermission = await AnotherAudioRecorder.hasPermissions;
    if (hasPermission == false) {
      Fluttertoast.showToast(msg: '마이크 권한이 없으면 음성 메세지를 등록할 수 없습니다.');
      return false;
    }
    return true;
  }

  Future<void> _startRecording() async {
    Utils.hideKeyboard();
    FocusNode().unfocus();

    if (_isProcessingRecording) {
      Fluttertoast.showToast(msg: '이미 이전 요청을 처리 중입니다.\n잠시 후 다시 시도해주세요.');
      return;
    }
    _isProcessingRecording = true;

    if (await _isAbleRecordingPermissions()) {
      try {
        _recorderTimer?.cancel();
        File file = File(_recordeFilePath);
        bool isExist = file.existsSync();
        debugPrint('path: $_recordeFilePath, isExist: $isExist');
        if (isExist) {
          debugPrint('delete file path: $_recordeFilePath');
          file.deleteSync();
        }
        _recorder = AnotherAudioRecorder(_recordeFilePath, audioFormat: AudioFormat.AAC);
        await _recorder?.initialized;
        await _recorder!.start();
        _refreshRecordingDuration();
        _recorderTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) => _refreshRecordingDuration());
        setState(() => _audioStateExt = AudioStateExt.recording);
      } catch (e) {
        debugPrint(e.toString());
        Fluttertoast.showToast(msg: '음성 메세지 초기화 중 오류가 발생하였습니다.\n잠시 후 다시 시도해주세요.');
      }
    }

    _isProcessingRecording = false;
  }

  Future<void> _refreshRecordingDuration() async {
    Duration? recordingDuration = (await _recorder?.current())?.duration;
    if (recordingDuration != null) {
      int seconds = recordingDuration.inSeconds;

      if (seconds >= 10) {
        _stopRecording();
      }
      setState(() => _recordeSecond = seconds);
    }
  }

  Future<void> _stopRecording() async {
    if (_isProcessingRecording) {
      Fluttertoast.showToast(msg: '이미 이전 요청을 처리 중입니다.\n잠시 후 다시 시도해주세요.');
      return;
    }
    _isProcessingRecording = true;

    _recorderTimer?.cancel();
    Recording? recording = await _recorder?.stop();
    int? seconds = recording?.duration?.inSeconds;
    if (seconds != null && seconds < 5) {
      Fluttertoast.showToast(msg: '음성 메세지는 최소 5초 이상 등록 가능합니다.');
      _recordeSecond = 0;
      _recordeFile = null;
      setState(() => _audioStateExt = AudioStateExt.ready);
    } else {
      String? path = recording?.path;
      debugPrint('saved path: $path');
      if (path != null) {
        _recordeFile = File(path);
      } else {
        Fluttertoast.showToast(msg: '음성 메세지 저장에 실패하였습니다.\n잠시 후 다시 시도해주세요.');
      }
      setState(() => _audioStateExt = AudioStateExt.stop);
    }
    _isProcessingRecording = false;
  }

  @override
  void dispose() {
    _recorderTimer?.cancel();
    _recorder?.stop();
    _audioPlayer?.stop();
    super.dispose();
  }

  Future<void> _onPressedUploadImage(int index) async {
    XFile? xFile = await Utils.pickImageFromGallery();

    if (xFile != null) {
      setState(() {
        _images[index].changeFile = File(xFile.path);
      });
    } else {
      Fluttertoast.showToast(msg: '해당 파일을 불러오는 중 오류가 발생하였습니다.');
    }
  }

  Future<void> _onSubmit() async {
    FocusNode().unfocus();
    Utils.hideKeyboard();

    // step 1
    String name = _nameController.text;
    if (Utils.isValidate(name: '이름', value: name) == false) return;
    String id = _idController.text;
    if (Utils.isValidate(name: '아이디', value: id) == false) return;
    String email = _emailController.text;
    if (Utils.isValidate(name: '이메일', value: email, isCheckEmail: true) == false) return;
    String? gender = _manbox ? 'male' : _womanbox ? 'female' : null;
    if (gender == null) {
      Fluttertoast.showToast(msg: '성별을 선택해주세요.');
      return;
    }
    String birth = _birthController.text;
    if (Utils.isValidate(name: '생년월일', value: birth, isCheckNum: true, length: 8) == false) return;
    birth = Utils.getExistDateByProfileBirth(birth);
    String location = _locationController.text;
    if (Utils.isValidate(name: '위치', value: location) == false) return;
    ProfileCreate profileCreate = ProfileCreate(
      name: name,
      id: id,
      email: email,
      gender: gender,
      birth: birth,
      location: location,
    );

    // step 2
    List<InterestVo> interestVoList = _interestVoList.where((element) => element.isChecked).toList();
    List<LanguageVo> languageVoList = _languageVoList.where((element) => element.isChecked).toList();
    List<IdealVo> idealVoList = _idealVoList.where((element) => element.isChecked).toList();
    List<JobVo> jobVoList = _jobVoList.where((element) => element.isChecked).toList();
    List<HobbyVo> hobbyVoList = _hobbyVoList.where((element) => element.isChecked).toList();
    List<CharacterVo> characterVoList = _characterVoList.where((element) => element.isChecked).toList();
    if (interestVoList.isEmpty) {
      Fluttertoast.showToast(msg: '관심사를 최소 1개 이상 선택해주세요.');
      return;
    }
    if (languageVoList.isEmpty) {
      Fluttertoast.showToast(msg: '언어를 최소 1개 이상 선택해주세요.');
      return;
    }
    if (idealVoList.isEmpty) {
      Fluttertoast.showToast(msg: '이상형을 최소 1개 이상 선택해주세요.');
      return;
    }
    if (jobVoList.isEmpty) {
      Fluttertoast.showToast(msg: '직업을 최소 1개 이상 선택해주세요.');
      return;
    }
    if (hobbyVoList.isEmpty) {
      Fluttertoast.showToast(msg: '취미를 최소 1개 이상 선택해주세요.');
      return;
    }
    if (characterVoList.isEmpty) {
      Fluttertoast.showToast(msg: '성격을 최소 1개 이상 선택해주세요.');
      return;
    }
    profileCreate.interestVoList = interestVoList;
    profileCreate.languageVoList = languageVoList;
    profileCreate.idealVoList = idealVoList;
    profileCreate.jobVoList = jobVoList;
    profileCreate.hobbyVoList = hobbyVoList;
    profileCreate.characterVoList = characterVoList;

    List<ImageChangeVo> images = _images.where((element) => element.changeFile != null || element.originImgUrl != null).toList();
    String description = _descriptionController.text;
    if (images.isEmpty) {
      Fluttertoast.showToast(msg: '메인사진은 반드시 올려주세요.');
      return;
    } else if (description.isEmpty) {
      Fluttertoast.showToast(msg: '당신에 대한 설명은 최소 1자 이상 써주세요.');
      return;
    } else if (_isProcessingSubmit) {
      Fluttertoast.showToast(msg: '이미 이전 요청을 처리 중입니다.\n잠시 후 다시 시도해주세요.');
      return;
    }

    setState(() => _isProcessingSubmit = true);
    List<String> imageUrlList = [];
    for (ImageChangeVo image in images) {
      if (image.changeFile != null) {
        String? downloadURL = await FirebaseStorageApi.uploadFile(File(image.changeFile!.path), FirebaseStorageApi.uploadPathProfile);
        if (downloadURL == null) {
          setState(() => _isProcessingSubmit = false);
          Fluttertoast.showToast(msg: '이미지 업로드 중 오류가 발생하였습니다.\n다른 이미지 파일을 사용하시거나 잠시 후 다시 시도해주세요.');
          return;
        }
        imageUrlList.add(downloadURL);
      } else if (image.originImgUrl != null) {
        imageUrlList.add(image.originImgUrl!);
      }
    }

    String? voiceMessageUrl;
    if (_recordeFile != null) {
      String? downloadURL = await FirebaseStorageApi.uploadFile(File(_recordeFile!.path), FirebaseStorageApi.uploadPathProfile);
      if (downloadURL == null) {
        setState(() => _isProcessingSubmit = false);
        Fluttertoast.showToast(msg: '오디오 업로드 중 오류가 발생하였습니다.\n다른 오디오 파일을 사용하시거나 잠시 후 다시 시도해주세요.');
        return;
      }
      voiceMessageUrl = downloadURL;
    }

    profileCreate.imageUrlList = imageUrlList;
    profileCreate.description = description;
    profileCreate.voiceMessageUrl = voiceMessageUrl ?? _userVo.voiceMessageUrl;

    UserVo? userVo = await UserApi.updateUserCreateProfile(user: _userVo, profileCreate: profileCreate);
    if (userVo != null) {
      Fluttertoast.showToast(msg: '저장되었습니다.');
      Future.delayed(Duration.zero, () => Navigator.pop(context, true));
    } else {
      Fluttertoast.showToast(msg: '정보 업데이트 중 오류가 발생하였습니다.');
    }
  }

  Future<void> _playRecordeFile() async {
    File? recordeFile = _recordeFile;
    if (recordeFile == null || recordeFile.existsSync() == false) {
      Fluttertoast.showToast(msg: '저장된 음성 메세지 파일을 찾을 수 없습니다.\n재녹음 후 다시 시도해주세요.');
      return;
    }
    try {
      if (_audioPlayer == null) {
        _audioPlayer = AudioPlayer();
        _audioPlayer!.playerStateStream.listen((event) {
          if (event.playing && event.processingState == ProcessingState.completed) {
            debugPrint('complete audio');
            setState(() => _audioStateExt = AudioStateExt.stop);
          }
        });
        _audioPlayer!.positionStream.listen((event) {
          setState(() => _playDuration = event);
        });
      }
      await _audioPlayer!.setFilePath(recordeFile.path);
      _audioPlayer!.play();
      setState(() => _audioStateExt = AudioStateExt.play);
    } catch (e) {
      Logger().e(e);
      debugPrint(e.toString());
      Fluttertoast.showToast(msg: '오디오 플레이어 재생 실패하였습니다..\n잠시 후 다시 시도해주세요.');
    }
  }

  bool _isAbleMoreCheck({
    required int maxLength,
    required List list,
  }) {
    bool result = list.where((element) => element.isChecked).length < maxLength;
    if (result == false) Fluttertoast.showToast(msg: '$maxLength개 이상 선택할 수 없습니다.');
    return result;
  }

  bool _manbox = false;
  bool _womanbox = false;

  String _man = '남';
  String _woman = '여';
  //남자박스
  void genderWoman() {
    // gender = _woman;
    if (!_manbox) {
      _womanbox = !_womanbox;
    }
    if (_manbox) {
      _manbox = !_manbox;
    }
    if (!_womanbox) {
      _womanbox = !_womanbox;
    }
  }

  //여자박스
  void genderman() {
    // gender = _man;
    if (!_womanbox) {
      _manbox = !_manbox;
    }
    if (_womanbox) {
      _womanbox = !_womanbox;
    }
    if (!_manbox) {
      _manbox = !_manbox;
    }
  }

  Color color = Colors.teal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '내 프로필',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SvgPicture.asset(
            "assets/image/Ic_toucharea.svg",
          ),
        ),
        actions: [
          if (_isLoading == false && _userVo.userGender == GenderExt.female)...[
            Padding(
              padding: EdgeInsets.only(
                right: ScreenUtil().setWidth(
                  16,
                ),
              ),
              child: Row(
                children: [
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
                        88,
                      ),
                      height: ScreenUtil().setHeight(
                        34,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                          255,
                          3,
                          201,
                          195,
                        ),
                        borderRadius: BorderRadius.circular(
                          100,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/image/settingcoin.svg",
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(
                              4,
                            ),
                          ),
                          const Text(
                            '코인 설정',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: _isLoading ? const Loading() : Stack(
          children: [
            Positioned.fill(child:             Column(
              children: [
                Expanded(child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(8),
                      left: ScreenUtil().setWidth(
                        20,
                      ),
                      right: ScreenUtil().setWidth(
                        20,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (int index = 0; index < _images.length; index++)...[
                                Row(
                                  children: [
                                    if (index > 0)...[
                                      SizedBox(width: ScreenUtil().setWidth(8,),),
                                    ],
                                    Container(
                                      height: ScreenUtil().setHeight(134,),
                                      width: ScreenUtil().setWidth(100,),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: index == 0 ? const Color.fromARGB(255, 243, 252, 252,) : const Color.fromARGB(255, 245, 245, 245,),
                                        border: index == 0 ? Border.all(
                                          color: const Color.fromARGB(255, 3, 201, 195,),
                                        ) : null,
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: TextButton(
                                        onPressed: () => _onPressedUploadImage(index),
                                        style: CustomStyles.textButtonZeroSize(),
                                        child: Stack(
                                          children: [
                                            if (_images[index].changeFile != null)...[
                                              Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: FileImage(_images[index].changeFile!),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ]else if (_images[index].originImgUrl != null)...[
                                              Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(_images[index].originImgUrl!),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ]else...[
                                              Center(
                                                child: Icon(
                                                  Icons.camera_alt_rounded,
                                                  color: index == 0 ? const Color.fromARGB(255, 177, 238, 236,) : const Color.fromARGB(255, 212, 212, 212,),
                                                ),
                                              ),
                                            ],
                                            if (index == 0)...[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: ScreenUtil().setWidth(22,),
                                                ),
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                      bottomLeft: Radius.circular(5),
                                                      bottomRight: Radius.circular(5),
                                                    ),
                                                    color: Color.fromARGB(255, 3, 201, 195,),
                                                  ),
                                                  width: ScreenUtil().setWidth(58,),
                                                  height: ScreenUtil().setHeight(20,),
                                                  child: Center(
                                                    child: Text(
                                                      '메인사진',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: ScreenUtil().setSp(
                                                          12,
                                                        ),
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            14,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ..._widgetStep1(),
                              const CustomBorder(),
                              ..._widgetStep2(),
                              const CustomBorder(),
                              ..._widgetStep3(),
                              SizedBox(
                                height: ScreenUtil().setHeight(
                                  40,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: GestureDetector(
                      onTap: () => _onSubmit(),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                          color: const Color.fromARGB(
                            255,
                            3,
                            201,
                            195,
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
                            '저장하기',
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
            )),
            if (_isProcessingSubmit)...[
              Positioned.fill(child: Container(
                color: Colors.black.withOpacity(.3),
                child: const Center(
                  child: Loading(
                    color: Colors.white,
                  ),
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _widgetStep2() {
    return [
      Text(
        '관심사',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(
            16,
          ),
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          2,
        ),
      ),
      const Text(
        '5개까지 선택할 수 있어요.',
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          12,
        ),
      ),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (InterestVo item in _interestVoList)...[
            ContainerWidget(
              onTap: () {if (item.isChecked == true || _isAbleMoreCheck(maxLength: 5, list: _interestVoList)) setState(() => item.isChecked = !item.isChecked);},
              isChecked: item.isChecked,
              image: item.iconUrl,
              title: item.title,
            ),
          ],
        ],
      ),

      SizedBox(
        height: ScreenUtil().setHeight(
          24,
        ),
      ),
      Text(
        '언어',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(
            16,
          ),
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(2),
      ),
      Text(
        '5개까지 선택할 수 있어요.',
        style: TextStyle(
          fontSize: ScreenUtil().setSp(
            14,
          ),
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          12,
        ),
      ),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (LanguageVo item in _languageVoList)...[
            ContainerWidget(
              onTap: () {if (item.isChecked == true || _isAbleMoreCheck(maxLength: 5, list: _languageVoList)) setState(() => item.isChecked = !item.isChecked);},
              isChecked: item.isChecked,
              image: item.iconUrl,
              title: item.title,
            ),
          ],
        ],
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          24,
        ),
      ),
      Text(
        '이상형',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(
            16,
          ),
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          2,
        ),
      ),
      Text(
        '5개까지 선택할 수 있어요.',
        style: TextStyle(
            fontSize: ScreenUtil().setSp(
              14,
            ),
            fontWeight: FontWeight.w500),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          12,
        ),
      ),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (IdealVo item in _idealVoList)...[
            ContainerWidget(
              onTap: () {if (item.isChecked == true || _isAbleMoreCheck(maxLength: 5, list: _idealVoList)) setState(() => item.isChecked = !item.isChecked);},
              isChecked: item.isChecked,
              title: item.title,
            ),
          ],
        ],
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          24,
        ),
      ),
      Text(
        '직업',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(
            16,
          ),
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          2,
        ),
      ),
      Text(
        '1개까지 선택할 수 있어요 (중복선택 불가능)',
        style: TextStyle(
          fontSize: ScreenUtil().setSp(
            14,
          ),
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          12,
        ),
      ),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (JobVo item in _jobVoList)...[
            ContainerWidget(
              onTap: () {if (item.isChecked == true || _isAbleMoreCheck(maxLength: 1, list: _jobVoList)) setState(() => item.isChecked = !item.isChecked);},
              isChecked: item.isChecked,
              title: item.title,
            ),
          ],
        ],
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          24,
        ),
      ),
      Text(
        '취미',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(
            16,
          ),
        ),
      ),
      const SizedBox(
        height: 5,
      ),
      Text(
        '5개까지 선택할 수 있어요.',
        style: TextStyle(
          fontSize: ScreenUtil().setSp(
            14,
          ),
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          12,
        ),
      ),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (HobbyVo item in _hobbyVoList)...[
            ContainerWidget(
              onTap: () {if (item.isChecked == true || _isAbleMoreCheck(maxLength: 5, list: _hobbyVoList)) setState(() => item.isChecked = !item.isChecked);},
              isChecked: item.isChecked,
              title: item.title,
            ),
          ],
        ],
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          24,
        ),
      ),
      Text(
        '성격',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(
            16,
          ),
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          2,
        ),
      ),
      Text(
        '3개까지 선택할 수 있어요.',
        style: TextStyle(
          fontSize: ScreenUtil().setSp(
            14,
          ),
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          12,
        ),
      ),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (CharacterVo item in _characterVoList)...[
            ContainerWidget(
              onTap: () {if (item.isChecked == true || _isAbleMoreCheck(maxLength: 3, list: _characterVoList)) setState(() => item.isChecked = !item.isChecked);},
              isChecked: item.isChecked,
              title: item.title,
            ),
          ],
        ],
      ),
    ];
  }

  List<Widget> _widgetStep1() {
    return [
      Text(
        '이름',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(
            14,
          ),
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          8,
        ),
      ),
      SizedBox(
        width: ScreenUtil().setWidth(
          335,
        ),
        height: ScreenUtil().setHeight(
          48,
        ),
        child: TextFormField(
          onChanged: (value) => setState(() => {}),
          textInputAction: TextInputAction.next,
          controller: _nameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(
              255,
              250,
              250,
              250,
            ),
            //누를떄 컨테이너 모양
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              borderSide: BorderSide(
                color: Color.fromARGB(
                  255,
                  229,
                  229,
                  229,
                ),
              ),
            ),
            //누르기 전 컨테이너 모양
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              borderSide: BorderSide(
                color: Color.fromARGB(
                  255,
                  229,
                  229,
                  229,
                ),
              ),
            ),
            hintText: '홍길동',
            hintStyle: TextStyle(
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
        ),
      ),
      SizedBox(
          height: ScreenUtil().setHeight(
            20,
          )),
      Text(
        '아이디',
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
      SizedBox(
        width: ScreenUtil().setWidth(
          335,
        ),
        height: ScreenUtil().setHeight(
          48,
        ),
        child: TextFormField(
          textInputAction: TextInputAction.next,
          controller: _idController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(
              255,
              250,
              250,
              250,
            ),
            //누를떄 컨테이너 모양
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              borderSide: BorderSide(
                color: Color.fromARGB(
                  255,
                  229,
                  229,
                  229,
                ),
              ),
            ),
            //누르기 전 컨테이너 모양
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              borderSide: BorderSide(
                color: Color.fromARGB(
                  255,
                  229,
                  229,
                  229,
                ),
              ),
            ),
            hintText: '아이디 입력',
            hintStyle: TextStyle(
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
          onChanged: ((value) {
            setState(
                  () {
                // userId = value;
              },
            );
          }),
        ),
      ),
      SizedBox(
          height: ScreenUtil().setHeight(
            20,
          )),
      Text(
        '이메일',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ScreenUtil().setSp(
            14,
          ),
        ),
      ),

      SizedBox(
        height: ScreenUtil().setHeight(
          8,
        ),
      ),
      SizedBox(
        width: ScreenUtil().setWidth(
          335,
        ),
        height: ScreenUtil().setHeight(
          48,
        ),
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(
              255,
              250,
              250,
              250,
            ),
            //누를떄 컨테이너 모양
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              borderSide: BorderSide(
                color: Color.fromARGB(
                  255,
                  229,
                  229,
                  229,
                ),
              ),
            ),
            //누르기 전 컨테이너 모양
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              borderSide: BorderSide(
                color: Color.fromARGB(
                  255,
                  229,
                  229,
                  229,
                ),
              ),
            ),
            hintText: 'abc@gmail.com',
            hintStyle: TextStyle(
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
          onChanged: ((value) {
            setState(
                  () {
                // userId = value;
              },
            );
          }),
        ),
      ),
      SizedBox(
          height: ScreenUtil().setHeight(
            20,
          )),
      // const Padding(
      //   padding: EdgeInsets.only(),
      //   child: Text(
      //     "성별",
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontWeight: FontWeight.w700,
      //     ),
      //   ),
      // ),
      // SizedBox(
      //     height: ScreenUtil().setHeight(
      //       8,
      //     )),
      // Row(
      //   // crossAxisAlignment: CrossAxisAlignment.center,
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     GestureDetector(
      //       onTap: () {
      //         setState(() {
      //           _manbox = !_manbox;
      //           genderman();
      //           print(_manbox);
      //         });
      //       },
      //       child: Container(
      //         height: ScreenUtil().setHeight(
      //           48,
      //         ),
      //         width: ScreenUtil().setWidth(
      //           162,
      //         ),
      //         decoration: BoxDecoration(
      //           border: _manbox
      //               ? Border.all(
      //             color: const Color.fromARGB(
      //               255,
      //               3,
      //               201,
      //               195,
      //             ),
      //           )
      //               : Border.all(
      //             color: const Color.fromARGB(
      //               255,
      //               229,
      //               229,
      //               229,
      //             ),
      //           ),
      //           borderRadius: BorderRadius.circular(8),
      //           color: _manbox
      //               ? const Color.fromARGB(
      //             255,
      //             230,
      //             250,
      //             249,
      //           )
      //               : null,
      //         ),
      //         child: Center(
      //           child: Text(
      //             _man,
      //             style: TextStyle(
      //               color: const Color.fromARGB(
      //                 255,
      //                 82,
      //                 82,
      //                 82,
      //               ),
      //               fontSize: ScreenUtil().setSp(
      //                 14,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //     SizedBox(
      //       width: ScreenUtil().setWidth(
      //         11,
      //       ),
      //     ),
      //     GestureDetector(
      //       onTap: () {
      //         setState(() {
      //           _womanbox = !_womanbox;
      //           genderWoman();
      //           print(_womanbox);
      //         });
      //       },
      //       child: Container(
      //         height: ScreenUtil().setHeight(
      //           48,
      //         ),
      //         width: ScreenUtil().setWidth(
      //           162,
      //         ),
      //         child: Center(
      //           child: Text(
      //             _woman,
      //             style: TextStyle(
      //               color: const Color.fromARGB(
      //                 255,
      //                 82,
      //                 82,
      //                 82,
      //               ),
      //               fontSize: ScreenUtil().setSp(
      //                 14,
      //               ),
      //             ),
      //           ),
      //         ),
      //         decoration: BoxDecoration(
      //           border: _womanbox
      //               ? Border.all(
      //             color: const Color.fromARGB(
      //               255,
      //               3,
      //               201,
      //               195,
      //             ),
      //           )
      //               : Border.all(
      //             color: const Color.fromARGB(
      //               255,
      //               229,
      //               229,
      //               229,
      //             ),
      //           ),
      //           borderRadius: BorderRadius.circular(8),
      //           color: _womanbox
      //               ? const Color.fromARGB(
      //             255,
      //             230,
      //             250,
      //             249,
      //           )
      //               : null,
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      // SizedBox(
      //   height: ScreenUtil().setHeight(
      //     20,
      //   ),
      // ),
      const Text(
        '생년월일',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(
            255,
            23,
            23,
            23,
          ),
        ),
      ),

      //이메일주소
      SizedBox(
        height: ScreenUtil().setHeight(
          8,
        ),
      ),
      SizedBox(
        width: ScreenUtil().setWidth(
          335,
        ),
        height: ScreenUtil().setHeight(
          48,
        ),
        child: TextFormField(
          controller: _birthController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(
              255,
              250,
              250,
              250,
            ),
            //누를떄 컨테이너 모양
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              borderSide: BorderSide(
                color: Color.fromARGB(
                  255,
                  229,
                  229,
                  229,
                ),
              ),
            ),
            //누르기 전 컨테이너 모양
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              borderSide: BorderSide(
                color: Color.fromARGB(
                  255,
                  229,
                  229,
                  229,
                ),
              ),
            ),
            hintText: '19921192',
            hintStyle: TextStyle(
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
          onChanged: ((value) {
            setState(
                  () {
                // userId = value;
              },
            );
          }),
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          20,
        ),
      ),
      const Text(
        '위치',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(
            255,
            23,
            23,
            23,
          ),
        ),
      ),

      //이메일주소
      SizedBox(
        height: ScreenUtil().setHeight(
          8,
        ),
      ),
      SizedBox(
        width: ScreenUtil().setWidth(
          335,
        ),
        height: ScreenUtil().setHeight(
          48,
        ),
        child: TextFormField(
          controller: _locationController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(
              255,
              250,
              250,
              250,
            ),
            //누를떄 컨테이너 모양
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              borderSide: BorderSide(
                color: Color.fromARGB(
                  255,
                  229,
                  229,
                  229,
                ),
              ),
            ),
            //누르기 전 컨테이너 모양
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              borderSide: BorderSide(
                color: Color.fromARGB(
                  255,
                  229,
                  229,
                  229,
                ),
              ),
            ),
            hintText: '서울시 강남구',
            hintStyle: TextStyle(
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
          onChanged: ((value) {
            setState(
                  () {
                // userId = value;
              },
            );
          }),
        ),
      ),
    ];
  }

  List<Widget> _widgetStep3() {
    return [
      Text(
        '설명',
        style: TextStyle(
          color: Colors.black,
          fontSize: ScreenUtil().setSp(
            16,
          ),
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          8,
        ),
      ),
      SizedBox(
        width: ScreenUtil().setWidth(
          335,
        ),
        height: ScreenUtil().setHeight(
          128,
        ),
        child: TextFormField(
          maxLength: 500,
          controller: _descriptionController,
          maxLines: 7,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            //누를떄 컨테이너 모양
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: Color.fromARGB(
                  255,
                  238,
                  238,
                  238,
                ),
              ),
            ),
            //누르기 전 컨테이너 모양
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: Color.fromARGB(
                  255,
                  238,
                  238,
                  238,
                ),
              ),
            ),
            filled: true,
            fillColor: Color.fromARGB(
              255,
              250,
              250,
              250,
            ),
            hintText: '당신에 대해 500자 이내로 설명해주세요.',
            // helperText: "이메일형식@gmail.com",
            hintStyle: TextStyle(
              fontSize: 13.0,
            ),
          ),
          onChanged: (value) => setState(() => {}),
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          48,
        ),
      ),
      Text(
        '음성 메세지(선택)',
        style: TextStyle(
          color: Colors.black,
          fontSize: ScreenUtil().setSp(
            16,
          ),
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          2,
        ),
      ),
      Text(
        '음성 메세지를 수정하려면 새로 등록해주세요.\n최소 5초, 최대 10초까지 등록할 수 있어요.',
        style: TextStyle(
          color: const Color.fromARGB(
            255,
            82,
            82,
            82,
          ),
          fontSize: ScreenUtil().setSp(
            14,
          ),
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(
        height: ScreenUtil().setHeight(
          14,
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(
            255,
            245,
            245,
            245,
          ),
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        height: ScreenUtil().setHeight(
          116,
        ),
        width: ScreenUtil().setHeight(
          335,
        ),
        child: Stack(
          children: [
            Container(
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
              height: ScreenUtil().setHeight(
                60,
              ),
              width: ScreenUtil().setHeight(
                335,
              ),
            ),
            Positioned(
              left: ScreenUtil().setWidth(
                20,
              ),
              top: ScreenUtil().setHeight(
                10,
              ),
              child: GestureDetector(
                onTap: () {
                  if (_audioStateExt == AudioStateExt.ready) {
                    _startRecording();
                  } else if (_audioStateExt == AudioStateExt.play) {
                    _stopPlayRecordeFile();
                  } else if (_audioStateExt == AudioStateExt.stop) {
                    _playRecordeFile();
                  } else if (_audioStateExt == AudioStateExt.recording) {
                    _stopRecording();
                  }
                },
                child: ImagePadding(
                  _audioStateExt.profileIcon,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            Positioned(
              left: ScreenUtil().setWidth(
                70,
              ),
              top: ScreenUtil().setHeight(
                14,
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
                    '/ 0:10',
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
            Positioned(
              top: ScreenUtil().setHeight(72),
              left: ScreenUtil().setWidth(
                86,
              ),
              child: GestureDetector(
                onTap: () async {
                  if (_recordeFile != null) {
                    await _stopPlayRecordeFile();
                    _recordeFile = null;
                    setState(() {
                      _recordeSecond = 0;
                      _audioStateExt = AudioStateExt.ready;
                    });
                    _startRecording();
                  } else {
                    Fluttertoast.showToast(msg: '저장된 파일이 없습니다.');
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _recordeFile != null ? const Color(0xffE5E5E5) : const Color.fromARGB(
                        225,
                        229,
                        229,
                        229,
                      ),
                    ),
                    color: const Color.fromARGB(
                      255,
                      255,
                      255,
                      255,
                    ),
                    borderRadius: BorderRadius.circular(
                      100,
                    ),
                  ),
                  height: ScreenUtil().setHeight(
                    32,
                  ),
                  width: ScreenUtil().setHeight(
                    90,
                  ),
                  child: Center(
                    child: Text(
                      '다시 녹음하기',
                      style: TextStyle(
                        color: _recordeFile != null ? const Color(0xff404040) : const Color.fromARGB(
                          255,
                          212,
                          212,
                          212,
                        ),
                        fontSize: ScreenUtil().setSp(
                          12,
                        ),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: ScreenUtil().setHeight(
                72,
              ),
              left: ScreenUtil().setWidth(
                184,
              ),
              child: GestureDetector(
                onTap: () async {
                  if (_recordeFile != null) {
                    await _stopPlayRecordeFile();
                    _recordeFile = null;
                    setState(() {
                      _recordeSecond = 0;
                      _audioStateExt = AudioStateExt.ready;
                    });
                    Fluttertoast.showToast(msg: '삭제되었습니다.');
                  } else {
                    Fluttertoast.showToast(msg: '저장된 파일이 없습니다.');
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _recordeFile != null ? const Color(0xff03C9C3) : const Color.fromARGB(
                      255,
                      217,
                      247,
                      246,
                    ),
                    borderRadius: BorderRadius.circular(
                      100,
                    ),
                  ),
                  height: ScreenUtil().setHeight(
                    32,
                  ),
                  width: ScreenUtil().setHeight(
                    90,
                  ),
                  child: Center(
                    child: Text(
                      '삭제하기',
                      style: TextStyle(
                        color: const Color.fromARGB(
                          255,
                          255,
                          255,
                          255,
                        ),
                        fontSize: ScreenUtil().setSp(
                          12,
                        ),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}

class ContainerWidgt extends StatelessWidget {
  final String? image;
  final String title;
  final double width;
  final double? hight;
  final VoidCallback? onTap;
  final Color? color;
  final Border? decoration;

  const ContainerWidgt({
    super.key,
    required this.title,
    required this.width,
    this.image,
    this.onTap,
    this.color,
    this.decoration,
    this.hight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: hight,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              100,
            ),
            color: color,
            border: decoration),
        child: Padding(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(11.0)),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //null 에러날떄
              image != null
                  ? Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(
                          2,
                        ),
                      ),
                      child: Image.asset(
                        image!,
                        width: 16,
                        height: 16,
                        fit: BoxFit.contain,
                      ),
                    )
                  : const Text(''),
              const SizedBox(
                width: 5,
              ),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DescriptionContainer extends StatelessWidget {
  final String title;
  final String titledescription;

  const DescriptionContainer({
    super.key,
    required this.title,
    required this.titledescription,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
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
            width: ScreenUtil().setWidth(
              335,
            ),
            height: ScreenUtil().setHeight(
              48,
            ),
            decoration: BoxDecoration(
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
              borderRadius: BorderRadius.circular(
                8,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(
                  14,
                ),
                left: ScreenUtil().setWidth(
                  16,
                ),
              ),
              child: Text(
                titledescription,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(
                    14,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
