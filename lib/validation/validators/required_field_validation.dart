import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../presentation/dependencies/dependencies.dart';
import '../dependencies/dependencies.dart';

class RequiredFieldValidation extends Equatable implements IFieldValidation {
  final String field;

  RequiredFieldValidation({@required this.field});

  @override
  ValidationError validate(Map input) {
    return input[field]?.isNotEmpty == true
        ? null
        : ValidationError.requiredField;
  }

  @override
  List<Object> get props => [field];
}
