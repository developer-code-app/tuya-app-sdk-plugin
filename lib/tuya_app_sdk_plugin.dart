import 'tuya_app_sdk_plugin_platform_interface.dart';

class TuyaAppSdkPlugin {
  static Future<String?> getPlatformVersion() {
    return TuyaAppSdkPluginPlatform.instance.getPlatformVersion();
  }

  static Future<void> loginWithTicket({required String ticket}) async {
    return TuyaAppSdkPluginPlatform.instance.loginWithTicket(
      ticket: ticket,
    );
  }

  static Future<void> pairingDeviceAPMode({
    required String ssid,
    required String password,
    required String token,
  }) async {
    return TuyaAppSdkPluginPlatform.instance.pairingDeviceAPMode(
      ssid: ssid,
      password: password,
      token: token,
    );
  }
}
