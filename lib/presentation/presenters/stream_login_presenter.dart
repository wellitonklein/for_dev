import 'dart:async';

import 'package:meta/meta.dart';

import '../../domain/usecases/authentication_interface.dart';
import '../dependencies/dependencies.dart';

class LoginState {
  String email;
  String password;
  String emailError;
  String passwordError;
  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
}

class StreamLoginPresenter {
  final IValidation validation;
  final IAuthentication authentication;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  StreamLoginPresenter({
    @required this.validation,
    @required this.authentication,
  });

  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();
  Stream<String> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();
  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  void _update() => _controller.add(_state);

  void validateEmail(String value) {
    _state.email = value;
    _state.emailError = validation.validate(field: 'email', value: value);
    _update();
  }

  void validatePassword(String value) {
    _state.password = value;
    _state.passwordError = validation.validate(field: 'password', value: value);
    _update();
  }

  Future<void> auth() async {
    await authentication.auth(
        params: AuthenticationParams(
      email: _state.email,
      secret: _state.password,
    ));
  }
}
