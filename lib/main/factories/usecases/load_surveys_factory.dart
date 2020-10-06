import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

ILoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('surveys'),
  );
}
