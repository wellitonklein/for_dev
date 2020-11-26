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
    try {
      final response = await remote.loadBySurvey(surveyId: surveyId);
      await local.save(surveyId: surveyId, surveyResult: response);
      return response;
    } catch (error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }
      await local.validate(surveyId: surveyId);
      return await local.loadBySurvey(surveyId: surveyId);
    }
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
  SurveyResultEntity remoteResult;
  SurveyResultEntity localResult;

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
    remoteResult = mockSurveyResult();
    mockRemoteLoadCall().thenAnswer((_) async => remoteResult);
  }

  void mockRemoteLoadError(DomainError error) =>
      mockRemoteLoadCall().thenThrow(error);

  PostExpectation mockLocalLoadCall() =>
      when(local.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLocalLoad() {
    localResult = mockSurveyResult();
    mockLocalLoadCall().thenAnswer((_) async => localResult);
  }

  setUp(() {
    surveyId = faker.guid.guid();
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    mockRemoteLoad();
    mockLocalLoad();
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
      surveyResult: remoteResult,
    )).called(1);
  });

  test('should return remote data', () async {
    // arrange

    // act
    final response = await sut.loadBySurvey(surveyId: surveyId);
    // assert
    expect(response, remoteResult);
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

  test('should call local LoadBySurvey on remote error', () async {
    // arrange
    mockRemoteLoadError(DomainError.unexpected);
    // act
    await sut.loadBySurvey(surveyId: surveyId);
    // assert
    verify(local.validate(surveyId: surveyId)).called(1);
    verify(local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('should return local data', () async {
    // arrange
    mockRemoteLoadError(DomainError.unexpected);
    // act
    final response = await sut.loadBySurvey(surveyId: surveyId);
    // assert
    expect(response, localResult);
  });
}
