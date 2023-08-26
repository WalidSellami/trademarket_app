
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

String getOs() {

  return Platform.operatingSystem;

}


Future<String?> getDeviceToken() {

  return FirebaseMessaging.instance.getToken();

}


dynamic uId;

bool? isSavedAccount;

bool? isGoogleSignIn;

bool? isFirstSignIn;


String profile = 'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.webp';
