import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/helpers/helpers.dart';
import 'package:for_dev/domain/usecases/usecases.dart';
import 'package:for_dev/presentation/dependencies/dependencies.dart';
import 'package:for_dev/presentation/presenters/presenters.dart';

import 'package:for_dev/ui/helpers/errors/errors.dart';

import '../../mocks/fake_account_mock.dart';

class ValidationSpy extends Mock implements IValidation {}

class AddAccountSpy extends Mock implements IAddAccount {}

class SaveCurrentAccountSpy extends Mock implements ISaveCurrentAccount {}

void main() {
  GetxSignUpPresenter sut;
  ValidationSpy validation;
  AddAccountSpy addAccount;
  SaveCurrentAccountSpy saveCurrentAccount;
  String email;
  String name;
  String password;
  String passwordConfirmation;
  AccountEntity account;

  PostExpectation mockValidationCall(String field) => when(
        validation.validate(
          field: field == null ? anyNamed('field') : field,
          input: anyNamed('input'),
        ),
      );

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAddAccountCall() =>
      when(addAccount.add(params: anyNamed('params')));

  void mockAddAccount(AccountEntity data) {
    account = data;
    mockAddAccountCall().thenAnswer((_) async => account);
  }

  void mockAddAccountError(DomainError error) {
    mockAddAccountCall().thenThrow(error);
  }

  PostExpectation mockSaveCurrentAccountCall() =>
      when(saveCurrentAccount.save(any));

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(
      validation: validation,
      addAccount: addAccount,
      saveCurrentAccount: saveCurrentAccount,
    );
    email = faker.internet.email();
    name = faker.person.name();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    mockValidation();
    mockAddAccount(FakeAccountMock.makeEntity());
  });

  test('should call Validation with correct email', () async {
    final formData = {
      'name': null,
      'email': email,
      'password': null,
      'passwordConfirmation': null,
    };

    // act
    sut.validateEmail(email);

    // assert
    verify(validation.validate(field: 'email', input: formData)).called(1);
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
    final formData = {
      'name': name,
      'email': null,
      'password': null,
      'passwordConfirmation': null,
    };

    // act
    sut.validateName(name);

    // assert
    verify(validation.validate(field: 'name', input: formData)).called(1);
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
    final formData = {
      'name': null,
      'email': null,
      'password': password,
      'passwordConfirmation': null,
    };

    // act
    sut.validatePassword(password);

    // assert
    verify(validation.validate(field: 'password', input: formData)).called(1);
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
    final formData = {
      'name': null,
      'email': null,
      'password': null,
      'passwordConfirmation': passwordConfirmation,
    };

    // act
    sut.validatePasswordConfirmation(passwordConfirmation);

    // assert
    verify(validation.validate(
      field: 'passwordConfirmation',
      input: formData,
    )).called(1);
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

  test('should call AddAccount with correct values', () async {
    // arrange
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    // act
    await sut.signUp();

    verify(
      addAccount.add(
        params: AddAccountParams(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ),
      ),
    ).called(1);
  });

  test('should call SaveCurrentAccount with correct value', () async {
    // arrange
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    // act
    await sut.signUp();

    verify(saveCurrentAccount.save(account)).called(1);
  });

  test('should emit UnexpectedError if SaveCurrentAccount fails', () async {
    // arrange
    mockSaveCurrentAccountError();
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1(
      (error) => expect(error, UIError.unexpected),
    ));

    // act
    await sut.signUp();
  });

  test('should emit correct events on AddAccount success', () async {
    // arrange
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emits(true));

    // act
    await sut.signUp();
  });

  test('should emit correct events on EmailInUseError', () async {
    // arrange
    mockAddAccountError(DomainError.emailInUse);
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1(
      (error) => expect(error, UIError.emailInUse),
    ));

    // act
    await sut.signUp();
  });

  test('should change page on success', () async {
    // arrange
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    // act
    await sut.signUp();
  });

  test('should go to SignLogin on link click', () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    // act
    sut.goToLogin();
  });
}
