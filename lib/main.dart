import 'dart:io';

import 'package:fbdharing/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
 // Import the class for sharing

void main() {
  runApp(MyApp());
}
 // Platform channel code for sharing

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
              // Copy the asset to file system
              String filePath = await copyAssetToFileSystem('assets/playstore.png');
              
              // Share the file via platform-specific code
              MessengerShare.shareMediaToMessenger(filePath, "image"); // Or "video" for video files
            },
            child: Text('Share to Messenger'),
          ),
        ),
      ),
    );
  }

  Future<String> copyAssetToFileSystem(String assetPath) async {
  // Load the asset data
  final byteData = await rootBundle.load(assetPath);

  // Get the app's cache directory or external storage directory
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/${assetPath.split('/').last}');

  // Write the data to the file
  await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

  return file.path; // Return the path to the copied file
}
}
