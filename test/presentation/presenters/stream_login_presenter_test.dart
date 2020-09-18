import 'dart:async';

import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

abstract class IValidation {
  String validate({
    @required String field,
    @required String value,
  });
}

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

class ValidationSpy extends Mock implements IValidation {}

void main() {
  ValidationSpy validation;
  StreamLoginPresenter sut;
  String email;

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
  });

  test('should call Validation with correct email', () async {
    // act
    sut.validateEmail(email);

    // assert
    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('should emit email error if validation fails', () async {
    // arrange
    when(validation.validate(
      field: anyNamed('field'),
      value: anyNamed('value'),
    )).thenReturn('error');

    // assert
    expectLater(sut.emailErrorStream, emits('error'));

    // act
    sut.validateEmail(email);
  });
}
