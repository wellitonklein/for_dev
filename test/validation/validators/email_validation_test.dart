import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/validation/dependencies/dependencies.dart';

class EmailValidation implements IFieldValidation {
  final String field;

  EmailValidation({@required this.field});

  @override
  String validate(String value) {
    final regex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);
    return !isValid ? 'Campo inválido.' : null;
  }
}

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
