import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/usecases/usecases.dart';
import 'package:for_dev/domain/helpers/helpers.dart';
import 'package:for_dev/presentation/presenters/presenters.dart';
import 'package:for_dev/ui/helpers/errors/errors.dart';
import 'package:for_dev/ui/pages/pages.dart';

class LoadSurveyResultSpy extends Mock implements ILoadSurveyResult {}

void main() {
  GetxSurveyResultPresenter sut;
  LoadSurveyResultSpy loadSurveyResult;
  SurveyResultEntity surveyResult;
  String surveyId;

  SurveyResultEntity mockValidData() => SurveyResultEntity(
        surveyId: faker.guid.guid(),
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
            image: faker.internet.httpUrl(),
            answer: faker.lorem.sentence(),
            percent: faker.randomGenerator.integer(100),
            isCurrentAnswer: faker.randomGenerator.boolean(),
          ),
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            percent: faker.randomGenerator.integer(100),
            isCurrentAnswer: faker.randomGenerator.boolean(),
          ),
        ],
      );

  PostExpectation mockLoadSurveyResultCall() =>
      when(loadSurveyResult.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLoadSurveyResult(SurveyResultEntity data) {
    surveyResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => surveyResult);
  }

  void mockLoadSurveyResultError() =>
      mockLoadSurveyResultCall().thenThrow(DomainError.unexpected);

  void mockAccessDeniedError() =>
      mockLoadSurveyResultCall().thenThrow(DomainError.accessDenied);

  setUp(() {
    loadSurveyResult = LoadSurveyResultSpy();
    surveyId = faker.guid.guid();
    sut = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      surveyId: surveyId,
    );
    mockLoadSurveyResult(mockValidData());
  });

  test('should call LoadSurveyResult on loadData', () async {
    // arrange

    // act
    await sut.loadData();
    // assert
    verify(loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('should emit correct events on success', () async {
    // assert
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(expectAsync1((result) => expect(
          result,
          SurveyResultViewModel(
            surveyId: surveyResult.surveyId,
            question: surveyResult.question,
            answers: [
              SurveyAnswerViewModel(
                image: surveyResult.answers[0].image,
                answer: surveyResult.answers[0].answer,
                isCurrentAnswer: surveyResult.answers[0].isCurrentAnswer,
                percent: '${surveyResult.answers[0].percent}%',
              ),
              SurveyAnswerViewModel(
                answer: surveyResult.answers[1].answer,
                isCurrentAnswer: surveyResult.answers[1].isCurrentAnswer,
                percent: '${surveyResult.answers[1].percent}%',
              ),
            ],
          ),
        )));
    // act
    await sut.loadData();
  });

  test('should emit correct events on failure', () async {
    // arrange
    mockLoadSurveyResultError();

    // assert
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(
      null,
      onError: expectAsync1(
        (error) => expect(error, UIError.unexpected.description),
      ),
    );
    // act
    await sut.loadData();
  });

  test('should emit correct events on access denied', () async {
    // arrange
    mockAccessDeniedError();

    // assert
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.isSessionExpiredStream, emits(true));
    // act
    await sut.loadData();
  });
}
