import 'package:decimal/decimal.dart';

class Validators {
  static bool isPositiveOrZeroInt(String value) {
    final v = int.tryParse(value);
    if (v == null || v.isNaN || v.isInfinite || v.isNegative) {
      return false;
    }
    return true;
  }

  // ----------------------------------------------------------------------

  static bool isMoney(String value) {
    final v = Decimal.tryParse(value);
    if (v == null) {
      return false;
    }
    return true;
  }
}
