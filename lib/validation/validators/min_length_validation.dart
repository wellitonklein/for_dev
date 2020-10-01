import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../presentation/dependencies/dependencies.dart';
import '../dependencies/dependencies.dart';

class MinLengthValidation extends Equatable implements IFieldValidation {
  final String field;
  final int length;

  MinLengthValidation({
    @required this.field,
    @required this.length,
  });

  ValidationError validate(String value) {
    if (value?.isNotEmpty == true && value != null && value.length >= length) {
      return null;
    }

    return ValidationError.invalidField;
  }

  @override
  List<Object> get props => [field, length];
}
