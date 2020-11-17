import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:image_test_utils/image_test_utils.dart';

import 'package:for_dev/ui/pages/survey_result/widgets/widgets.dart';
import 'package:for_dev/ui/pages/pages.dart';
import 'package:for_dev/ui/helpers/helpers.dart';
import 'package:mockito/mockito.dart';

class SurveyResultPresenterSpy extends Mock implements ISurveyResultPresenter {}

void main() {
  SurveyResultPresenterSpy presenter;
  StreamController<bool> isLoadingController;
  StreamController<SurveyResultViewModel> surveyResultController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    surveyResultController = StreamController<SurveyResultViewModel>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);
    when(presenter.surveyResultStream)
        .thenAnswer((_) => surveyResultController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    surveyResultController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();
    initStreams();
    mockStreams();
    final surveysPage = GetMaterialApp(
      initialRoute: '/survey_result/any_survey_id',
      getPages: [
        GetPage(
          name: '/survey_result/:survey_id',
          page: () => SurveyResultPage(presenter: presenter),
        ),
      ],
    );

    await provideMockedNetworkImages(() async {
      await tester.pumpWidget(surveysPage);
    });
  }

  SurveyResultViewModel makeSurveyResult() => SurveyResultViewModel(
        surveyId: 'any id',
        question: 'Question',
        answers: [
          SurveyAnswerViewModel(
            image: 'Image 0',
            answer: 'Answer 0',
            isCurrentAnswer: true,
            percent: '60%',
          ),
          SurveyAnswerViewModel(
            answer: 'Answer 1',
            isCurrentAnswer: false,
            percent: '40%',
          ),
        ],
      );

  tearDown(() {
    closeStreams();
  });

  testWidgets('should call LoadSurveyResult on page load',
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

  testWidgets('should present error if loadSurveyResultStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();
    expect(
      find.text('Algo de errado aconteceu. Tente novamente em breve.'),
      findsOneWidget,
    );
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question'), findsNothing);
  });

  testWidgets('should call LoadSurveyResult on reload button click',
      (WidgetTester tester) async {
    await loadPage(tester);

    surveyResultController.addError(UIError.unexpected.description);
    await tester.pump();
    await tester.tap(find.text('Recarregar'));

    verify(presenter.loadData()).called(2);
  });

  // testWidgets('should present valid data if loadSurveyResultStream success',
  //     (WidgetTester tester) async {
  //   await loadPage(tester);

  //   surveyResultController.add(makeSurveyResult());
  //   await provideMockedNetworkImages(() async {
  //     await tester.pump();
  //   });

  //   expect(
  //     find.text('Algo de errado aconteceu. Tente novamente em breve.'),
  //     findsNothing,
  //   );
  //   expect(find.text('Recarregar'), findsNothing);
  //   expect(find.text('Question'), findsOneWidget);
  //   expect(find.text('Answer 0'), findsOneWidget);
  //   expect(find.text('Answer 1'), findsOneWidget);
  //   expect(find.text('60%'), findsOneWidget);
  //   expect(find.text('40%'), findsOneWidget);
  //   expect(find.byType(ActiveIconWidget), findsOneWidget);
  //   expect(find.byType(DisabledIconWidget), findsOneWidget);

  //   final imageNetwork =
  //       tester.widget<Image>(find.byType(Image)).image as NetworkImage;
  //   expect(imageNetwork.url, 'Image 0');
  // });
}
