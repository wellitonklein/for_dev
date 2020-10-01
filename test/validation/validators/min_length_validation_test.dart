import 'package:faker/faker.dart';
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
    if (value?.isNotEmpty == true && value != null && value.length >= length) {
      return null;
    }

    return ValidationError.invalidField;
  }
}

void main() {
  MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', length: 5);
  });

  test('should return error if value is empty', () async {
    // act
    final error = sut.validate('');
    // assert
    expect(error, ValidationError.invalidField);
  });

  test('should return error if value is null', () async {
    // act
    final error = sut.validate(null);
    // assert
    expect(error, ValidationError.invalidField);
  });

  test('should return error if value is less than min length', () async {
    // act
    final error = sut.validate(faker.randomGenerator.string(4, min: 1));
    // assert
    expect(error, ValidationError.invalidField);
  });

  test('should return error if value is equal than min length', () async {
    // act
    final error = sut.validate(faker.randomGenerator.string(5, min: 5));
    // assert
    expect(error, null);
  });
}
