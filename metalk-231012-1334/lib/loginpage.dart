import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_metalk/auth/phoneprofile.dart';
import 'package:flutter_metalk/colors/colors.dart';
import 'package:flutter_metalk/components/image_padding.dart';
import 'package:flutter_metalk/components/loading.dart';
import 'package:flutter_metalk/utils/firebase_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      Future.delayed(
          Duration.zero, () => FirebaseUtils.checkUserSignInRouter(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          Scaffold(
            body: Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(
                  176.1,
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/image/loginlogo/logo.png",
                      scale: 2,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        200,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          'SNS 계정으로 시작하기',
                          style: TextStyle(
                              color: ColorList.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            12,
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 1,
                          color: ColorList.grey,
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            30,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            setState(() => _isProcessing = true);
                            try {
                              await FirebaseUtils.kakaoLogin(context);
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                            setState(() => _isProcessing = false);
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(
                                100,
                              ),
                            ),
                            child: SvgPicture.asset(
                              "assets/image/loginlogo/kakao.svg",
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(
                            20,
                          ),
                        ),
                        if (Platform.isIOS) ...[
                          GestureDetector(
                            onTap: () async {
                              setState(() => _isProcessing = true);
                              try {
                                await FirebaseUtils.appleLogin(context);
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                              setState(() => _isProcessing = false);
                            },
                            child: Container(
                              height: 80,
                              width: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorList.grey),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  100,
                                ),
                              ),
                              child: SvgPicture.asset(
                                "assets/image/loginlogo/apple.svg",
                                width: 40,
                                height: 40,
                              ),
                            ),
                          )
                        ],
                        SizedBox(
                          height: ScreenUtil().setHeight(
                            20,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() => _isProcessing = true);
                            try {
                              await FirebaseUtils.googleLogin(context);
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                            setState(() => _isProcessing = false);
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorList.grey),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                100,
                              ),
                            ),
                            child: SvgPicture.asset(
                              "assets/image/loginlogo/goole.svg",
                              width: 40,
                              height: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        12,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(
                        12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isProcessing) ...[
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(.5),
                child: const Loading(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CouponContanier extends StatelessWidget {
  final String title;
  final String? image;
  final String description;
  final double width;
  final double height;
  final TextStyle style;
  final bool isActive;

  const CouponContanier({
    super.key,
    required this.title,
    this.image,
    required this.description,
    required this.width,
    required this.height,
    required this.style,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isActive
            ? const Color(0xffE6FAF9)
            : const Color.fromARGB(
                245,
                245,
                245,
                245,
              ),
      ),
      width: width,
      height: height,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isActive) ...[
                const ImagePadding(
                  'day-active.png',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
              Text(title),
              if (isActive) ...[
                const SizedBox(
                  width: 5,
                ),
                const SizedBox(
                  width: 20,
                  height: 20,
                ),
              ],
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(
              6,
            ),
          ),
          image != null
              ? SvgPicture.asset(
                  image!,
                )
              : const Text(''),
          SizedBox(
            height: ScreenUtil().setHeight(
              2,
            ),
          ),
          Text(
            description,
            style: style,
          ),
        ],
      ),
    );
  }
}
