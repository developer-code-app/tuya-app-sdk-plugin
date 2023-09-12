import 'package:flutter_test/flutter_test.dart';
import 'package:tuya_app_sdk_plugin/tuya_app_sdk_plugin.dart';
import 'package:tuya_app_sdk_plugin/tuya_app_sdk_plugin_platform_interface.dart';
import 'package:tuya_app_sdk_plugin/tuya_app_sdk_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTuyaAppSdkPluginPlatform
    with MockPlatformInterfaceMixin
    implements TuyaAppSdkPluginPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> loginWithTicket({required String ticket}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<void> pairingDeviceAPMode({
    required String ssid,
    required String password,
    required String token,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  final TuyaAppSdkPluginPlatform initialPlatform =
      TuyaAppSdkPluginPlatform.instance;

  test('$MethodChannelTuyaAppSdkPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTuyaAppSdkPlugin>());
  });

  test('getPlatformVersion', () async {
    MockTuyaAppSdkPluginPlatform fakePlatform = MockTuyaAppSdkPluginPlatform();
    TuyaAppSdkPluginPlatform.instance = fakePlatform;

    expect(await TuyaAppSdkPlugin.getPlatformVersion(), '42');
  });
}
