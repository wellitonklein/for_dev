import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

class SplashPage extends StatelessWidget {
  final ISplashPresenter presenter;

  const SplashPage({Key key, @required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();

    return Scaffold(
      appBar: AppBar(
        title: const Text('4Dev'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

abstract class ISplashPresenter {
  Future<void> loadCurrentAccount();
}

class SplashPresenterSpy extends Mock implements ISplashPresenter {}

void main() {
  SplashPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => SplashPage(presenter: presenter)),
        ],
      ),
    );
  }

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

      verify(presenter.loadCurrentAccount()).called(1);
    },
  );
}
