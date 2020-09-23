import 'package:test/test.dart';

import 'package:for_dev/presentation/dependencies/dependencies.dart';
import 'package:for_dev/validation/validators/validators.dart';

void main() {
  RequiredFieldValidation sut;
  setUp(() {
    sut = RequiredFieldValidation(field: 'any_field');
  });

  test('should return null if value is not empty', () async {
    // act
    final error = sut.validate('any_value');
    // assert
    expect(error, null);
  });

  test('should return error if value is empty', () async {
    // act
    final error = sut.validate('');
    // assert
    expect(error, ValidationError.requiredField);
  });

  test('should return error if value is null', () async {
    // act
    final error = sut.validate(null);
    // assert
    expect(error, ValidationError.requiredField);
  });
}
