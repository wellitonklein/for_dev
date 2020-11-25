import 'package:faker/faker.dart';
import 'package:for_dev/domain/entities/entities.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/data/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback({
    @required this.remote,
    @required this.local,
  });

  Future<void> loadBySurvey({String surveyId}) async {
    final response = await remote.loadBySurvey(surveyId: surveyId);
    await local.save(surveyId: surveyId, surveyResult: response);
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  RemoteLoadSurveyResultWithLocalFallback sut;
  RemoteLoadSurveyResultSpy remote;
  LocalLoadSurveyResultSpy local;
  String surveyId;
  SurveyResultEntity surveyResult;

  void mockSurveyResult() {
    surveyResult = SurveyResultEntity(
      surveyId: faker.guid.guid(),
      question: faker.lorem.sentence(),
      answers: [
        SurveyAnswerEntity(
          answer: faker.lorem.sentence(),
          isCurrentAnswer: faker.randomGenerator.boolean(),
          percent: faker.randomGenerator.integer(100),
        ),
      ],
    );
    when(remote.loadBySurvey(surveyId: anyNamed('surveyId')))
        .thenAnswer((_) async => surveyResult);
  }

  setUp(() {
    surveyId = faker.guid.guid();
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    mockSurveyResult();
  });

  test('should call remote loadBySurvey', () async {
    // arrange

    // act
    await sut.loadBySurvey(surveyId: surveyId);
    // assert
    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('should call local save with remote data', () async {
    // arrange

    // act
    await sut.loadBySurvey(surveyId: surveyId);
    // assert
    verify(local.save(
      surveyId: surveyId,
      surveyResult: surveyResult,
    )).called(1);
  });
}
