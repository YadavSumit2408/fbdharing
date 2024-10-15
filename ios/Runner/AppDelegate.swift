import UIKit
import Flutter
import Photos

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example.fbdharing/share", binaryMessenger: controller.binaryMessenger)

        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "share" {
                if let args = call.arguments as? [String: Any],
                   let filePath = args["filePath"] as? String,
                   let fileType = args["fileType"] as? String {
                    self.shareToMessenger(filePath: filePath, fileType: fileType)
                    result("Shared successfully")
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "File path or type is null", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func shareToMessenger(filePath: String, fileType: String) {
        let url = URL(fileURLWithPath: filePath)
        
        if FileManager.default.fileExists(atPath: filePath) {
            let documentController = UIDocumentInteractionController(url: url)
            documentController.uti = fileType == "image" ? "public.image" : "public.movie"
            documentController.presentOpenInMenu(from: CGRect.zero, in: UIApplication.shared.keyWindow!, animated: true)
            
            // Open the Messenger app
            let messengerURL = URL(string: "fb-messenger://")!
            if UIApplication.shared.canOpenURL(messengerURL) {
                UIApplication.shared.open(messengerURL, options: [:], completionHandler: nil)
            } else {
                print("Messenger app is not installed.")
            }
        } else {
            print("File not found at path: \(filePath)")
        }
    }
}
