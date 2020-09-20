import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/validation/dependencies/dependencies.dart';

class EmailValidation implements IFieldValidation {
  final String field;

  EmailValidation({@required this.field});

  @override
  String validate(String value) {
    return null;
  }
}

void main() {
  test('should return null if email is empty', () async {
    // arrange
    final sut = EmailValidation(field: 'any_field');
    // act
    final error = sut.validate('');
    // assert
    expect(error, null);
  });

  test('should return null if email is null', () async {
    // arrange
    final sut = EmailValidation(field: 'any_field');
    // act
    final error = sut.validate(null);
    // assert
    expect(error, null);
  });
}
