import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/presentation/dependencies/dependencies.dart';
import 'package:for_dev/presentation/presenters/presenters.dart';

import 'package:for_dev/domain/usecases/authentication_interface.dart';
import 'package:for_dev/domain/usecases/save_current_account_interface.dart';
import 'package:for_dev/domain/entities/account_entity.dart';
import 'package:for_dev/domain/helpers/domain_error.dart';

import 'package:for_dev/ui/helpers/errors/errors.dart';

import '../../mocks/mocks.dart';

class ValidationSpy extends Mock implements IValidation {}

class AuthenticationSpy extends Mock implements IAuthentication {}

class SaveCurrentAccountSpy extends Mock implements ISaveCurrentAccount {}

void main() {
  GetXLoginPresenter sut;
  ValidationSpy validation;
  AuthenticationSpy authentication;
  SaveCurrentAccountSpy saveCurrentAccount;
  String email;
  String password;
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

  PostExpectation mockAuthenticationCall() =>
      when(authentication.auth(params: anyNamed('params')));

  void mockAuthentication(AccountEntity data) {
    account = data;
    mockAuthenticationCall().thenAnswer((_) async => account);
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  PostExpectation mockSaveCurrentAccountCall() =>
      when(saveCurrentAccount.save(any));

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetXLoginPresenter(
      validation: validation,
      authentication: authentication,
      saveCurrentAccount: saveCurrentAccount,
    );
    email = faker.internet.email();
    password = faker.internet.password();
    mockValidation();
    mockAuthentication(FakeAccountMock.makeEntity());
  });

  test('should call Validation with correct email', () async {
    final formData = {'email': email, 'password': null};

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
    final formData = {'email': null, 'password': password};

    // act
    sut.validatePassword(password);

    // assert
    verify(validation.validate(field: 'password', input: formData)).called(1);
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

  test('should disable form button if any field is invalid', () async {
    // arrange
    mockValidation(field: 'email', value: ValidationError.invalidField);

    // assert
    sut.isFormValidStream.listen(
      expectAsync1((isValid) => expect(isValid, false)),
    );

    // act
    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('should enable form button if all fields are valid', () async {
    // assert
    expectLater(sut.isFormValidStream, emitsInOrder([false, true]));

    // act
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('should call Authentication with correct values', () async {
    // arrange
    sut.validateEmail(email);
    sut.validatePassword(password);

    // act
    await sut.auth();

    verify(
      authentication.auth(
        params: AuthenticationParams(
          email: email,
          secret: password,
        ),
      ),
    ).called(1);
  });

  test('should call SaveCurrentAccount with correct value', () async {
    // arrange
    sut.validateEmail(email);
    sut.validatePassword(password);

    // act
    await sut.auth();

    verify(saveCurrentAccount.save(account)).called(1);
  });

  test('should emit UnexpectedError if SaveCurrentAccount fails', () async {
    // arrange
    mockSaveCurrentAccountError();
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1(
      (error) => expect(error, UIError.unexpected),
    ));

    // act
    await sut.auth();
  });

  test('should emit correct events on Authentication success', () async {
    // arrange
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emits(true));

    // act
    await sut.auth();
  });

  test('should change page on success', () async {
    // arrange
    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/surveys')));

    // act
    await sut.auth();
  });

  test('should emit correct events on UnexpectedError', () async {
    // arrange
    mockAuthenticationError(DomainError.unexpected);
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream.listen(expectAsync1(
      (error) => expect(error, UIError.unexpected),
    ));

    // act
    await sut.auth();
  });

  test('should go to SignUpPage on link click', () async {
    sut.navigateToStream
        .listen(expectAsync1((page) => expect(page, '/signup')));

    // act
    sut.goToSignUp();
  });
}
