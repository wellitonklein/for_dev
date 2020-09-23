import '../../presentation/dependencies/dependencies.dart';

abstract class IFieldValidation {
  String get field;
  ValidationError validate(String value);
}
