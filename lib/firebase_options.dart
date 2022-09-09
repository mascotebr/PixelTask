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
        return web;
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
      apiKey: "AIzaSyAGUaHfXjUoYZUJaXqTjISUJKUR-5DGOUk",
      authDomain: "pixel-tasks-d8cd1.firebaseapp.com",
      databaseURL: "https://pixel-tasks-d8cd1-default-rtdb.firebaseio.com",
      projectId: "pixel-tasks-d8cd1",
      storageBucket: "pixel-tasks-d8cd1.appspot.com",
      messagingSenderId: "1072338968606",
      appId: "1:1072338968606:web:70f7d1f897bcbdabb84e0f",
      measurementId: "G-WXLGEZYH9B");

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_wLH9t9IY9p8wWwrB2YkN8VBD99oYf2Y',
    appId: '1:1072338968606:android:3661352df48f473fb84e0f',
    messagingSenderId: '1072338968606',
    projectId: 'pixel-tasks-d8cd1',
    storageBucket: 'pixel-tasks-d8cd1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJ1Tni5_tTNQceo75HXtv631Wl7NlF5uk',
    appId: '1:1072338968606:ios:9ef25f07b9d27bbbb84e0f',
    messagingSenderId: '1072338968606',
    projectId: 'pixel-tasks-d8cd1',
    storageBucket: 'pixel-tasks-d8cd1.appspot.com',
    iosClientId:
        '1072338968606-e0hq30ddq701a2rolpv1jq57j7rgd6vt.apps.googleusercontent.com',
    iosBundleId: 'com.example.pixelTasks',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCJ1Tni5_tTNQceo75HXtv631Wl7NlF5uk',
    appId: '1:1072338968606:ios:9ef25f07b9d27bbbb84e0f',
    messagingSenderId: '1072338968606',
    projectId: 'pixel-tasks-d8cd1',
    storageBucket: 'pixel-tasks-d8cd1.appspot.com',
    iosClientId:
        '1072338968606-e0hq30ddq701a2rolpv1jq57j7rgd6vt.apps.googleusercontent.com',
    iosBundleId: 'com.example.pixelTasks',
  );
}
