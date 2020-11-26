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

class SaveSurveyResultSpy extends Mock implements ISaveSurveyResult {}

void main() {
  GetxSurveyResultPresenter sut;
  LoadSurveyResultSpy loadSurveyResult;
  SaveSurveyResultSpy saveSurveyResult;
  SurveyResultEntity loadResult;
  SurveyResultEntity saveResult;
  String surveyId;
  String answer;

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
    loadResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => loadResult);
  }

  void mockLoadSurveyResultError(DomainError error) =>
      mockLoadSurveyResultCall().thenThrow(error);

  PostExpectation mockSaveSurveyResultCall() =>
      when(saveSurveyResult.save(answer: anyNamed('answer')));

  void mockSaveSurveyResult(SurveyResultEntity data) {
    saveResult = data;
    mockSaveSurveyResultCall().thenAnswer((_) async => saveResult);
  }

  void mockSaveSurveyResultError(DomainError error) =>
      mockSaveSurveyResultCall().thenThrow(error);

  setUp(() {
    answer = faker.lorem.sentence();
    loadSurveyResult = LoadSurveyResultSpy();
    saveSurveyResult = SaveSurveyResultSpy();
    surveyId = faker.guid.guid();
    sut = GetxSurveyResultPresenter(
      surveyId: surveyId,
      loadSurveyResult: loadSurveyResult,
      saveSurveyResult: saveSurveyResult,
    );
    mockLoadSurveyResult(mockValidData());
    mockSaveSurveyResult(mockValidData());
  });

  group('loadData', () {
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
              surveyId: loadResult.surveyId,
              question: loadResult.question,
              answers: [
                SurveyAnswerViewModel(
                  image: loadResult.answers[0].image,
                  answer: loadResult.answers[0].answer,
                  isCurrentAnswer: loadResult.answers[0].isCurrentAnswer,
                  percent: '${loadResult.answers[0].percent}%',
                ),
                SurveyAnswerViewModel(
                  answer: loadResult.answers[1].answer,
                  isCurrentAnswer: loadResult.answers[1].isCurrentAnswer,
                  percent: '${loadResult.answers[1].percent}%',
                ),
              ],
            ),
          )));
      // act
      await sut.loadData();
    });

    test('should emit correct events on failure', () async {
      // arrange
      mockLoadSurveyResultError(DomainError.unexpected);

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
      mockLoadSurveyResultError(DomainError.accessDenied);

      // assert
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));
      // act
      await sut.loadData();
    });
  });

  group('save', () {
    test('should call SaveSurveyResult on save', () async {
      // arrange

      // act
      await sut.save(answer: answer);
      // assert
      verify(saveSurveyResult.save(answer: answer)).called(1);
    });

    test('should emit correct events on success', () async {
      // assert
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(expectAsync1((result) => expect(
            result,
            SurveyResultViewModel(
              surveyId: saveResult.surveyId,
              question: saveResult.question,
              answers: [
                SurveyAnswerViewModel(
                  image: saveResult.answers[0].image,
                  answer: saveResult.answers[0].answer,
                  isCurrentAnswer: saveResult.answers[0].isCurrentAnswer,
                  percent: '${saveResult.answers[0].percent}%',
                ),
                SurveyAnswerViewModel(
                  answer: saveResult.answers[1].answer,
                  isCurrentAnswer: saveResult.answers[1].isCurrentAnswer,
                  percent: '${saveResult.answers[1].percent}%',
                ),
              ],
            ),
          )));
      // act
      await sut.save(answer: answer);
    });

    test('should emit correct events on failure', () async {
      // arrange
      mockSaveSurveyResultError(DomainError.unexpected);

      // assert
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(
        null,
        onError: expectAsync1(
          (error) => expect(error, UIError.unexpected.description),
        ),
      );
      // act
      await sut.save(answer: answer);
    });

    test('should emit correct events on access denied', () async {
      // arrange
      mockSaveSurveyResultError(DomainError.accessDenied);

      // assert
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));
      // act
      await sut.save(answer: answer);
    });
  });
}
