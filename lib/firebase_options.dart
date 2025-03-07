// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBXmAd67Pn4PAfnqOJ_d2GXtfQMGZTBFZ0',
    appId: '1:113521609925:web:d335948392551bd1b9f4ac',
    messagingSenderId: '113521609925',
    projectId: 'fir-auth-3331e',
    authDomain: 'fir-auth-3331e.firebaseapp.com',
    storageBucket: 'fir-auth-3331e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTyQuwi3hm-AmHGUBo-HDP6NKM7Mn_q7I',
    appId: '1:113521609925:android:99ad98af1903ebd3b9f4ac',
    messagingSenderId: '113521609925',
    projectId: 'fir-auth-3331e',
    storageBucket: 'fir-auth-3331e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBgv3JDsHSQRecGwwXPlaLYQ3pG7tY6JS0',
    appId: '1:113521609925:ios:596afda11eba995eb9f4ac',
    messagingSenderId: '113521609925',
    projectId: 'fir-auth-3331e',
    storageBucket: 'fir-auth-3331e.appspot.com',
    iosClientId: '113521609925-bf6h4sh6rd1tidsrmfr9n9fmuqen2klh.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBgv3JDsHSQRecGwwXPlaLYQ3pG7tY6JS0',
    appId: '1:113521609925:ios:596afda11eba995eb9f4ac',
    messagingSenderId: '113521609925',
    projectId: 'fir-auth-3331e',
    storageBucket: 'fir-auth-3331e.appspot.com',
    iosClientId: '113521609925-bf6h4sh6rd1tidsrmfr9n9fmuqen2klh.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBXmAd67Pn4PAfnqOJ_d2GXtfQMGZTBFZ0',
    appId: '1:113521609925:web:497e6a8fdc92b251b9f4ac',
    messagingSenderId: '113521609925',
    projectId: 'fir-auth-3331e',
    authDomain: 'fir-auth-3331e.firebaseapp.com',
    storageBucket: 'fir-auth-3331e.appspot.com',
  );

}