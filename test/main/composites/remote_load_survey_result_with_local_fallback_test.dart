import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/helpers/helpers.dart';
import 'package:for_dev/data/usecases/usecases.dart';
import 'package:for_dev/main/composites/composites.dart';

import '../../mocks/mocks.dart';

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

  PostExpectation mockRemoteLoadCall() =>
      when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockRemoteLoad() {
    remoteResult = FakeSurveyResultMock.makeEntity();
    mockRemoteLoadCall().thenAnswer((_) async => remoteResult);
  }

  void mockRemoteLoadError(DomainError error) =>
      mockRemoteLoadCall().thenThrow(error);

  PostExpectation mockLocalLoadCall() =>
      when(local.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLocalLoad() {
    localResult = FakeSurveyResultMock.makeEntity();
    mockLocalLoadCall().thenAnswer((_) async => localResult);
  }

  void mockLocalLoadError() =>
      mockLocalLoadCall().thenThrow(DomainError.unexpected);

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
    verify(local.save(remoteResult)).called(1);
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

  test('should throw UnexpectedError if local load fails', () async {
    // arrange
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();
    // act
    final future = sut.loadBySurvey(surveyId: surveyId);
    // assert
    expect(future, throwsA(DomainError.unexpected));
  });
}
