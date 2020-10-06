import 'package:faker/faker.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:get/get.dart';

import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/usecases/usecases.dart';
import 'package:for_dev/domain/helpers/helpers.dart';
import 'package:for_dev/ui/helpers/errors/errors.dart';
import 'package:for_dev/ui/pages/pages.dart';

class GetxSurveysPresenter {
  final ILoadSurveys loadSurveys;
  final _isLoading = true.obs;
  final _surveys = Rx<List<SurveyViewModel>>();

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  GetxSurveysPresenter({@required this.loadSurveys});

  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      final response = await loadSurveys.load();
      _surveys.value = response
          .map((survey) => SurveyViewModel(
                id: survey.id,
                question: survey.question,
                date: DateFormat('dd MMM yyyy').format(survey.dateTime),
                didAnswer: survey.didAnswer,
              ))
          .toList();
    } on DomainError {
      _surveys.subject.addError(UIError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
  }
}

class LoadSurveysSpy extends Mock implements ILoadSurveys {}

void main() {
  LoadSurveysSpy loadSurveys;
  GetxSurveysPresenter sut;

  List<SurveyEntity> mockValidData() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.lorem.sentence(),
          dateTime: DateTime(2020, 2, 20),
          didAnswer: true,
        ),
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.lorem.sentence(),
          dateTime: DateTime(2017, 11, 4),
          didAnswer: false,
        ),
      ];

  PostExpectation mockLoadSurveysCall() => when(loadSurveys.load());

  void mockLoadSurveys(List<SurveyEntity> data) {
    mockLoadSurveysCall().thenAnswer((_) async => data);
  }

  void mockLoadSurveysError() =>
      mockLoadSurveysCall().thenThrow(DomainError.unexpected);

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadSurveys(mockValidData());
  });

  test('should call LoadSurveys on loadData', () async {
    // arrange

    // act
    await sut.loadData();
    // assert
    verify(loadSurveys.load()).called(1);
  });

  test('should emit correct events on success', () async {
    // assert
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(expectAsync1((surveys) => expect(surveys, [
          SurveyViewModel(
            id: surveys[0].id,
            question: surveys[0].question,
            date: DateFormat('dd MMM yyyy').format(DateTime(2020, 2, 20)),
            didAnswer: surveys[0].didAnswer,
          ),
          SurveyViewModel(
            id: surveys[1].id,
            question: surveys[1].question,
            date: DateFormat('dd MMM yyyy').format(DateTime(2017, 11, 4)),
            didAnswer: surveys[1].didAnswer,
          ),
        ])));
    // act
    await sut.loadData();
  });

  test('should emit correct events on failure', () async {
    // arrange
    mockLoadSurveysError();

    // assert
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(
      null,
      onError: expectAsync1(
        (error) => expect(error, UIError.unexpected.description),
      ),
    );
    // act
    await sut.loadData();
  });
}
