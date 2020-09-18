import 'dart:async';

import 'package:meta/meta.dart';

import '../dependencies/dependencies.dart';

class LoginState {
  String emailError;
}

class StreamLoginPresenter {
  final IValidation validation;
  final _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  StreamLoginPresenter({
    @required this.validation,
  });

  Stream<String> get emailErrorStream =>
      _controller.stream.map((state) => state.emailError);

  void validateEmail(String value) {
    _state.emailError = validation.validate(field: 'email', value: value);
    _controller.add(_state);
  }
}