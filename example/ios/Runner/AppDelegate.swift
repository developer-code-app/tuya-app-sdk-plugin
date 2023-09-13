import UIKit
import Flutter
import ThingSmartBaseKit
import ThingSmartDeviceKit
import ThingSmartActivatorKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    ThingSmartSDK.sharedInstance().start(
      withAppKey: AppKey.appKey,
      secretKey: AppKey.secretKey
    )
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
