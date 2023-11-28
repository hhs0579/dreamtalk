import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_metalk/apis/firabase_storage_api.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/bottomnavigation/root_tab.dart';
import 'package:flutter_metalk/components/image_padding.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/extentions/audio_state_ext.dart';
import 'package:flutter_metalk/model/profile_create.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/utils/custom_styles.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class PhoneProfileThree extends StatefulWidget {
  final ProfileCreate profileCreate;

  const PhoneProfileThree({super.key,
    required this.profileCreate,
  });

  @override
  State<PhoneProfileThree> createState() => _PhoneProfileThreeState();
}

class _PhoneProfileThreeState extends State<PhoneProfileThree> {
  bool _isLoading = true;
  late UserVo _userVo;
  final List<File?> _images = List.filled(5, null);
  String? _description;
  bool _isProcessingSubmit = false;

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


  @override
  void dispose() {
    _recorderTimer?.cancel();
    _recorder?.stop();
    _audioPlayer?.stop();
    super.dispose();
  }

  Future<void> _initData() async {
    UserVo? userVo = await UserApi.getUser();
    if (userVo == null) {
      Fluttertoast.showToast(msg: '로그인 후 사용 가능한 기능입니다.');
      Future.delayed(Duration.zero, () => Navigator.pop(context));
      return;
    }
    _userVo = userVo;

    _recordeFilePath = '${(await getApplicationDocumentsDirectory()).path}/audio_message.m4a';

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: SizedBox(
                        width: ScreenUtil().setWidth(
                          335,
                        ),
                        height: ScreenUtil().setHeight(
                          4,
                        ),
                        child: const LinearProgressIndicator(
                          value: 1.0,
                          backgroundColor: Color.fromARGB(
                            255,
                            229,
                            229,
                            229,
                          ),
                          color: Colors.black45,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(
                              255,
                              3,
                              201,
                              195,
                            ),
                          ),
                          minHeight: 5.0,
                          semanticsLabel: 'semanticsLabel',
                          semanticsValue: 'semanticsValue',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(
                          6,
                        ),
                        right: ScreenUtil().setWidth(
                          20,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '3/3',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(
                                12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '당신을 보여주세요!',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(
                          20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        2,
                      ),
                    ),
                    Text(
                      '당신의 매력을 어필해 보세요!',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil().setSp(14),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        24,
                      ),
                    ),
                    Expanded(child: SingleChildScrollView(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '사진등록',
                          style: TextStyle(
                            color: const Color.fromARGB(
                              255,
                              23,
                              23,
                              23,
                            ),
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
                          '5개까지 등록할 수 있어요.',
                          style: TextStyle(
                            color: Colors.black,
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _images.asMap().entries.map((entry) {
                              int index = entry.key;
                              File? image = entry.value;

                              return Row(
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
                                          if (image == null)...[
                                            Center(
                                              child: Icon(
                                                Icons.camera_alt_rounded,
                                                color: index == 0 ? const Color.fromARGB(255, 177, 238, 236,) : const Color.fromARGB(255, 212, 212, 212,),
                                              ),
                                            ),
                                          ]else...[
                                            Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: FileImage(image),
                                                  fit: BoxFit.cover,
                                                ),
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
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            36,
                          ),
                        ),
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
                        Description(
                          onChange: (value) => setState(() => _description = value),
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
                          '최소 5초, 최대 10초까지 등록할 수 있어요.',
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
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            48,
                          ),
                        ),
                      ],
                    ),)),
                    GestureDetector(
                      onTap: () => _onSubmit(),
                      child: Container(
                        width: ScreenUtil().setWidth(
                          335,
                        ),
                        height: ScreenUtil().setHeight(
                          56,
                        ),
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
                        child: Center(
                          child: Text(
                            '완료',
                            style: TextStyle(
                              color: const Color.fromARGB(
                                255,
                                255,
                                255,
                                255,
                              ),
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(
                                16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
      ),
    );
  }

  Future<void> _onPressedUploadImage(int index) async {
    XFile? xFile = await Utils.pickImageFromGallery();

    if (xFile != null) {
      setState(() {
        _images[index] = File(xFile.path);
      });
    } else {
      Fluttertoast.showToast(msg: '해당 파일을 불러오는 중 오류가 발생하였습니다.');
    }
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

  Future<void> _stopPlayRecordeFile() async {
    debugPrint('_stopPlayRecordeFile()');
    await _audioPlayer?.stop();
    setState(() => _audioStateExt = AudioStateExt.stop);
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

  String _getCurrentDuration() {
    Duration? playDuration = _playDuration;
    int second = _recordeSecond;

    if (playDuration != null && _audioStateExt == AudioStateExt.play) {
      second = playDuration.inSeconds;
    }

    return '0:${second.toString().padLeft(2, '0')} ';
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

  Future<void> _onSubmit() async {
    List<File> imageList = _images.where((element) => element != null).map((e) => e!).toList();
    String description = _description ?? '';

    Utils.hideKeyboard();
    FocusNode().unfocus();

    if (_images.first == null) {
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
    for (File image in imageList) {
      String? downloadURL = await FirebaseStorageApi.uploadFile(File(image.path), FirebaseStorageApi.uploadPathProfile);
      if (downloadURL == null) {
        setState(() => _isProcessingSubmit = false);
        Fluttertoast.showToast(msg: '이미지 업로드 중 오류가 발생하였습니다.\n다른 이미지 파일을 사용하시거나 잠시 후 다시 시도해주세요.');
        return;
      }
      imageUrlList.add(downloadURL);
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

    ProfileCreate profileCreate = widget.profileCreate;
    profileCreate.imageUrlList = imageUrlList;
    profileCreate.description = description;
    profileCreate.voiceMessageUrl = voiceMessageUrl;

    UserVo? userVo = await UserApi.updateUserCreateProfile(user: _userVo, profileCreate: profileCreate);
    if (userVo != null) {
      Future.delayed(Duration.zero, () => Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(
          builder: (BuildContext context) => const RootTab(),
        ), (route) => false,
      ));
    } else {
      Fluttertoast.showToast(msg: '정보 업데이트 중 오류가 발생하였습니다.');
    }
  }
}

class Description extends StatefulWidget {
  final ValueChanged<String> onChange;

  const Description({super.key,
    required this.onChange,
  });

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  late int maxlength = 500;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: ScreenUtil().setWidth(
        335,
      ),
      height: ScreenUtil().setHeight(
        128,
      ),
      child: TextFormField(
        maxLength: maxlength,
        maxLines: 7,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          // counterText: '$maxlength0자',
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
        onChanged: ((value) => widget.onChange(value)),
      ),
    );
  }
}
