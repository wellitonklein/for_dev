import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/presentation/dependencies/dependencies.dart';
import 'package:for_dev/validation/dependencies/dependencies.dart';

class MinLengthValidation implements IFieldValidation {
  final String field;
  final int length;

  MinLengthValidation({
    @required this.field,
    @required this.length,
  });

  ValidationError validate(String value) {
    if (value?.isEmpty == true || value == null) {
      return ValidationError.invalidField;
    }

    return null;
  }
}

void main() {
  test('should return error if value is empty', () async {
    // arrange
    final sut = MinLengthValidation(field: 'any_field', length: 5);
    // act
    final error = sut.validate('');
    // assert
    expect(error, ValidationError.invalidField);
  });

  test('should return error if value is null', () async {
    // arrange
    final sut = MinLengthValidation(field: 'any_field', length: 5);
    // act
    final error = sut.validate(null);
    // assert
    expect(error, ValidationError.invalidField);
  });
}
