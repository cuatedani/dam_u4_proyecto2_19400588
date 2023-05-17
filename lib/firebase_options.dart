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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDnz7VFwaDyfSXuFxKllY2P2UhE-fT_ZRI',
    appId: '1:536458351317:web:d36c1b77965c7a49c6885c',
    messagingSenderId: '536458351317',
    projectId: 'dam-u4-proyecto2-19400588',
    authDomain: 'dam-u4-proyecto2-19400588.firebaseapp.com',
    storageBucket: 'dam-u4-proyecto2-19400588.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1vvPHMn5WPKgUJ-RFXyIRBDZQwSfDgwY',
    appId: '1:536458351317:android:9b549fa3a39a2768c6885c',
    messagingSenderId: '536458351317',
    projectId: 'dam-u4-proyecto2-19400588',
    storageBucket: 'dam-u4-proyecto2-19400588.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBsKSPd07VCI_pgJcIFzISF0oXKP3wtSbo',
    appId: '1:536458351317:ios:35dba9fe2ef0f207c6885c',
    messagingSenderId: '536458351317',
    projectId: 'dam-u4-proyecto2-19400588',
    storageBucket: 'dam-u4-proyecto2-19400588.appspot.com',
    iosClientId: '536458351317-eg1tmq2k3eth9hqnqquvvi1oejst3u9g.apps.googleusercontent.com',
    iosBundleId: 'mx.edu.ittepic.damU4Proyecto219400588',
  );
}
