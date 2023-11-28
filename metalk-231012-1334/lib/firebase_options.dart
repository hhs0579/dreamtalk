// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCIPtrim9v6fDoRRrP1f10S8BMc0MEbzoo',
    appId: '1:14023959625:android:fa940ee34a24766ba84b98',
    messagingSenderId: '14023959625',
    projectId: 'metalk-95884',
    storageBucket: 'metalk-95884.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC1pYbHN7sW-vMda9IbCgi3eH8kBvRTFdM',
    appId: '1:14023959625:ios:df16ee1fdf01bb5ea84b98',
    messagingSenderId: '14023959625',
    projectId: 'metalk-95884',
    storageBucket: 'metalk-95884.appspot.com',
    androidClientId: '14023959625-ullt571kmnmcsfjs3eiei61tahpgejv7.apps.googleusercontent.com',
    iosClientId: '14023959625-vjq5oqqs0jccp2sn6dg2e55iuvjibu81.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterMetalk',
  );
}