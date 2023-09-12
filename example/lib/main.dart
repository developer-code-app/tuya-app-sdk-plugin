import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tuya_app_sdk_plugin_example/app.dart';
import 'package:tuya_app_sdk_plugin_example/cubit/alert_dialog_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AlertDialogCubit>(
          create: (context) => AlertDialogCubit(),
        ),
      ],
      child: const App(),
    ),
  );
}
