import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    return android;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyATYgT0Hq-SA4VGrZxXgT1WaU8KQ-UUdNM',
    appId: '1:491393614617:web:063da5f8ab1f7d7f5f7b88',
    messagingSenderId: '491393614617',
    projectId: 'simpleecommerceapp-e0d2d',
    authDomain: 'simpleecommerceapp-e0d2d.firebaseapp.com',
    storageBucket: 'simpleecommerceapp-e0d2d.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyATYgT0Hq-SA4VGrZxXgT1WaU8KQ-UUdNM',
    appId: '1:491393614617:android:063da5f8ab1f7d7f5f7b88',
    messagingSenderId: '491393614617',
    projectId: 'simpleecommerceapp-e0d2d',
    storageBucket: 'simpleecommerceapp-e0d2d.firebasestorage.app',
  );
}
