import 'package:flutter/material.dart';
import 'package:flutter_metalk/providers/base_provider.dart';
import 'package:flutter_metalk/providers/chat_provider.dart';
import 'package:flutter_metalk/providers/home_data_provider.dart';

import 'package:flutter_metalk/splash.dart';
import 'package:flutter_metalk/utils/firebase_utils.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';

void main() async {
  //스플래시스크린
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await FirebaseUtils.init();
  KakaoSdk.init(
    nativeAppKey: '88e709762be7ec95f714f423219729f4',
    javaScriptAppKey: '6a7384f1276a4fcbbe62cdf18ea0a372',
  );

  GetIt.instance.registerSingleton<ChatProvider>(ChatProvider());

  runApp(const MyApp());

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        375,
        812,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => BaseProvider()),
            ChangeNotifierProvider(create: (_) => HomeDataProvider()),
            ChangeNotifierProvider(create: (_) => GetIt.instance.get<ChatProvider>()),
          ],
          child: MaterialApp(
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1,
                ),
                child: child!,
              );
            },
            debugShowCheckedModeBanner: false,
            title: 'metalk',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
