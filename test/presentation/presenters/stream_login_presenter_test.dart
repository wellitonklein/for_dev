import 'dart:async';

import 'package:faker/faker.dart';
import 'package:for_dev/presentation/dependencies/validation_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

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

  PostExpectation mockValidationCall(String field) => when(
        validation.validate(
          field: field == null ? anyNamed('field') : field,
          value: anyNamed('value'),
        ),
      );

  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
    mockValidation();
  });

  test('should call Validation with correct email', () async {
    // act
    sut.validateEmail(email);

    // assert
    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('should emit email error if validation fails', () async {
    // arrange
    mockValidation(value: 'error');

    // assert
    expectLater(sut.emailErrorStream, emits('error'));

    // act
    sut.validateEmail(email);
  });
}
