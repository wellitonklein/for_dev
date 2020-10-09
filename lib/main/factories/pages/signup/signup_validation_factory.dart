import '../../../../presentation/dependencies/dependencies.dart';
import '../../../../validation/dependencies/dependencies.dart';
import '../../../builders/builders.dart';
import '../../../composites/composites.dart';

IValidation makeSignUpValidation() {
  return ValidationComposite(validations: makeSignUpValidations());
}

List<IFieldValidation> makeSignUpValidations() {
  return [
    ...ValidationBuilder.field('name').required().min(3).build(),
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
    ...ValidationBuilder.field('passwordConfirmation')
        .required()
        .sameAs('password')
        .build(),
  ];
}
