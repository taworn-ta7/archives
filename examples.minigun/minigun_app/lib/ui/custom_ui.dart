import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';
import '../widgets/message_box.dart';

class CustomUi {
  static TextStyle titleTextStyle = const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static Future<bool> beforeBack(
    BuildContext context,
    bool changed,
  ) async {
    if (changed) {
      final answer = await MessageBox.question(
        context,
        t.question.areYouSureToLeave,
        MessageBoxOptions(
          button0Negative: true,
        ),
      );
      return answer == true;
    } else {
      return true;
    }
  }
}
