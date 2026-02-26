// filepath: apps/mobile_app/test/unit/string_utils_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:chatapp_flutter/utils/string_utils.dart';

void main() {
  test('capitalize should capitalize first letter', () {
    expect(capitalize('hello'), 'Hello');
    expect(capitalize(''), '');
    expect(capitalize('a'), 'A');
  });
}
