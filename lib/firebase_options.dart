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
    apiKey: 'AIzaSyBlQNyNOSvongMxAzJLsqA7fe4qXMH8K-o',
    appId: '1:682810797194:web:c4e37e48d343f48bcd5173',
    messagingSenderId: '682810797194',
    projectId: 'chatkuy-3f559',
    authDomain: 'chatkuy-3f559.firebaseapp.com',
    storageBucket: 'chatkuy-3f559.appspot.com',
    measurementId: 'G-Z67B9SJYBH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD7lvkBms8uzAmdHH0mgovtsdGgF4YgjmU',
    appId: '1:682810797194:android:3d718a4da6adff5acd5173',
    messagingSenderId: '682810797194',
    projectId: 'chatkuy-3f559',
    storageBucket: 'chatkuy-3f559.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD_as7qDmRI5OUsUpURBi-q4Aa-k-j3puM',
    appId: '1:682810797194:ios:afb5d39877bb3636cd5173',
    messagingSenderId: '682810797194',
    projectId: 'chatkuy-3f559',
    storageBucket: 'chatkuy-3f559.appspot.com',
    iosBundleId: 'com.example.chatkuy',
  );
}
