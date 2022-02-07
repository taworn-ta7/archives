import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'logic.dart';
import 'ui.dart';
import 'app.dart';

/// Main program.
void main() {
  // initialize localization
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  if (Constants.useStartLocale) {
    LocaleSettings.setLocaleRaw(Constants.startLocale);
  }

  // initialize logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(
    // ignore: avoid_print
    (record) => print(
      '${record.time} ${record.level.name.padRight(7)} ${record.loggerName.padRight(12).characters.take(12)} ${record.message}',
    ),
  );

  // run app
  runApp(TranslationProvider(child: const App()));
}
