import 'package:meta/meta.dart';

import '../dependencies/dependencies.dart';

class RequiredFieldValidation implements IFieldValidation {
  final String field;

  RequiredFieldValidation({@required this.field});

  @override
  String validate(String value) {
    return value?.isNotEmpty == true ? null : 'Campo obrigatório';
  }
}
