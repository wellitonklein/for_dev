import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSurveyResult implements ILoadSurveyResult {
  final String url;
  final IHttpClient httpClient;

  RemoteLoadSurveyResult({
    @required this.url,
    @required this.httpClient,
  });

  Future<SurveyResultEntity> loadBySurvey({String surveyId}) async {
    try {
      final response = await httpClient.request(url: url, method: 'GET');
      return RemoteSurveyResultModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
