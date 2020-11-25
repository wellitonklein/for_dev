import 'package:faker/faker.dart';
import 'package:for_dev/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/data/usecases/usecases.dart';
import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback implements ILoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback({
    @required this.remote,
    @required this.local,
  });

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    final response = await remote.loadBySurvey(surveyId: surveyId);
    await local.save(surveyId: surveyId, surveyResult: response);
    return response;
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

  SurveyResultEntity mockSurveyResult() => SurveyResultEntity(
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

  PostExpectation mockRemoteLoadCall() =>
      when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockRemoteLoad() {
    surveyResult = mockSurveyResult();
    mockRemoteLoadCall().thenAnswer((_) async => surveyResult);
  }

  void mockRemoteLoadError(DomainError error) =>
      mockRemoteLoadCall().thenThrow(error);

  setUp(() {
    surveyId = faker.guid.guid();
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    mockRemoteLoad();
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

  test('should return remote data', () async {
    // arrange

    // act
    final response = await sut.loadBySurvey(surveyId: surveyId);
    // assert
    expect(response, surveyResult);
  });

  test('should rethrow if remote loadBySurvey throws AccessDeniedError',
      () async {
    // arrange
    mockRemoteLoadError(DomainError.accessDenied);
    // act
    final future = sut.loadBySurvey(surveyId: surveyId);
    // assert
    expect(future, throwsA(DomainError.accessDenied));
  });
}
