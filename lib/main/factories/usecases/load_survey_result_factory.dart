import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

ILoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveyResult(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('surveys/$surveyId/results'),
  );
}
