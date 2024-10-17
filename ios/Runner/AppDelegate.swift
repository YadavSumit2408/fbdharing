import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let shareChannel = FlutterMethodChannel(name: "com.example.fbdharing/share", binaryMessenger: controller.binaryMessenger)

        shareChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "share" {
                guard let args = call.arguments as? [String: Any],
                      let filePath = args["filePath"] as? String,
                      let fileType = args["fileType"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "File path or type is null", details: nil))
                    return
                }
                self?.openMessengerApp(filePath: filePath, fileType: fileType)
                result("Messenger opened successfully")
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func openMessengerApp(filePath: String, fileType: String) {
        let messengerURL = URL(string: "fb-messenger://share")! // Use Messenger's URL scheme

        if UIApplication.shared.canOpenURL(messengerURL) {
            // Open Messenger app
            UIApplication.shared.open(messengerURL, options: [:], completionHandler: nil)
        } else {
            print("Facebook Messenger is not installed.")
        }
    }
}
