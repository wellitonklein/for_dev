import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/data/usecases/load_surveys/load_surveys.dart';
import 'package:for_dev/domain/entities/entities.dart';

class RemoteLoadSurveysWithLocalFallback {
  final RemoteLoadSurveys remote;
  final LocalLoadSurveys local;

  RemoteLoadSurveysWithLocalFallback({
    @required this.remote,
    @required this.local,
  });

  Future<void> load() async {
    final surveys = await remote.load();
    await local.save(surveys);
  }
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {
  RemoteLoadSurveysWithLocalFallback sut;
  RemoteLoadSurveysSpy remote;
  LocalLoadSurveysSpy local;
  List<SurveyEntity> surveys;

  List<SurveyEntity> mockSurveys() => [
        SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(30, min: 30),
          dateTime: faker.date.dateTime(),
          didAnswer: faker.randomGenerator.boolean(),
        ),
      ];

  void mockRemoteLoad() {
    surveys = mockSurveys();
    when(remote.load()).thenAnswer((_) async => surveys);
  }

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    local = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote, local: local);
    mockRemoteLoad();
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
    verify(local.save(surveys)).called(1);
  });
}
