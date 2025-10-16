import Flutter
import UIKit
import flutter_downloader  // <-- Import flutter_downloader

// This function registers plugins for the background isolate
func registerPlugins(registry: FlutterPluginRegistry) {
  GeneratedPluginRegistrant.register(with: registry)
}

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register the callback for background isolate
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
    
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
