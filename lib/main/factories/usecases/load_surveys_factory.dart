import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../../composites/composites.dart';
import '../factories.dart';

ILoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl('surveys'),
  );
}

ILoadSurveys makeLocalLoadSurveys() =>
    LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter());

ILoadSurveys makeRemoteLoadSurveysWithLocalFallback() =>
    RemoteLoadSurveysWithLocalFallback(
      remote: makeRemoteLoadSurveys(),
      local: makeLocalLoadSurveys(),
    );
