import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:for_dev/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements ILoginPresenter {}

void main() {
  ILoginPresenter presenter;
  StreamController<String> emailErrorController;
  StreamController<String> passwordErrorController;
  StreamController<String> mainErrorController;
  StreamController<String> navigateToController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;

  void initStreams() {
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    mainErrorController = StreamController<String>();
    navigateToController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
  }

  void mockStreams() {
    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);
    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);
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
    emailErrorController.close();
    passwordErrorController.close();
    mainErrorController.close();
    navigateToController.close();
    isFormValidController.close();
    isLoadingController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    initStreams();
    mockStreams();
    final loginPage = GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage(presenter: presenter)),
        GetPage(
          name: '/fake_page',
          page: () => Scaffold(
            body: const Text('fake page'),
          ),
        ),
      ],
    );
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    closeStreams();
  });

  testWidgets(
    'should load with correct initial state',
    (WidgetTester tester) async {
      // arrange
      await loadPage(tester);

      // assert
      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'),
        matching: find.byType(Text),
      );
      expect(
        emailTextChildren,
        findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text',
      );

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'),
        matching: find.byType(Text),
      );
      expect(
        passwordTextChildren,
        findsOneWidget,
        reason:
            'when a TextFormField has only one text child, means it has no errors, since one of the childs is always the label text',
      );

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, null);

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    'should call validate with correct values',
    (WidgetTester tester) async {
      await loadPage(tester);

      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel('Email'), email);
      verify(presenter.validateEmail(email));

      final password = faker.internet.password();
      await tester.enterText(find.bySemanticsLabel('Senha'), password);
      verify(presenter.validatePassword(password));
    },
  );

  testWidgets(
    'should present error if email is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add('any error');
      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );

  testWidgets(
    'should present no error if email is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add(null);
      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel('Email'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should present no error if email is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add('');
      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel('Email'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should present error if password is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('any error');
      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );

  testWidgets(
    'should present no error if password is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add(null);
      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel('Senha'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should present no error if password is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('');
      await tester.pump();

      expect(
        find.descendant(
          of: find.bySemanticsLabel('Senha'),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'should enable button if from is valid',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets(
    'should disable button if from is invalid',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(false);
      await tester.pump();

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, isNull);
    },
  );

  testWidgets(
    'should call authentication on form submit',
    (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();
      await tester.tap(find.byType(RaisedButton));
      await tester.pump();

      verify(presenter.auth()).called(1);
    },
  );

  testWidgets(
    'should present loading',
    (WidgetTester tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'should hide loading',
    (WidgetTester tester) async {
      await loadPage(tester);

      isLoadingController.add(true);
      await tester.pump();
      isLoadingController.add(false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets(
    'should present error message if authentication fails',
    (WidgetTester tester) async {
      final anyError = 'any error';
      await loadPage(tester);

      mainErrorController.add(anyError);
      await tester.pump();

      expect(find.text(anyError), findsOneWidget);
    },
  );

  testWidgets(
    'should change page',
    (WidgetTester tester) async {
      await loadPage(tester);

      navigateToController.add('/fake_page');
      await tester.pumpAndSettle();

      expect(Get.currentRoute, '/fake_page');
      expect(find.text('fake page'), findsOneWidget);
    },
  );

  // testWidgets(
  //   'should close streams on dispose',
  //   (WidgetTester tester) async {
  //     await loadPage(tester);

  //     addTearDown(() {
  //       verify(presenter.dispose()).called(1);
  //     });
  //   },
  // );
}
