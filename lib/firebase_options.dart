import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    throw UnsupportedError(
      'Firebase is currently configured for the web platform only.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB4-qG2SNYmPik531jvai7fsBaHCumyOSA',
    appId: '1:1059888090283:web:87f2585d8d8a3922707bee',
    messagingSenderId: '1059888090283',
    projectId: 'ssmart-room-energy',
    authDomain: 'ssmart-room-energy.firebaseapp.com',
    databaseURL:
        'https://ssmart-room-energy-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'ssmart-room-energy.firebasestorage.app',
  );
}
