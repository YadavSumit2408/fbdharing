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
                      let imageUrl = args["imageUrl"] as? String,
                      let description = args["description"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Image URL or description is null", details: nil))
                    return
                }
                self?.openMessengerApp(imageUrl: imageUrl, description: description)
                result("Messenger opened successfully")
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func openMessengerApp(imageUrl: String, description: String) {
        // Format the Messenger URL scheme to share the link and description
        let encodedImageUrl = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let encodedDescription = description.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let messengerURL = URL(string: "fb-messenger://share?link=\(encodedImageUrl)&app_id=YOUR_APP_ID&description=\(encodedDescription)")! // Replace YOUR_APP_ID with your actual Facebook App ID

        if UIApplication.shared.canOpenURL(messengerURL) {
            // Open the Messenger app with the link and description
            UIApplication.shared.open(messengerURL, options: [:], completionHandler: { success in
                if success {
                    print("Opened Messenger successfully.")
                } else {
                    print("Failed to open Messenger.")
                }
            })
        } else {
            print("Facebook Messenger is not installed.")
        }
    }
}
