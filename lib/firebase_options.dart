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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBy_4UzjiHUkj7LWv03pXsOBoo7r1_3XYI',
    appId: '1:795152336054:web:2eddf261b30fbd88b9d217',
    messagingSenderId: '795152336054',
    projectId: 'skillexchangeplatform',
    authDomain: 'skillexchangeplatform.firebaseapp.com',
    storageBucket: 'skillexchangeplatform.appspot.com',
    measurementId: 'G-07FQ58VQ13',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA6tAvBTHetkuF_dXofdKVT4M_UXzCmwvc',
    appId: '1:795152336054:android:8cac8119036123e5b9d217',
    messagingSenderId: '795152336054',
    projectId: 'skillexchangeplatform',
    storageBucket: 'skillexchangeplatform.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCl-Nv5SzEHeKT6zq8iQT6DKGaKUjrwoP8',
    appId: '1:795152336054:ios:85b9217522c7a3efb9d217',
    messagingSenderId: '795152336054',
    projectId: 'skillexchangeplatform',
    storageBucket: 'skillexchangeplatform.appspot.com',
    iosClientId: '795152336054-mbfj161q1g6cnbnm3fi4e4igjjogbmku.apps.googleusercontent.com',
    iosBundleId: 'com.example.ssc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCl-Nv5SzEHeKT6zq8iQT6DKGaKUjrwoP8',
    appId: '1:795152336054:ios:f79262603985f254b9d217',
    messagingSenderId: '795152336054',
    projectId: 'skillexchangeplatform',
    storageBucket: 'skillexchangeplatform.appspot.com',
    iosClientId: '795152336054-h10lda502jptq8de50r4pdrkv3hvf4q7.apps.googleusercontent.com',
    iosBundleId: 'com.example.ssc.RunnerTests',
  );
}
