import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ActionSheet {
  ActionSheet({
    required this.actions,
    this.cancel,
    this.title,
    this.message,
  });

  final String? title;
  final String? message;
  final List<Action> actions;
  final Action? cancel;

  void show(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      _showSimpleDialogForAndroid(context);
    } else {
      _showActionSheetForIOS(context);
    }
  }

  void _showSimpleDialogForAndroid(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Column(
          children: [
            if (title != null)
              Text(
                title ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ]
          ],
        ),
        children: [
          ...actions.map((action) {
            return SimpleDialogOption(
              onPressed: () {
                action.execute();
                Navigator.pop(context, true);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  action.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: action.style ??
                      const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                ),
              ),
            );
          })
        ],
      ),
    ).then((isActionPressed) {
      if (isActionPressed != true) {
        cancel?.execute();
      }
    });
  }

  void _showActionSheetForIOS(BuildContext context) {
    final cancel = this.cancel;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: title == null
            ? null
            : Text(
                title ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
        message: message == null
            ? null
            : Text(
                message ?? '',
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
        actions: [
          ...actions.map(
            (action) {
              return CupertinoActionSheetAction(
                onPressed: () {
                  action.execute();
                  Navigator.pop(context);
                },
                child: Text(
                  action.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              );
            },
          ),
        ],
        cancelButton: (cancel != null)
            ? CupertinoActionSheetAction(
                onPressed: () {
                  cancel.execute();
                  Navigator.pop(context);
                },
                child: Text(
                  cancel.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class Action {
  Action(
    this.title,
    this.execute, {
    this.style,
  });

  final TextStyle? style;
  final String title;
  final Function() execute;
}
