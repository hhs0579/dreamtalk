import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_metalk/components/location_permission_popup.dart';
import 'package:flutter_metalk/splash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class Utils {
  static RegExp get onlyNumber => RegExp(r'[^0-9]');

  static String numberFormat(int number) {
    final numberFormatter = NumberFormat.simpleCurrency(locale: 'ko_KR', name: '', decimalDigits: 0);
    return numberFormatter.format(number);
  }

  static void navigatorPush(BuildContext context, Widget widget, {
    bool isRemoveUntil = false,
  }) {
    if (isRemoveUntil) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => widget), (route) => false);
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  static dynamic hideKeyboard() {
    return SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static Future<void> closeApp({bool? animated, required int type}) async {
    if (Platform.isIOS) {
      Logger().e('closed app by type: $type');
      exit(0);
    } else {
      await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', animated);
    }
  }

  static Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Future.delayed(Duration.zero, () => navigatorPush(context, const SplashScreen(), isRemoveUntil: true));
  }

  static bool isBottomConsonant(String input){
    bool result = false;
    if(isKorean(input)){
      result = ((input.runes.first- 0xAC00)/(28*21))<0 ? false : (((input.runes.first - 0xAC00) % 28 !=0) ? true : false);
    }
    return result;
  }

  static bool isKorean(String input) {
    bool isKorean = false;
    int inputToUniCode = input.codeUnits[0];
    isKorean = (inputToUniCode >= 12593 && inputToUniCode <= 12643) ? true : (inputToUniCode >= 44032 && inputToUniCode <= 55203) ? true : false;
    return isKorean;
  }

  static bool isValidate({
    required String name,
    required String value,
    bool isCheckEmpty = true,
    bool isCheckEmail = false,
    bool isCheckNum = false,
    int? length,
  }) {
    String lastNameChar = name.substring(name.length - 1);
    if (isCheckEmpty && value.isEmpty) {
      Fluttertoast.showToast(msg: '$name${isBottomConsonant(lastNameChar) ? '을' : '를'} 입력해주세요.');
      return false;
    } else if (isCheckEmail && value.isEmail == false) {
      Fluttertoast.showToast(msg: '$name${isBottomConsonant(lastNameChar) ? '을' : '를'} 형식을 확인해주세요.');
      return false;
    } else if (isCheckNum && value.isNum == false) {
      Fluttertoast.showToast(msg: '$name${isBottomConsonant(lastNameChar) ? '은' : '는'} 숫자만 입력해주세요.');
      return false;
    } else if (length != null && value.length != length) {
      Fluttertoast.showToast(msg: '$name${isBottomConsonant(lastNameChar) ? '은' : '는'} $length 자리를 입력해주세요.');
      return false;
    }
    return true;
  }

  static Future<XFile?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }

  static bool isSameDay(DateTime dt, DateTime otherDt) {
    return dt.year == otherDt.year
        && dt.month == otherDt.month
        && dt.day == otherDt.day;
  }

  static String getExistDateByProfileBirth(String str) {
    String repStr = '${str.substring(0, 4)}-${str.substring(4, 6)}-${str.substring(6, 8)}';
    DateTime repDt = DateTime.parse(repStr);
    return '${repDt.year}${repDt.month.toString().padLeft(2, '0')}${repDt.day.toString().padLeft(2, '0')}';
  }

  static int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  static Future<Position?> getCurrentLocationPosition({
    required BuildContext context,
    LocationAccuracy locationAccuracy = LocationAccuracy.medium,
  }) async {
    if (await checkLocationPermission(context: context)) {
      Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: locationAccuracy);
      debugPrint('currentPosition: $currentPosition');
      return currentPosition;
    }
    return null;
  }

  static Future<bool> checkLocationPermission({
    required BuildContext context,
  }) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Future.delayed(Duration.zero, () => LocationPermissionPopup.showPopup(context));
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.delayed(Duration.zero, () => LocationPermissionPopup.showPopup(context));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Future.delayed(Duration.zero, () => LocationPermissionPopup.showPopup(context));
      return false;
    }

    return true;
  }

  static String getDistanceResponseString(double? distanceKm) {
    String result = '';

    if (distanceKm != null) {
      if (distanceKm < 1) {
        double distanceMeter = distanceKm / 1000;
        result = '${distanceMeter.toStringAsFixed(1)}m';
      } else if (distanceKm > 0) {
        result = '${distanceKm.toStringAsFixed(1)}km';
      }
    }

    return result;
  }

  static String parseOnlyNumber(String value) {
    return value.replaceAll(RegExp('[^0-9]'), '');
  }

  static void showLoadingToast() {
    Fluttertoast.showToast(msg: '데이터를 불러오는 중입니다.\n잠시만 기다려주세요.');
  }
}