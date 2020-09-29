import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/presentation/dependencies/dependencies.dart';
import 'package:for_dev/presentation/presenters/presenters.dart';

import 'package:for_dev/ui/helpers/errors/errors.dart';

class ValidationSpy extends Mock implements IValidation {}

void main() {
  GetxSignUpPresenter sut;
  ValidationSpy validation;
  String email;
  String name;
  String password;
  String passwordConfirmation;

  PostExpectation mockValidationCall(String field) => when(
        validation.validate(
          field: field == null ? anyNamed('field') : field,
          value: anyNamed('value'),
        ),
      );

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = GetxSignUpPresenter(
      validation: validation,
    );
    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    mockValidation();
  });

  test('should call Validation with correct email', () async {
    // act
    sut.validateEmail(email);

    // assert
    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('should emit invalidFieldError if email is invalid', () async {
    // arrange
    mockValidation(value: ValidationError.invalidField);

    // assert
    sut.emailErrorStream.listen(
      expectAsync1((error) => expect(error, UIError.invalidField)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    // act
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('should emit requiredFieldError if email is empty', () async {
    // arrange
    mockValidation(value: ValidationError.requiredField);

    // assert
    sut.emailErrorStream.listen(
      expectAsync1((error) => expect(error, UIError.requiredField)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    // act
    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('should emit null if email validation succes', () async {
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

  test('should call Validation with correct name', () async {
    // act
    sut.validateName(name);

    // assert
    verify(validation.validate(field: 'name', value: name)).called(1);
  });

  test('should emit invalidFieldError if name is invalid', () async {
    // arrange
    mockValidation(value: ValidationError.invalidField);

    // assert
    sut.nameErrorStream.listen(
      expectAsync1((error) => expect(error, UIError.invalidField)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    // act
    sut.validateName(name);
    sut.validateName(name);
  });

  test('should emit requiredFieldError if name is empty', () async {
    // arrange
    mockValidation(value: ValidationError.requiredField);

    // assert
    sut.nameErrorStream.listen(
      expectAsync1((error) => expect(error, UIError.requiredField)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    // act
    sut.validateName(name);
    sut.validateName(name);
  });

  test('should emit null if name validation succes', () async {
    // assert
    sut.nameErrorStream.listen(
      expectAsync1((error) => expect(error, null)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    // act
    sut.validateName(name);
    sut.validateName(name);
  });

  test('should call Validation with correct password', () async {
    // act
    sut.validatePassword(password);

    // assert
    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('should emit invalidFieldError if password is invalid', () async {
    // arrange
    mockValidation(value: ValidationError.invalidField);

    // assert
    sut.passwordErrorStream.listen(
      expectAsync1((error) => expect(error, UIError.invalidField)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    // act
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('should emit requiredFieldError if password is empty', () async {
    // arrange
    mockValidation(value: ValidationError.requiredField);

    // assert
    sut.passwordErrorStream.listen(
      expectAsync1((error) => expect(error, UIError.requiredField)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    // act
    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('should emit null if password validation succes', () async {
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

  test('should call Validation with correct passwordConfirmation', () async {
    // act
    sut.validatePassword(password);

    // assert
    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('should emit invalidFieldError if passwordConfirmation is invalid',
      () async {
    // arrange
    mockValidation(value: ValidationError.invalidField);

    // assert
    sut.passwordConfirmationErrorStream.listen(
      expectAsync1((error) => expect(error, UIError.invalidField)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    // act
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('should emit requiredFieldError if passwordConfirmation is empty',
      () async {
    // arrange
    mockValidation(value: ValidationError.requiredField);

    // assert
    sut.passwordConfirmationErrorStream.listen(
      expectAsync1((error) => expect(error, UIError.requiredField)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    // act
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('should emit null if passwordConfirmation validation succes', () async {
    // assert
    sut.passwordConfirmationErrorStream.listen(
      expectAsync1((error) => expect(error, null)),
    );
    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    // act
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('should enable form button if all fields are valid', () async {
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });
}
