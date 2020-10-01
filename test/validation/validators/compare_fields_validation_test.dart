import 'package:test/test.dart';

import 'package:for_dev/presentation/dependencies/dependencies.dart';
import 'package:for_dev/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
      field: 'any_field',
      valueToCompare: 'any_value',
    );
  });

  test('should return error if values are not equal', () async {
    // act
    final error = sut.validate('wrong_value');
    // assert
    expect(error, ValidationError.invalidField);
  });

  test('should return null if values are equal', () async {
    // act
    final error = sut.validate('any_value');
    // assert
    expect(error, null);
  });
}
