import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../presentation/dependencies/dependencies.dart';
import '../dependencies/dependencies.dart';

class CompareFieldsValidation extends Equatable implements IFieldValidation {
  final String field;
  final String fieldToCompare;

  CompareFieldsValidation({
    @required this.field,
    @required this.fieldToCompare,
  });

  ValidationError validate(Map input) => input[field] != null &&
          input[fieldToCompare] != null &&
          input[field] != input[fieldToCompare]
      ? ValidationError.invalidField
      : null;

  @override
  List<Object> get props => [field, fieldToCompare];
}
