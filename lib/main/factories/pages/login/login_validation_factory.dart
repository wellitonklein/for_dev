import '../../../../presentation/dependencies/dependencies.dart';
import '../../../../validation/dependencies/dependencies.dart';
import '../../../../validation/validators/validators.dart';

IValidation makeLoginValidation() {
  return ValidationComposite(validations: makeLoginValidations());
}

List<IFieldValidation> makeLoginValidations() {
  return [
    RequiredFieldValidation(field: 'email'),
    EmailValidation(field: 'email'),
    RequiredFieldValidation(field: 'password'),
  ];
}
