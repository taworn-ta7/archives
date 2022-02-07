import 'package:decimal/decimal.dart';
import 'package:validators/sanitizers.dart' as sanitizers;

class Sanitizers {
  static int toIntOrDefault(
    String value, {
    int radix = 10,
    int defaultValue = 0,
  }) {
    var v = sanitizers.toInt(value, radix: radix);
    if (!v.isFinite) v = defaultValue;
    return v.toInt();
  }

  // ----------------------------------------------------------------------

  static Decimal toMoneyOrDefault(
    String value,
  ) {
    var v = Decimal.tryParse(value);
    if (v == null) return Decimal.parse('0');
    return v;
  }
}
