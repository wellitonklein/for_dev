import 'package:meta/meta.dart';

import '../dependencies/dependencies.dart';

class EmailValidation implements IFieldValidation {
  final String field;

  EmailValidation({@required this.field});

  @override
  String validate(String value) {
    final regex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);
    return !isValid ? 'Campo inválido.' : null;
  }
}
