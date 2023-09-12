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
}

void main() {
  final TuyaAppSdkPluginPlatform initialPlatform = TuyaAppSdkPluginPlatform.instance;

  test('$MethodChannelTuyaAppSdkPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTuyaAppSdkPlugin>());
  });

  test('getPlatformVersion', () async {
    TuyaAppSdkPlugin tuyaAppSdkPlugin = TuyaAppSdkPlugin();
    MockTuyaAppSdkPluginPlatform fakePlatform = MockTuyaAppSdkPluginPlatform();
    TuyaAppSdkPluginPlatform.instance = fakePlatform;

    expect(await tuyaAppSdkPlugin.getPlatformVersion(), '42');
  });
}
