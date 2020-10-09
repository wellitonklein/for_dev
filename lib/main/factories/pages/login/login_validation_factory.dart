import '../../../../presentation/dependencies/dependencies.dart';
import '../../../../validation/dependencies/dependencies.dart';
import '../../../builders/builders.dart';
import '../../../composites/composites.dart';

IValidation makeLoginValidation() {
  return ValidationComposite(validations: makeLoginValidations());
}

List<IFieldValidation> makeLoginValidations() {
  return [
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
  ];
}
