import '../../../../presentation/dependencies/dependencies.dart';
import '../../../../validation/validators/validators.dart';

IValidation makeLoginValidation() {
  return ValidationComposite(validations: [
    RequiredFieldValidation(field: 'email'),
    EmailValidation(field: 'email'),
    RequiredFieldValidation(field: 'password'),
  ]);
}
