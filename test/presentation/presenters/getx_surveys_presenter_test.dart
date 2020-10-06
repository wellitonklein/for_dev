import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/domain/usecases/usecases.dart';

class GetxSurveysPresenter {
  final ILoadSurveys loadSurveys;

  GetxSurveysPresenter({@required this.loadSurveys});

  Future<void> loadData() async {
    await loadSurveys.load();
  }
}

class LoadSurveysSpy extends Mock implements ILoadSurveys {}

void main() {
  test('should call LoadSurveys on loadData', () async {
    // arrange
    final loadSurveys = LoadSurveysSpy();
    final sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    // act
    await sut.loadData();
    // assert
    verify(loadSurveys.load()).called(1);
  });
}
