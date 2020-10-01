import 'package:test/test.dart';

import 'package:for_dev/main/factories/factories.dart';
import 'package:for_dev/validation/validators/validators.dart';

void main() {
  test('should return the correct validations', () async {
    final validations = makeSignUpValidations();

    expect(validations, [
      RequiredFieldValidation(field: 'name'),
      MinLengthValidation(field: 'name', length: 3),
      RequiredFieldValidation(field: 'email'),
      EmailValidation(field: 'email'),
      RequiredFieldValidation(field: 'password'),
      MinLengthValidation(field: 'password', length: 3),
      RequiredFieldValidation(field: 'passwordConfirmation'),
      CompareFieldsValidation(
        field: 'passwordConfirmation',
        fieldToCompare: 'password',
      )
    ]);
  });
}
