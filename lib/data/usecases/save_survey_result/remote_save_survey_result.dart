import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteSaveSurveyResult implements ISaveSurveyResult {
  final String url;
  final IHttpClient httpClient;

  RemoteSaveSurveyResult({
    @required this.url,
    @required this.httpClient,
  });

  Future<SurveyResultEntity> save({String answer}) async {
    try {
      final response = await httpClient.request(
        url: url,
        method: 'PUT',
        body: {'answer': answer},
      );
      return RemoteSurveyResultModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
