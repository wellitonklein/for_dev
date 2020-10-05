import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:for_dev/ui/helpers/helpers.dart';
import 'package:for_dev/ui/pages/pages.dart';

class SignUpPresenterSpy extends Mock implements ISignUpPresenter {}

void main() {
  ISignUpPresenter presenter;
  StreamController<UIError> nameErrorController;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> passwordConfirmationErrorController;
  StreamController<UIError> mainErrorController;
  StreamController<String> navigateToController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;

  void initStreams() {
    nameErrorController = StreamController<UIError>();
    emailErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    passwordConfirmationErrorController = StreamController<UIError>();
    mainErrorController = StreamController<UIError>();
    navigateToController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.nameErrorStream)
        .thenAnswer((_) => nameErrorController.stream);
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
    when(presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);
    when(presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    navigateToController.close();
    mainErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SignUpPresenterSpy();
    initStreams();
    mockStreams();
    final signUpPage = GetMaterialApp(
      initialRoute: '/signup',
      getPages: [
        GetPage(name: '/signup', page: () => SignUpPage(presenter: presenter)),
        GetPage(
          name: '/fake_page',
          page: () => Scaffold(
            body: const Text('fake page'),
          ),
        ),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets('should call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));

    await tester.enterText(
      find.bySemanticsLabel('Confirmar senha'),
      password,
    );
    verify(presenter.validatePasswordConfirmation(password));
  });

  testWidgets('should present email error', (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido.'), findsOneWidget);

    emailErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório.'), findsOneWidget);

    emailErrorController.add(null);
    await tester.pump();
    expect(
      find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('should present name error', (WidgetTester tester) async {
    await loadPage(tester);

    nameErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido.'), findsOneWidget);

    nameErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório.'), findsOneWidget);

    nameErrorController.add(null);
    await tester.pump();
    expect(
      find.descendant(
        of: find.bySemanticsLabel('Nome'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('should present password error', (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido.'), findsOneWidget);

    passwordErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório.'), findsOneWidget);

    passwordErrorController.add(null);
    await tester.pump();
    expect(
      find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('should present password confirmation error',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordConfirmationErrorController.add(UIError.invalidField);
    await tester.pump();
    expect(find.text('Campo inválido.'), findsOneWidget);

    passwordConfirmationErrorController.add(UIError.requiredField);
    await tester.pump();
    expect(find.text('Campo obrigatório.'), findsOneWidget);

    passwordConfirmationErrorController.add(null);
    await tester.pump();
    expect(
      find.descendant(
        of: find.bySemanticsLabel('Confirmar senha'),
        matching: find.byType(Text),
      ),
      findsOneWidget,
    );
  });

  testWidgets('should enable button if from is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('should disable button if from is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('should call authentication on form submit',
      (WidgetTester tester) async {
    await loadPage(tester);

    final button = find.byType(RaisedButton);

    isFormValidController.add(true);
    await tester.pump();
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.signUp()).called(1);
  });

  testWidgets('should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(null);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('should present error message if signUp fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UIError.emailInUse);
    await tester.pump();

    expect(find.text('O email já está em uso.'), findsOneWidget);
  });

  testWidgets('should present error message if signUp throws',
      (WidgetTester tester) async {
    await loadPage(tester);

    mainErrorController.add(UIError.unexpected);
    await tester.pump();

    expect(
      find.text('Algo de errado aconteceu. Tente novamente em breve.'),
      findsOneWidget,
    );
  });

  testWidgets('should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/fake_page');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/fake_page');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(Get.currentRoute, '/signup');

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, '/signup');
  });

  testWidgets('should call goToLogin on link click',
      (WidgetTester tester) async {
    await loadPage(tester);

    final button = find.text(R.strings.login);

    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();

    verify(presenter.goToLogin()).called(1);
  });
}
