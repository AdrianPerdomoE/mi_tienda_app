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
    apiKey: 'AIzaSyClaUm72lC80cw-89sZgt6mmT74B-db4rk',
    appId: '1:108517181665:android:20f0fe8c911adfcdff4fa0',
    messagingSenderId: '108517181665',
    projectId: 'mi-tienda-app-801c9',
    databaseURL: 'https://mi-tienda-app-801c9-default-rtdb.firebaseio.com',
    storageBucket: 'mi-tienda-app-801c9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5NlZ3859mC6SdabvHaUXLJkje4YIO7uU',
    appId: '1:108517181665:ios:17f862970b46718fff4fa0',
    messagingSenderId: '108517181665',
    projectId: 'mi-tienda-app-801c9',
    databaseURL: 'https://mi-tienda-app-801c9-default-rtdb.firebaseio.com',
    storageBucket: 'mi-tienda-app-801c9.appspot.com',
    androidClientId: '108517181665-gnjtlspq39r24g1e0s8pujcr3egi4ep0.apps.googleusercontent.com',
    iosClientId: '108517181665-ok429roc6psb3eed3faj8k2851cb3gj3.apps.googleusercontent.com',
    iosBundleId: 'com.example.miTiendaApp',
  );
}
