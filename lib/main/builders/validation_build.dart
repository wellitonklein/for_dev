import '../../validation/dependencies/dependencies.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  static ValidationBuilder _instance;
  String fieldName;
  List<IFieldValidation> validations = [];

  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder();
    _instance.fieldName = fieldName;
    return _instance;
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(field: fieldName));
    return this;
  }

  ValidationBuilder email() {
    validations.add(EmailValidation(field: fieldName));
    return this;
  }

  List<IFieldValidation> build() => validations;
}
