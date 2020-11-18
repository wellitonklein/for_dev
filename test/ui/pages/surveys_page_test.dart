import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:for_dev/ui/helpers/helpers.dart';
import 'package:get/route_manager.dart';

import 'package:for_dev/ui/helpers/errors/errors.dart';
import 'package:for_dev/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements ISurveysPresenter {}

void main() {
  SurveysPresenterSpy presenter;
  StreamController<bool> isLoadingController;
  StreamController<bool> isSessionExpiredController;
  StreamController<List<SurveyViewModel>> surveysController;
  StreamController<String> navigateToController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    isSessionExpiredController = StreamController<bool>();
    surveysController = StreamController<List<SurveyViewModel>>();
    navigateToController = StreamController<String>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);
    when(presenter.surveysStream).thenAnswer((_) => surveysController.stream);
    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    isSessionExpiredController.close();
    surveysController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    initStreams();
    mockStreams();
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(
          name: '/surveys',
          page: () => SurveysPage(presenter: presenter),
        ),
        GetPage(
          name: '/fake_page',
          page: () => Scaffold(body: const Text('fake page')),
        ),
        GetPage(
          name: '/login',
          page: () => Scaffold(body: const Text('fake login')),
        ),
      ],
    );

    await tester.pumpWidget(surveysPage);
  }

  List<SurveyViewModel> makeSurveys() => [
        SurveyViewModel(
          id: '1',
          question: 'Question 1',
          date: 'Date 1',
          didAnswer: true,
        ),
        SurveyViewModel(
          id: '2',
          question: 'Question 2',
          date: 'Date 2',
          didAnswer: false,
        ),
      ];

  tearDown(() {
    closeStreams();
  });

  testWidgets('should call LoadSurveys on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.loadData()).called(1);
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

  testWidgets('should present error if loadSurveysStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();
    expect(
      find.text('Algo de errado aconteceu. Tente novamente em breve.'),
      findsOneWidget,
    );
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('should present list if loadSurveysStream success',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.add(makeSurveys());
    await tester.pump();
    expect(
      find.text('Algo de errado aconteceu. Tente novamente em breve.'),
      findsNothing,
    );
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
  });

  testWidgets('should present list if loadSurveysStream success',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.add(makeSurveys());
    await tester.pump();
    expect(
      find.text('Algo de errado aconteceu. Tente novamente em breve.'),
      findsNothing,
    );
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets('should call LoadSurveys on reload button click',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text('Recarregar'));

    verify(presenter.loadData()).called(2);
  });

  testWidgets('should call goToSurveyResult on survey click',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveysController.add(makeSurveys());
    await tester.pump();

    await tester.tap(find.text('Question 1'));
    await tester.pump();

    verify(presenter.goToSurveyResult('1')).called(1);
  });

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

  testWidgets(
    'should logout',
    (WidgetTester tester) async {
      await loadPage(tester);

      isSessionExpiredController.add(true);
      await tester.pumpAndSettle();

      expect(Get.currentRoute, '/login');
      expect(find.text('fake login'), findsOneWidget);
    },
  );

  testWidgets(
    'should not logout',
    (WidgetTester tester) async {
      await loadPage(tester);

      isSessionExpiredController.add(false);
      await tester.pumpAndSettle();
      expect(Get.currentRoute, '/surveys');

      isSessionExpiredController.add(null);
      await tester.pumpAndSettle();
      expect(Get.currentRoute, '/surveys');
    },
  );
}
