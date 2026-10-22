import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

const _databaseUrl =
    'https://ssmart-room-energy-default-rtdb.asia-southeast1.firebasedatabase.app';

final appDatabase = FirebaseDatabase.instanceFor(
  app: Firebase.app(),
  databaseURL: _databaseUrl,
);
