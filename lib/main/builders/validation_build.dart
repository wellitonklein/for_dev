import '../../validation/dependencies/dependencies.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {
  static ValidationBuilder _instance;
  String fieldName;
  List<IFieldValidation> validations = [];

  ValidationBuilder._();

  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder._();
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

  ValidationBuilder min(int length) {
    validations.add(MinLengthValidation(field: fieldName, length: length));
    return this;
  }

  List<IFieldValidation> build() => validations;
}
