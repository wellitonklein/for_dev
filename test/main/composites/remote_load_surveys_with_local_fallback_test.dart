import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/data/usecases/usecases.dart';
import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/helpers/helpers.dart';
import 'package:for_dev/main/composites/composites.dart';

import '../../mocks/mocks.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {
  RemoteLoadSurveysWithLocalFallback sut;
  RemoteLoadSurveysSpy remote;
  LocalLoadSurveysSpy local;
  List<SurveyEntity> remoteSurveys;
  List<SurveyEntity> localSurveys;

  PostExpectation mockRemoteLoadCall() => when(remote.load());

  void mockRemoteLoad() {
    remoteSurveys = FakeSurveysMock.makeEntities();
    mockRemoteLoadCall().thenAnswer((_) async => remoteSurveys);
  }

  void mockRemoteLoadError(DomainError error) =>
      mockRemoteLoadCall().thenThrow(error);

  PostExpectation mockLocalLoadCall() => when(local.load());

  void mockLocalLoad() {
    localSurveys = FakeSurveysMock.makeEntities();
    mockLocalLoadCall().thenAnswer((_) async => localSurveys);
  }

  void mockLocalLoadError() =>
      mockLocalLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    local = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote, local: local);
    mockRemoteLoad();
    mockLocalLoad();
  });

  test('should call remote load', () async {
    // act
    await sut.load();
    // assert
    verify(remote.load()).called(1);
  });

  test('should call local save with remote data', () async {
    // act
    await sut.load();
    // assert
    verify(local.save(remoteSurveys)).called(1);
  });

  test('should return remote surveys', () async {
    // act
    final surveys = await sut.load();
    // assert
    expect(surveys, remoteSurveys);
  });

  test('should rethrow if remote load throws AccessDeniedError', () async {
    // arrange
    mockRemoteLoadError(DomainError.accessDenied);
    // act
    final future = sut.load();
    // assert
    expect(future, throwsA(DomainError.accessDenied));
  });

  test('should call local fetch on remote error', () async {
    // arrange
    mockRemoteLoadError(DomainError.unexpected);
    // act
    await sut.load();
    // assert
    verify(local.validate()).called(1);
    verify(local.load()).called(1);
  });

  test('should throw UnexpectedError if remote and local throws', () async {
    // arrange
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();
    // act
    final future = sut.load();
    // assert
    expect(future, throwsA(DomainError.unexpected));
  });
}
