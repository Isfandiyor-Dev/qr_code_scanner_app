import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {

  // IMPORTANT: these names must be EXACTLY the same as the ones on the Android (Kotlin) side
  private let wifiChannelName = "samples.flutter.dev/wifi"
  private let fileChannelName = "app.channel.shared.data"

  // Strong reference to prevent the controller from being deallocated prematurely
  private var documentInteractionController: UIDocumentInteractionController?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController

    // 1) Wi-Fi channel  (equivalent of WIFI_CHANNEL on Android)
    let wifiChannel = FlutterMethodChannel(
      name: wifiChannelName,
      binaryMessenger: controller.binaryMessenger
    )
    wifiChannel.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "openWifiSettings":
        self?.openWifiSettings()
        result("Opened Wi-Fi settings")
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    // 2) File (vCard) channel  (equivalent of FILE_CHANNEL on Android)
    let fileChannel = FlutterMethodChannel(
      name: fileChannelName,
      binaryMessenger: controller.binaryMessenger
    )
    fileChannel.setMethodCallHandler { [weak self] (call, result) in
      guard call.method == "getFileUri" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard
        let args = call.arguments as? [String: Any],
        let path = args["path"] as? String
      else {
        result(FlutterError(code: "INVALID_PATH", message: "File path is null", details: nil))
        return
      }
      self?.openFile(path: path, result: result)
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - Wi-Fi settings
  private func openWifiSettings() {
    // There is no official API on iOS to open Wi-Fi settings directly.
    // The safest (App Store-accepted) approach is to open the app's own settings page.
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }

  // MARK: - Open vCard file (for importing a contact)
  private func openFile(path: String, result: @escaping FlutterResult) {
    guard FileManager.default.fileExists(atPath: path) else {
      result(FlutterError(code: "FILE_NOT_FOUND",
                          message: "No file found at the given path",
                          details: path))
      return
    }

    let fileURL = URL(fileURLWithPath: path)
    let docController = UIDocumentInteractionController(url: fileURL)
    docController.delegate = self
    docController.uti = "public.vcard"          // vCard file type
    self.documentInteractionController = docController

    // Try preview first (QuickLook): shows the contact and offers "Add to Contacts"
    let opened = docController.presentPreview(animated: true)
    if !opened, let rootView = window?.rootViewController?.view {
      // If preview fails to open — fall back to the share (options) menu
      docController.presentOptionsMenu(from: rootView.bounds, in: rootView, animated: true)
    }

    result(fileURL.absoluteString)
  }
}

// MARK: - UIDocumentInteractionControllerDelegate
extension AppDelegate: UIDocumentInteractionControllerDelegate {
  func documentInteractionControllerViewControllerForPreview(
    _ controller: UIDocumentInteractionController
  ) -> UIViewController {
    return window!.rootViewController!
  }
}