import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/presentation/dependencies/dependencies.dart';
import 'package:for_dev/validation/dependencies/dependencies.dart';

class ValidationComposite implements IValidation {
  final List<IFieldValidation> validations;

  ValidationComposite({@required this.validations});

  String validate({String field, String value}) {
    return null;
  }
}

class FieldValidationSpy extends Mock implements IFieldValidation {}

void main() {
  test('should return null if all validations returns null or empty', () async {
    // arrange
    final validation1 = FieldValidationSpy();
    when(validation1.field).thenReturn('any_field');
    when(validation1.validate(any)).thenReturn(null);
    final validation2 = FieldValidationSpy();
    when(validation2.field).thenReturn('any_field');
    when(validation2.validate(any)).thenReturn('');
    final sut = ValidationComposite(validations: [
      validation1,
      validation2,
    ]);
    // act
    final error = sut.validate(field: 'any_field', value: 'any_value');
    // assert
    expect(error, null);
  });
}
