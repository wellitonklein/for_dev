import 'dart:async';

import 'package:meta/meta.dart';

import '../dependencies/dependencies.dart';

class LoginState {
  String emailError;
  String passwordError;
  bool get isFormValid => false;
}

class StreamLoginPresenter {
  final IValidation validation;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  StreamLoginPresenter({
    @required this.validation,
  });

  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError).distinct();
  Stream<String> get passwordErrorStream =>
      _controller.stream.map((state) => state.passwordError).distinct();
  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  void _update() => _controller.add(_state);

  void validateEmail(String value) {
    _state.emailError = validation.validate(field: 'email', value: value);
    _update();
  }

  void validatePassword(String value) {
    _state.passwordError = validation.validate(field: 'password', value: value);
    _update();
  }
}
