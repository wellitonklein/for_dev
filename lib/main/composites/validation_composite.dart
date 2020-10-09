import 'package:meta/meta.dart';

import '../../presentation/dependencies/dependencies.dart';
import '../../validation/dependencies/dependencies.dart';

class ValidationComposite implements IValidation {
  final List<IFieldValidation> validations;

  ValidationComposite({@required this.validations});

  ValidationError validate({String field, Map input}) {
    ValidationError error;

    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(input);

      if (error != null) {
        return error;
      }
    }

    return error;
  }
}
