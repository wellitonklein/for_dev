import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/data/usecases/load_surveys/load_surveys.dart';

class RemoteLoadSurveysWithLocalFallback {
  final RemoteLoadSurveys remote;

  RemoteLoadSurveysWithLocalFallback({@required this.remote});

  Future<void> load() async {
    await remote.load();
  }
}

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

void main() {
  test('should call remote load', () async {
    // arrange
    final remote = RemoteLoadSurveysSpy();
    final sut = RemoteLoadSurveysWithLocalFallback(remote: remote);
    // act
    await sut.load();
    // assert
    verify(remote.load()).called(1);
  });
}
