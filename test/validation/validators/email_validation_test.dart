import 'package:test/test.dart';

import 'package:for_dev/validation/validators/validators.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation(field: 'any_field');
  });

  test('should return null if email is empty', () async {
    // act
    final error = sut.validate('');
    // assert
    expect(error, null);
  });

  test('should return null if email is null', () async {
    // act
    final error = sut.validate(null);
    // assert
    expect(error, null);
  });

  test('should return null if email is valid', () async {
    // act
    final error = sut.validate('welliton.fokushima@gmail.com');
    // assert
    expect(error, null);
  });

  test('should return null if email is invalid', () async {
    // act
    final error = sut.validate('welliton.fokushima');
    // assert
    expect(error, 'Campo inválido.');
  });
}
