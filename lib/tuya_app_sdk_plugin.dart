
import 'tuya_app_sdk_plugin_platform_interface.dart';

class TuyaAppSdkPlugin {
  Future<String?> getPlatformVersion() {
    return TuyaAppSdkPluginPlatform.instance.getPlatformVersion();
  }
}
