import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Share Link to Messenger Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              // Directly using an image URL and description
              String imageUrl = "https://share.oriflame.brandie.io/?id=bf096367-0d33-43ab-9d25-681ddec0896a"; // Replace with your actual image URL
              String description = "Check out this image!"; // Your description text
              log("Image URL: $imageUrl");
              log("Description: $description");
              await MessengerShare.shareImageLinkToMessenger(imageUrl, description);
            },
            child: Text('Share Image Link to Messenger'),
          ),
        ),
      ),
    );
  }
}

class MessengerShare {
  static const platform = MethodChannel('com.example.fbdharing/share');

  static Future<void> shareImageLinkToMessenger(String imageUrl, String description) async {
    log("Sharing image link: $imageUrl with description: $description");

    try {
      await platform.invokeMethod('share', {
        'imageUrl': imageUrl,
        'description': description,
      });
    } on PlatformException catch (e) {
      log("Failed to share image link to Messenger: '${e.message}'.");
    }
  }
}
