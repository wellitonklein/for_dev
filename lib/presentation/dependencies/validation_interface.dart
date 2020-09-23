import 'package:meta/meta.dart';

abstract class IValidation {
  ValidationError validate({
    @required String field,
    @required String value,
  });
}

enum ValidationError {
  requiredField,
  invalidField,
}
