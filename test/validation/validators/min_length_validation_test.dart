import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:for_dev/presentation/dependencies/dependencies.dart';
import 'package:for_dev/validation/validators/validators.dart';

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

  test('should return error if value is bigger than min length', () async {
    // act
    final error = sut.validate(faker.randomGenerator.string(10, min: 6));
    // assert
    expect(error, null);
  });
}
