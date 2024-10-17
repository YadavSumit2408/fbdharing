import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Share to Messenger Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                String filePath = await copyAssetToFileSystem('assets/playstore.png');
                log("File path: $filePath");
                await MessengerShare.shareMediaToMessenger(filePath, "image");
              } catch (e) {
                log("Error sharing to Messenger: $e");
              }
            },
            child: Text('Share to Messenger'),
          ),
        ),
      ),
    );
  }

  Future<String> copyAssetToFileSystem(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
    return file.path;
  }
}

class MessengerShare {
  static const platform = MethodChannel('com.example.fbdharing/share');

  static Future<void> shareMediaToMessenger(String filePath, String fileType) async {
    log("Sharing media with path: $filePath and type: $fileType");

    try {
      await platform.invokeMethod('share', {
        'filePath': filePath,
        'fileType': fileType,
      });
    } on PlatformException catch (e) {
      log("Failed to share media to Messenger: '${e.message}'.");
    }
  }
}
