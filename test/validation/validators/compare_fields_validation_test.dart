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

  test('should return error if value is not equal', () async {
    // act
    final error = sut.validate('wrong_value');
    // assert
    expect(error, ValidationError.invalidField);
  });
}
