import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';

import 'package:for_dev/ui/pages/pages.dart';
import 'package:mockito/mockito.dart';

class SurveysPresenterSpy extends Mock implements ISurveysPresenter {}

void main() {
  SurveysPresenterSpy presenter;
  testWidgets('should call LoadSurveys on page load',
      (WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(
          name: '/surveys',
          page: () => SurveysPage(presenter: presenter),
        ),
      ],
    );

    await tester.pumpWidget(surveysPage);

    verify(presenter.loadData()).called(1);
  });
}
