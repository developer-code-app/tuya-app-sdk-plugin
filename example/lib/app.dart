import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuya_app_sdk_plugin_example/action_sheet.dart' as action_sheet;
import 'package:tuya_app_sdk_plugin_example/cubit/alert_dialog_cubit.dart';
import 'package:tuya_app_sdk_plugin_example/cubit/ui_blocking_cubit.dart';
import 'package:tuya_app_sdk_plugin_example/extensions/alert_dialog_convenience_showing.dart';
import 'package:tuya_app_sdk_plugin_example/pages/login_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocListener(
        listeners: [
          BlocListener<AlertDialogCubit, AlertData?>(
            listener: (context, state) {
              if (state == null) return;
              _showAlertFromData(context, data: state);
            },
          ),
        ],
        child: MultiBlocProvider(
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

  void _showAlertFromData(
    BuildContext context, {
    required AlertData data,
  }) {
    if (data is DialogData) {
      AlertDialogConvenienceShowing.showAlertDialog(
        context: context,
        title: data.title,
        message: data.message,
        remark: data.remark,
        actions: data.actions,
        onDismissed: data.onDismissed,
        dismissible: data.dismissible,
      );
    } else if (data is ActionSheetData) {
      action_sheet.ActionSheet(
        title: data.title,
        message: data.message,
        actions: data.actions
            .map(
              (action) => action_sheet.Action(
                action.title,
                () => action.onPressed?.call(),
                style: action.style,
              ),
            )
            .toList(),
        cancel: action_sheet.Action(
          data.cancelAction.title,
          () => data.cancelAction.onPressed?.call(),
        ),
      ).show(context);
    }
  }
}
