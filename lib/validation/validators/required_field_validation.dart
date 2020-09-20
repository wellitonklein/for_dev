import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../dependencies/dependencies.dart';

class RequiredFieldValidation extends Equatable implements IFieldValidation {
  final String field;

  RequiredFieldValidation({@required this.field});

  @override
  String validate(String value) {
    return value?.isNotEmpty == true ? null : 'Campo obrigatório';
  }

  @override
  List<Object> get props => [field];
}
