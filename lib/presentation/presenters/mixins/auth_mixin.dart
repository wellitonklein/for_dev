import 'package:get/get.dart';

import '../../../ui/helpers/helpers.dart';

mixin AuthMixin on GetxController {
  String _email;
  String _password;

  var _emailError = Rx<UIError>();
  String get email => _email;
  set email(String value) => _email = value;

  var _passwordError = Rx<UIError>();
  String get password => _password;
  set password(String value) => _password = value;

  Stream<UIError> get emailErrorStream => _emailError.stream;
  set emailError(UIError value) => _emailError.value = value;
  UIError get emailError => _emailError.value;

  Stream<UIError> get passwordErrorStream => _passwordError.stream;
  set passwordError(UIError value) => _passwordError.value = value;
  UIError get passwordError => _passwordError.value;
}
