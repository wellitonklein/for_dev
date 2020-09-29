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
}
