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
    apiKey: 'AIzaSyAV-4cKlsAZcI8J2lrdgBCefzZnl1uDsX4',
    appId: '1:1015020625624:web:c77abefdd4182287de01ad',
    messagingSenderId: '1015020625624',
    projectId: 'swapify-5938c',
    authDomain: 'swapify-5938c.firebaseapp.com',
    storageBucket: 'swapify-5938c.firebasestorage.app',
    measurementId: 'G-0PP3Q6H1TF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA2-cNRg6S7UQK8wHTRn1kUscB9_KqNZo8',
    appId: '1:1015020625624:android:bffd0253c310fe02de01ad',
    messagingSenderId: '1015020625624',
    projectId: 'swapify-5938c',
    storageBucket: 'swapify-5938c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCbYAe6hPqhAex9t5j-D-xTStmBj8ARpUM',
    appId: '1:1015020625624:ios:44b49e4d2e9c1395de01ad',
    messagingSenderId: '1015020625624',
    projectId: 'swapify-5938c',
    storageBucket: 'swapify-5938c.firebasestorage.app',
    iosBundleId: 'com.swapify.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCbYAe6hPqhAex9t5j-D-xTStmBj8ARpUM',
    appId: '1:1015020625624:ios:9f6e5411db8135e9de01ad',
    messagingSenderId: '1015020625624',
    projectId: 'swapify-5938c',
    storageBucket: 'swapify-5938c.firebasestorage.app',
    iosBundleId: 'com.example.swapify',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAV-4cKlsAZcI8J2lrdgBCefzZnl1uDsX4',
    appId: '1:1015020625624:web:7561fa39d896c88dde01ad',
    messagingSenderId: '1015020625624',
    projectId: 'swapify-5938c',
    authDomain: 'swapify-5938c.firebaseapp.com',
    storageBucket: 'swapify-5938c.firebasestorage.app',
    measurementId: 'G-H4M8F5FEQH',
  );

}