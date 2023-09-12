import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuya_app_sdk_plugin_example/cubit/alert_dialog_cubit.dart';
import 'package:tuya_app_sdk_plugin_example/cubit/ui_blocking_cubit.dart';
import 'package:tuya_app_sdk_plugin_example/pages/home_page.dart';
import 'package:tuya_app_sdk_plugin_example/widget/loading_with_blocking_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ticketController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingWithBlockingWidget(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 48),
                TextField(
                  controller: ticketController,
                  decoration: const InputDecoration(labelText: 'Ticket'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  child: const Text('Login With Ticket'),
                  onPressed: () => _login(
                    context,
                    ticket: ticketController.text,
                  ),
                ),
                const Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context, {required String ticket}) async {
    final uiBlockingCubit = context.read<UIBlockingCubit>();
    final alertDialogCubit = context.read<AlertDialogCubit>();

    uiBlockingCubit.block();

    try {
      // TODO: bound api

      navigationToHomePage(context);
    } catch (error) {
      alertDialogCubit.alert(
        title: "Login Error",
        message: error.toString(),
      );
    } finally {
      uiBlockingCubit.unblock();
    }
  }

  void navigationToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<UIBlockingCubit>(
              create: (context) => UIBlockingCubit(),
            ),
          ],
          child: const HomePage(),
        ),
      ),
    );
  }
}
