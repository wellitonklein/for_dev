import 'package:faker/faker.dart';
import 'package:for_dev/domain/helpers/domain_error.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/data/usecases/load_surveys/load_surveys.dart';
import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/usecases/usecases.dart';

class RemoteLoadSurveysWithLocalFallback implements ILoadSurveys {
  final RemoteLoadSurveys remote;
  final LocalLoadSurveys local;

  RemoteLoadSurveysWithLocalFallback({
    @required this.remote,
    @required this.local,
  });

  Future<List<SurveyEntity>> load() async {
    try {
      final surveys = await remote.load();
      await local.save(surveys);
      return surveys;
    } catch (error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }
      await local.validate();
      return await local.load();
    }
  }
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {
  RemoteLoadSurveysWithLocalFallback sut;
  RemoteLoadSurveysSpy remote;
  LocalLoadSurveysSpy local;
  List<SurveyEntity> remoteSurveys;
  List<SurveyEntity> localSurveys;

  List<SurveyEntity> mockSurveys() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(30, min: 30),
          dateTime: faker.date.dateTime(),
          didAnswer: faker.randomGenerator.boolean(),
        ),
      ];

  PostExpectation mockRemoteLoadCall() => when(remote.load());

  void mockRemoteLoad() {
    remoteSurveys = mockSurveys();
    mockRemoteLoadCall().thenAnswer((_) async => remoteSurveys);
  }

  void mockRemoteLoadError(DomainError error) =>
      mockRemoteLoadCall().thenThrow(error);

  PostExpectation mockLocalLoadCall() => when(local.load());

  void mockLocalLoad() {
    localSurveys = mockSurveys();
    mockLocalLoadCall().thenAnswer((_) async => localSurveys);
  }

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

  test('should return local surveys', () async {
    // arrange
    mockRemoteLoadError(DomainError.unexpected);
    // act
    final surveys = await sut.load();
    // assert
    expect(surveys, localSurveys);
  });
}
