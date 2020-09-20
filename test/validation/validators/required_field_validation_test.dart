import 'package:test/test.dart';
import 'package:meta/meta.dart';

abstract class IFieldValidation {
  String get field;
  String validate(String value);
}

class RequiredFieldValidation implements IFieldValidation {
  final String field;

  RequiredFieldValidation({@required this.field});

  @override
  String validate(String value) {
    return value?.isNotEmpty == true ? null : 'Campo obrigatório';
  }
}

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
    expect(error, 'Campo obrigatório');
  });

  test('should return error if value is null', () async {
    // act
    final error = sut.validate(null);
    // assert
    expect(error, 'Campo obrigatório');
  });
}
