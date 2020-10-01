import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../presentation/dependencies/dependencies.dart';
import '../dependencies/dependencies.dart';

class CompareFieldsValidation extends Equatable implements IFieldValidation {
  final String field;
  final String valueToCompare;

  CompareFieldsValidation({
    @required this.field,
    @required this.valueToCompare,
  });

  ValidationError validate(String value) {
    return value == valueToCompare ? null : ValidationError.invalidField;
  }

  @override
  List<Object> get props => [field, valueToCompare];
}
