import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:for_dev/ui/pages/pages.dart';

import '../helpers/helpers.dart';

class SplashPresenterSpy extends Mock implements ISplashPresenter {}

void main() {
  SplashPresenterSpy presenter;
  StreamController<String> navigateToController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();
    navigateToController = StreamController<String>();
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
    await tester.pumpWidget(makePage(
      path: '/',
      page: () => SplashPage(presenter: presenter),
    ));
  }

  tearDown(() {
    navigateToController.close();
  });

  testWidgets(
    'should present spinner on page load',
    (WidgetTester tester) async {
      await loadPage(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'should call LoadCurrentAccount on page load',
    (WidgetTester tester) async {
      await loadPage(tester);

      verify(presenter.checkAccount()).called(1);
    },
  );

  testWidgets(
    'should change page',
    (WidgetTester tester) async {
      await loadPage(tester);

      navigateToController.add('/fake_page');
      await tester.pumpAndSettle();

      expect(currentRoute, '/fake_page');
      expect(find.text('fake page'), findsOneWidget);
    },
  );

  testWidgets(
    'should not change page',
    (WidgetTester tester) async {
      await loadPage(tester);

      navigateToController.add('');
      await tester.pump();
      expect(currentRoute, '/');

      navigateToController.add(null);
      await tester.pump();
      expect(currentRoute, '/');
    },
  );
}
