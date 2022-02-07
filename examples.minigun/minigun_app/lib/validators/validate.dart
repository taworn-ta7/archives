export 'validators.dart';
export 'sanitizers.dart';

String? validate(
  bool Function() validator,
  String errorMessage,
) {
  return validator() ? null : errorMessage;
}
