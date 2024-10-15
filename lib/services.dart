import 'dart:developer';

import 'package:flutter/services.dart';

class MessengerShare {
  static const platform = MethodChannel('com.example.fbdharing/share');

  static Future<void> shareMediaToMessenger(
      String filePath, String fileType) async {
    log(filePath.toString());
    try {
      await platform.invokeMethod('share', {
        'filePath': filePath,
        'fileType': fileType, // Use "image" or "video"
      });
    } on PlatformException catch (e) {
      print("Failed to share: '${e.message}'.");
    }
  }
}
