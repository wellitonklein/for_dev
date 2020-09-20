import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/presentation/dependencies/dependencies.dart';
import 'package:for_dev/presentation/presenters/presenters.dart';

class ValidationSpy extends Mock implements IValidation {}

void main() {
  ValidationSpy validation;
  StreamLoginPresenter sut;
  String email;
  String password;
  final messageError = 'error';

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
    password = faker.internet.password();
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
    mockValidation(value: messageError);

    // assert
    sut.emailErrorStream.listen(
      expectAsync1((error) => expect(error, messageError)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    // act
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('should emit null if validation succes', () async {
    // assert
    sut.emailErrorStream.listen(
      expectAsync1((error) => expect(error, null)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    // act
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('should call Validation with correct password', () async {
    // act
    sut.validatePassword(password);

    // assert
    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('should emit password error if validation fails', () async {
    // arrange
    mockValidation(value: messageError);

    // assert
    sut.passwordErrorStream.listen(
      expectAsync1((error) => expect(error, messageError)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    // act
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('should emit null if validation succes', () async {
    // assert
    sut.passwordErrorStream.listen(
      expectAsync1((error) => expect(error, null)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    // act
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('should emit null if validation succes', () async {
    // arrange
    mockValidation(field: 'email', value: messageError);

    // assert
    sut.emailErrorStream.listen(
      expectAsync1((error) => expect(error, messageError)),
    );
    sut.passwordErrorStream.listen(
      expectAsync1((error) => expect(error, null)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    // act
    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('should emit null if validation succes', () async {
    // assert
    sut.emailErrorStream.listen(
      expectAsync1((error) => expect(error, null)),
    );
    sut.passwordErrorStream.listen(
      expectAsync1((error) => expect(error, null)),
    );
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    // act
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });
}
