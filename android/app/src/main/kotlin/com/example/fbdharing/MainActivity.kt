package com.example.fbdharing

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.fbdharing/share"

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "share") {
                val filePath = call.argument<String>("filePath")
                val fileType = call.argument<String>("fileType")

                if (filePath != null && fileType != null) {
                    shareToMessenger(filePath, fileType)
                    result.success("Shared successfully")
                } else {
                    result.error("INVALID_ARGUMENT", "File path or type is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun shareToMessenger(filePath: String, fileType: String) {
    val file = File(filePath)

    if (file.exists()) {
        Log.d("FileProvider", "File found: ${file.absolutePath}")

        val uri: Uri = FileProvider.getUriForFile(this, "${applicationContext.packageName}.fileprovider", file)
        val shareIntent = Intent(Intent.ACTION_SEND).apply {
            type = if (fileType == "image") "image/*" else "video/*"
            putExtra(Intent.EXTRA_STREAM, uri)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }

        // Check if Messenger is installed
        val packageManager = packageManager
        val isMessengerInstalled = packageManager.getInstalledApplications(0)
            .any { it.packageName == "com.facebook.orca" }

        if (isMessengerInstalled) {
            shareIntent.setPackage("com.facebook.orca") // Set the package name for Facebook Messenger
        } else {
            Log.e("FileProvider", "Facebook Messenger not installed. Using default share.")
        }

        startActivity(Intent.createChooser(shareIntent, "Share via"))
    } else {
        Log.e("FileProvider", "File not found in cache directory: ${file.absolutePath}")
    }
}

}
