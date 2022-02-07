import 'dart:typed_data';
import 'package:logging/logging.dart';
import 'package:logger/logger.dart' as debug_log;
import 'package:minigun_client_dart/minigun_client.dart';
import 'constants.dart';
export 'constants.dart';

class Logic {
  static final log = Logger('Logic');

  static Logic? _instance;

  static Logic instance() {
    _instance ??= Logic();
    return _instance!;
  }

  // ----------------------------------------------------------------------

  //
  // Debug Logger
  //

  final debugLog = debug_log.Logger(
    printer: debug_log.PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 4, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true, // Should each log print contain a timestamp
    ),
  );

  // ----------------------------------------------------------------------

  //
  // Service Call Client
  //

  final client = Client(baseUri: Constants.baseUri);

  User? user;
  Uint8List? profileIcon;

  void reset() {
    user = null;
    profileIcon = null;
  }

  // ----------------------------------------------------------------------

  //
  // Continue Session
  //

  bool continueSession = true;
}
