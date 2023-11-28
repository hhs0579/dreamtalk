import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_metalk/apis/user_api.dart';
import 'package:flutter_metalk/auth/phoneauth.dart';
import 'package:flutter_metalk/auth/phoneprofile.dart';
import 'package:flutter_metalk/bottomnavigation/root_tab.dart';
import 'package:flutter_metalk/components/custom_modals.dart';
import 'package:flutter_metalk/firebase_options.dart';
import 'package:flutter_metalk/loginpage.dart';
import 'package:flutter_metalk/model/user_vo.dart';
import 'package:flutter_metalk/providers/chat_provider.dart';
import 'package:flutter_metalk/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart' as kakao_api;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

class FirebaseUtils {
  static String socialLoginPassword = 'social_login';
  static String _serverKey = 'AAAAA0PkpEk:APA91bG2RLPqBzx9iN-KVrOD3ELAe0MFdHBvi3Ax5ZtXfF7ul4UHq-PtfuKOlLt42A2N59NJPoKYmzDqhMfyLXQO8m36Vsu8x_TzIqKxdUQymvU5lkedlfpnjWIc793tHZWmY-4W_eC6';

  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: false,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _receiveMessageEvent(
        message: message,
        isBackground: false,
      );
    });

    FirebaseMessaging.onBackgroundMessage(_messagingBackgroundHandler);

    Timer.periodic(const Duration(seconds: 5), (timer) {
      try {
        UserApi.updateLastLogin();
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  static Future<void> _messagingBackgroundHandler(RemoteMessage message) async {
    debugPrint('_messagingBackgroundHandler()');
    await Firebase.initializeApp();

    _receiveMessageEvent(
      message: message,
      isBackground: true,
    );
  }

  static Future<void> _receiveMessageEvent({
    required RemoteMessage message,
    required bool isBackground,
  }) async {
    debugPrint('_receiveMessageEvent()');
    debugPrint('${message.toMap()}');

    GetIt.instance.get<ChatProvider>().receiveChatMessage();
  }

  static Future<String?> getFirebaseToken() async {
    String? firebaseToken = await FirebaseMessaging.instance.getToken();
    debugPrint('firebaseToken: $firebaseToken');
    return firebaseToken;
  }

  static Future<void> sendFbMessage({
    required String fbToken,
    required String title,
    String body = '',
    required Map<String, String>? data,
  }) async {
    http.Response response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverKey'
        },
        body: jsonEncode({
          'notification': {
            'title': title,
            'body': body,
            'sound': 'false',
          },
          'ttl': '60s',
          "content_available": true,
          'data': data,
          'to': fbToken,
        }));
    debugPrint('response.statusCode: ${response.statusCode}');
    debugPrint('response.body: ${response.body}');
  }

  static Future<void> kakaoLogin(BuildContext context) async {
    await kakao_api.UserApi.instance.loginWithKakaoAccount();

    kakao_api.User kakaoUser = await kakao_api.UserApi.instance.me();
    debugPrint(kakaoUser.toString());

    var id = kakaoUser.id.toString();
    var email = "$id@kakao.com";

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: socialLoginPassword,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: socialLoginPassword,
        );
      }
    }

    await Future.delayed(Duration.zero, () => registerUser(context,
      loginType: 'kakao',
      email: email,
    ));
  }

  static Future<void> registerUser(BuildContext context, {
    required String loginType,
    required String email,
    String? name,
  }) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    debugPrint('registerUser() - uid: $uid');
    final value = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (value.exists) {
      debugPrint('registerUser() - User exists');
    } else {
      //유저 없을 시 생성
      await FirebaseFirestore.instance.collection("users").doc(uid).set(UserVo(
        id: uid!,
        loginType: loginType,
        email: email,
        userName: name,
        createDt: DateTime.now(),
      ).toMap());
    }

    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.currentUser!.updatePassword(socialLoginPassword);
      UserApi.refreshMyLocation(context);
      UserApi.refreshFirebaseToken();
      Future.delayed(Duration.zero, () => FirebaseUtils.checkUserSignInRouter(context));
    }
  }

  static Future<void> googleLogin(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'profile',
      ],
    );
    final GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account != null) {
      final GoogleSignInAuthentication googleAuth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      await Future.delayed(Duration.zero, () => registerUser(context,
        loginType: 'google',
        email: account.email,
        name: account.displayName,
      ));
    }
  }

  static Future<void> appleLogin(BuildContext context) async {
    AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    debugPrint(appleCredential.toString());

    String? email = FirebaseAuth.instance.currentUser?.email;
    if (email != null) {
      await Future.delayed(Duration.zero, () => registerUser(context,
        loginType: 'apple',
        email: email,
        name: appleCredential.givenName,
      ));
    } else {
      Fluttertoast.showToast(msg: '로그인 중 이메일 정보를 받아오지 못하였습니다.');
    }
  }

  static Future<void> checkUserSignInRouter(BuildContext context, {
    bool isRemoveUntil = false,
    bool isSplashPage = false,
  }) async {
    debugPrint('checkUserSignInRouter()');
    UserVo? userVo = await UserApi.getUser();
    if (userVo == null) {
      Future.delayed(Duration.zero, () => Utils.navigatorPush(context, const LoginPage(), isRemoveUntil: isRemoveUntil));
      return;
    }

    if (userVo.isBlock) {
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;
      CustomModals.showBlockUser(context);
      return;
    }

    if (userVo.isVerifyPhone == false) {
      Future.delayed(Duration.zero, () => Utils.navigatorPush(context, const PhoneAuth(), isRemoveUntil: isRemoveUntil));
      return;
    } else if (userVo.isCompleteProfile() == false) {
      Future.delayed(Duration.zero, () => Utils.navigatorPush(context, const PhoneProfile(), isRemoveUntil: isRemoveUntil));
      return;
    }

    Future.delayed(Duration.zero, () => Utils.navigatorPush(context, const RootTab(), isRemoveUntil: true));
  }
}