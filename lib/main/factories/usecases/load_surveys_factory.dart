import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

ILoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('surveys'),
  );
}
