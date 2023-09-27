import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tuya_app_sdk_plugin/tuya_options.dart';

import 'tuya_app_sdk_plugin_platform_interface.dart';

/// An implementation of [TuyaAppSdkPluginPlatform] that uses method channels.
class MethodChannelTuyaAppSdkPlugin extends TuyaAppSdkPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tuya_app_sdk_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> initializeApp({required TuyaOptions options}) async {
    final argument = {
      "app_key": options.appKey,
      "secret_key": options.secretKey,
    };

    return await methodChannel.invokeMethod('initializeApp', argument);
  }

  @override
  Future<void> loginWithTicket({required String ticket}) async {
    final argument = {
      'ticket': ticket,
    };

    return await methodChannel.invokeMethod(
      'loginWithTicket',
      argument,
    );
  }

  @override
  Future<void> pairingDeviceAPMode({
    required String ssid,
    required String password,
    required String token,
  }) async {
    final argument = {
      'ssid': ssid,
      'password': password,
      'token': token,
    };

    return await methodChannel.invokeMethod(
      'pairingDeviceAPMode',
      argument,
    );
  }
}
