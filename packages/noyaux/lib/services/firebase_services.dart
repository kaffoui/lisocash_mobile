import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebaseServices {
  @protected
  static FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @protected
  static FirebaseMessaging get firebaseMessaging => _firebaseMessaging;
  
  Future<String?> getTokenUser() async {
    final token = await firebaseMessaging.getToken();
    return token;
  }
}
