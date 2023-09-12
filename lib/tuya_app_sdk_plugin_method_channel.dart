import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tuya_app_sdk_plugin_platform_interface.dart';

/// An implementation of [TuyaAppSdkPluginPlatform] that uses method channels.
class MethodChannelTuyaAppSdkPlugin extends TuyaAppSdkPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tuya_app_sdk_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
