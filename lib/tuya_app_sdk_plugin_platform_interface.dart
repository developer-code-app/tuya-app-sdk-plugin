import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tuya_app_sdk_plugin_method_channel.dart';

abstract class TuyaAppSdkPluginPlatform extends PlatformInterface {
  /// Constructs a TuyaAppSdkPluginPlatform.
  TuyaAppSdkPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static TuyaAppSdkPluginPlatform _instance = MethodChannelTuyaAppSdkPlugin();

  /// The default instance of [TuyaAppSdkPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelTuyaAppSdkPlugin].
  static TuyaAppSdkPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TuyaAppSdkPluginPlatform] when
  /// they register themselves.
  static set instance(TuyaAppSdkPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> loginWithTicket({required String ticket}) async {
    throw UnimplementedError('loginWithTicket() has not been implemented.');
  }

  Future<void> logout() async {
    throw UnimplementedError('logout() has not been implemented.');
  }

  Future<void> pairingDeviceAPMode({
    required String ssid,
    required String password,
    required String token,
  }) async {
    throw UnimplementedError(
      'pairingDeviceAPMode() has not been implemented.',
    );
  }
}
