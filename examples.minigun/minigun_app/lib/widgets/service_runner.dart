import 'package:flutter/material.dart';
import 'package:minigun_app/ui.dart';
import 'package:minigun_client_dart/minigun_client.dart';

/// Call service helper.
class ServiceRunner {
  static Future<bool> execute(
    BuildContext context,
    Future<MixResult> Function() task,
  ) async {
    while (true) {
      // run service(s) and wait
      final result = await WaitBox.show<MixResult>(context, task);
      if (result.isOk()) {
        return true;
      }

      // get error message
      late String message;
      if (result.error != null) {
        message = t.serviceRunner.message;
      } else {
        final locale = LocaleSettings.currentLocale.languageTag;
        message = result.rest?.error?.get(locale) ?? '';
      }

      // show question dialog box
      final answer = await MessageBox.show(
        context: context,
        message: message,
        caption: t.messageBox.warning,
        options: MessageBoxOptions(
          type: MessageBoxType.retryCancel,
          titleColor: Colors.orange,
          barrierDismissible: true,
          button1Negative: true,
        ),
      );
      if (answer == null || answer == false) {
        return false;
      }
    }
  }
}
