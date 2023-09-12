import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuya_app_sdk_plugin_example/cubit/ui_blocking_cubit.dart';
import 'package:tuya_app_sdk_plugin_example/widget/loading_indicator_widget.dart';

class LoadingWithBlockingWidget extends StatelessWidget {
  const LoadingWithBlockingWidget({
    required this.child,
    this.showLoadingLabel = true,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final bool showLoadingLabel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UIBlockingCubit, bool>(
      builder: (context, isBlocked) {
        return IgnorePointer(
          ignoring: isBlocked,
          child: Stack(
            children: [
              child,
              Visibility(
                visible: isBlocked,
                child: LoadingIndicator(
                  showLoadingLabel: showLoadingLabel,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
