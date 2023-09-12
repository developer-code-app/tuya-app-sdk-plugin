// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuya_app_sdk_plugin/tuya_app_sdk_plugin.dart';
import 'package:tuya_app_sdk_plugin_example/cubit/alert_dialog_cubit.dart';
import 'package:tuya_app_sdk_plugin_example/cubit/ui_blocking_cubit.dart';
import 'package:tuya_app_sdk_plugin_example/pages/login_page.dart';
import 'package:tuya_app_sdk_plugin_example/widget/loading_with_blocking_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ssidController = TextEditingController();
  final passwordController = TextEditingController();
  final tokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: LoadingWithBlockingWidget(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextField(
                  controller: ssidController,
                  decoration: const InputDecoration(labelText: 'ssid'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'password'),
                ),
                TextField(
                  controller: tokenController,
                  decoration: const InputDecoration(labelText: 'token'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  child: const Text('Device Pairing'),
                  onPressed: () => _pairingDeviceAPMode(
                    context,
                    ssid: ssidController.text,
                    password: passwordController.text,
                    token: tokenController.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Pair Device'),
      automaticallyImplyLeading: false,
      actions: [
        TextButton(
          child: const Text(
            'Log Out',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => _logout(context),
        )
      ],
    );
  }

  Future<void> _pairingDeviceAPMode(
    BuildContext context, {
    required String ssid,
    required String password,
    required String token,
  }) async {
    final uiBlockingCubit = context.read<UIBlockingCubit>();
    final alertDialogCubit = context.read<AlertDialogCubit>();

    uiBlockingCubit.block();

    try {
      await TuyaAppSdkPlugin.pairingDeviceAPMode(
        ssid: ssid,
        password: password,
        token: token,
      );

      alertDialogCubit.alert(title: "Pairing Device Success");
    } catch (error) {
      alertDialogCubit.alert(
        title: "Pairing Device Error",
        message: error.toString(),
      );
    } finally {
      uiBlockingCubit.unblock();
    }
  }

  Future<void> _logout(BuildContext context) async {
    final alertDialogCubit = context.read<AlertDialogCubit>();
    final uiBlockingCubit = context.read<UIBlockingCubit>();

    uiBlockingCubit.block();

    try {
      await TuyaAppSdkPlugin.logout();

      navigationToLoginPage(context);
    } on Exception catch (error) {
      alertDialogCubit.errorAlert(error: error);
    } finally {
      uiBlockingCubit.unblock();
    }
  }

  void navigationToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<UIBlockingCubit>(
              create: (context) => UIBlockingCubit(),
            ),
          ],
          child: const LoginPage(),
        ),
      ),
    );
  }
}
