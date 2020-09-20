import 'dart:async';

import 'package:meta/meta.dart';

import '../dependencies/dependencies.dart';

class LoginState {
  String emailError;
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
  Stream<bool> get isFormValidStream =>
      _controller.stream.map((state) => state.isFormValid).distinct();

  void validateEmail(String value) {
    _state.emailError = validation.validate(field: 'email', value: value);
    _controller.add(_state);
  }

  void validatePassword(String value) {
    validation.validate(field: 'password', value: value);
  }
}
