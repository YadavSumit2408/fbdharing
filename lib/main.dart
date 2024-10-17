// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Share Link to Messenger Example'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () async {
//               // Directly using an image URL and description
//               String imageUrl = "https://share.oriflame.brandie.io/?id=bf096367-0d33-43ab-9d25-681ddec0896a"; // Replace with your actual image URL
//               String description = "Check out this image!"; // Your description text
//               log("Image URL: $imageUrl");
//               log("Description: $description");
//               await MessengerShare.shareImageLinkToMessenger(imageUrl, description);
//             },
//             child: Text('Share Image Link to Messenger'),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MessengerShare {
//   static const platform = MethodChannel('com.example.fbdharing/share');

//   static Future<void> shareImageLinkToMessenger(String imageUrl, String description) async {
//     log("Sharing image link: $imageUrl with description: $description");

//     try {
//       await platform.invokeMethod('share', {
//         'imageUrl': imageUrl,
//         'description': description,
//       });
//     } on PlatformException catch (e) {
//       log("Failed to share image link to Messenger: '${e.message}'.");
//     }
//   }
// }
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
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
          title: Text('Share to Messenger Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              // Copy the asset to file system
              String filePath = await copyAssetToFileSystem('assets/playstore.png');
              log(filePath.toString());
              String description = "Check out this amazing app!"; // Description text

              // Share the file via platform-specific code
              await MessengerShare.shareMediaToMessenger(filePath, "image", description);
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

    // Get the app's cache directory
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${assetPath.split('/').last}');

    // Write the data to the file
    await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

    return file.path; // Return the path to the copied file
  }
}

class MessengerShare {
  static const platform = MethodChannel('com.example.fbdharing/share');

  static Future<void> shareMediaToMessenger(String filePath, String fileType, String description) async {
    log("Sharing file: $filePath of type: $fileType with description: $description");

    try {
      await platform.invokeMethod('share', {
        'filePath': filePath,
        'fileType': fileType,
        'description': description, // Include the description
      });
    } on PlatformException catch (e) {
      log("Failed to share: '${e.message}'.");
    }
  }
}

