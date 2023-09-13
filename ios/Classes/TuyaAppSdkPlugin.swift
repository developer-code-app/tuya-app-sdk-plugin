import Flutter
import UIKit
import ThingSmartBaseKit
import ThingSmartDeviceKit
import ThingSmartActivatorKit

public class TuyaAppSdkPlugin: NSObject, FlutterPlugin, ThingSmartActivatorDelegate {
  let tuyaActivator = ThingSmartActivator()
  var pairingResult: FlutterResult?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "tuya_app_sdk_plugin", binaryMessenger: registrar.messenger())
    let instance = TuyaAppSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "loginWithTicket":
      loginWithTicket(call, result: result)
    case "pairingDeviceAPMode":
      pairingDeviceAPMode(call, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func loginWithTicket(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard
      let args = call.arguments as? Dictionary<String, Any>,
      let ticket = args["ticket"] as? String
    else {
      let flutterError = FlutterError(
        code: "ARGUMENTS_ERROR",
        message: "Arguments missing.",
        details: nil
      );

      return result(flutterError)
    }

    ThingSmartUser.sharedInstance().login(
      withTicket: ticket,
      success: {
        result("SUCCESS")
      }, failure: { (error) in
        let flutterError = FlutterError(
          code: "LOGIN_ERROR",
          message: error?.localizedDescription,
          details: nil
        );
  
        result(flutterError)
    })
  }

  private func pairingDeviceAPMode(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard
      let args = call.arguments as? Dictionary<String, Any>,
      let ssid = args["ssid"] as? String,
      let password = args["password"] as? String,
      let token = args["token"] as? String,
      let timeout = args["time_out"] as? Int?
    else {
      let flutterError = FlutterError(
        code: "ARGUMENTS_ERROR",
        message: "Arguments missing.",
        details: nil
      );

      return result(flutterError)      
    }
     
    self.pairingResult = result

    self.tuyaActivator.delegate = self
    self.tuyaActivator.startConfigWiFi(
      .AP,
      ssid: ssid,
      password: password,
      token: token,
      timeout: TimeInterval(timeout ?? 60)
    )
  }

  public func activator(
    _ activator: ThingSmartActivator!,
    didReceiveDevice deviceModel: ThingSmartDeviceModel!,
    error: Error!
  ) {
    if deviceModel != nil && error == nil {
      pairingResult?("SUCCESS")
    }
              
    if let error = error {
      let flutterError = FlutterError(
        code: "PAIRING_ERROR",
        message: error.localizedDescription,
        details: nil
      );
    
      pairingResult?(flutterError)
    }
  }
}
