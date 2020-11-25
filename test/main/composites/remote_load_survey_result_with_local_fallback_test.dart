import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/data/usecases/usecases.dart';

class RemoteLoadSurveyResultWithLocalFallback {
  final RemoteLoadSurveyResult remote;

  RemoteLoadSurveyResultWithLocalFallback({@required this.remote});

  Future<void> loadBySurvey({String surveyId}) async {
    await remote.loadBySurvey(surveyId: surveyId);
  }
}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

void main() {
  test('should call remote loadBySurvey', () async {
    // arrange
    final surveyId = faker.guid.guid();
    final remote = RemoteLoadSurveyResultSpy();
    final sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote);
    // act
    await sut.loadBySurvey(surveyId: surveyId);
    // assert
    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });
}
