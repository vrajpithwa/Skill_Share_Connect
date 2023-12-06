import 'package:firebase_messaging/firebase_messaging.dart';

Future<void>handleBackgroungMessage(RemoteMessage message) async {
  
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('token $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroungMessage);
  }
}
