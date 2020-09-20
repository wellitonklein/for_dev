import 'package:mockito/mockito.dart';
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
    return null;
  }
}

void main() {
  test('should return null if value is not empty', () async {
    // arrange
    final sut = RequiredFieldValidation(field: 'any_field');
    // act
    final error = sut.validate('any_value');
    // assert
    expect(error, null);
  });
}
