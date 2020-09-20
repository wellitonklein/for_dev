import 'package:meta/meta.dart';

import '../../presentation/dependencies/dependencies.dart';
import '../dependencies/dependencies.dart';

class ValidationComposite implements IValidation {
  final List<IFieldValidation> validations;

  ValidationComposite({@required this.validations});

  String validate({String field, String value}) {
    String error;

    for (final validation in validations.where((v) => v.field == field)) {
      error = validation.validate(value);

      if (error?.isNotEmpty == true) {
        return error;
      }
    }

    return error;
  }
}
