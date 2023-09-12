import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuya_app_sdk_plugin_example/extensions/alert_dialog_convenience_showing.dart';

class AlertDialogCubit extends Cubit<AlertData?> {
  AlertDialogCubit() : super(null);

  void errorAlert({
    required Exception error,
    String? title,
    bool? dismissible,
  }) {
    return alert(
      title: title ?? 'Error',
      message: error.toString(),
      dismissible: dismissible,
    );
  }

  void errorSnackBar(Exception error) {
    snackBar(title: error.toString());
  }

  void alert({
    String? title,
    String? message,
    String? remark,
    List<AlertAction>? actions,
    Function()? onDismissed,
    bool? dismissible,
  }) {
    return emit(
      DialogData(
        title: title,
        message: message,
        remark: remark,
        actions: actions ?? [_buildOKAlertAction()],
        onDismissed: onDismissed,
        dismissible: dismissible,
      ),
    );
  }

  void alertActionSheet({
    required List<AlertAction> actions,
    String? title,
    String? message,
    AlertAction? cancelAction,
  }) {
    return emit(
      ActionSheetData(
        title: title,
        message: message,
        cancelAction: cancelAction ?? _buildCancelAlertAction(),
        actions: actions,
      ),
    );
  }

  void snackBar({
    required String title,
    Widget? prefixIcon,
    AlertAction? action,
  }) {
    return emit(
      SnackBarData(
        title: title,
        prefixIcon: prefixIcon,
        action: action,
      ),
    );
  }

  void dismiss() => emit(null);

  AlertAction _buildOKAlertAction() {
    return AlertAction(
      'OK',
      onPressed: dismiss,
    );
  }

  AlertAction _buildCancelAlertAction() {
    return AlertAction(
      'Cancel',
      onPressed: () {
        dismiss.call();
      },
    );
  }
}

abstract class AlertData {}

class DialogData extends AlertData {
  DialogData({
    required this.actions,
    this.title,
    this.message,
    this.remark,
    this.onDismissed,
    this.dismissible,
  });

  final String? title;
  final String? message;
  final String? remark;
  final List<AlertAction> actions;
  final Function()? onDismissed;
  final bool? dismissible;
}

class ActionSheetData extends AlertData {
  ActionSheetData({
    required this.actions,
    required this.cancelAction,
    this.title,
    this.message,
  });

  final String? title;
  final String? message;
  final AlertAction cancelAction;
  final List<AlertAction> actions;
}

class SnackBarData extends AlertData {
  SnackBarData({
    required this.title,
    this.prefixIcon,
    this.action,
  });

  final String title;
  final Widget? prefixIcon;
  final AlertAction? action;
}
