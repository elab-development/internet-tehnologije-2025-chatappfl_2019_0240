// filepath: apps/mobile_app/lib/utils/string_utils.dart

/// Simple string utilities used in unit tests.
String capitalize(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}
