import 'package:test/test.dart';

import 'package:for_dev/presentation/dependencies/dependencies.dart';
import 'package:for_dev/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
      field: 'any_field',
      fieldToCompare: 'other_field',
    );
  });

  test('should return null on invalid cases', () async {
    // assert
    expect(sut.validate({'any_field': 'any_value'}), null);
    expect(sut.validate({'other_field': 'any_value'}), null);
    expect(sut.validate({}), null);
  });

  test('should return error if values are not equal', () async {
    // arrange
    final formData = {'any_field': 'any_value', 'other_field': 'other_value'};
    // act
    final error = sut.validate(formData);
    // assert
    expect(error, ValidationError.invalidField);
  });

  test('should return null if values are equal', () async {
    // arrange
    final formData = {'any_field': 'any_value', 'other_field': 'any_value'};
    // act
    final error = sut.validate(formData);
    // assert
    expect(error, null);
  });
}
