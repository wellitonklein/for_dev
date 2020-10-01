import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../presentation/dependencies/dependencies.dart';
import '../dependencies/dependencies.dart';

class EmailValidation extends Equatable implements IFieldValidation {
  final String field;

  EmailValidation({@required this.field});

  @override
  ValidationError validate(Map input) {
    final regex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    final isValid =
        input[field]?.isNotEmpty != true || regex.hasMatch(input[field]);
    return !isValid ? ValidationError.invalidField : null;
  }

  @override
  List<Object> get props => [field];
}
