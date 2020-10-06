import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSurveys implements ILoadSurveys {
  final String url;
  final IHttpClient httpClient;

  RemoteLoadSurveys({
    @required this.url,
    @required this.httpClient,
  });

  Future<List<SurveyEntity>> load() async {
    try {
      final response = await httpClient.request(url: url, method: 'GET');
      return response
          .map<SurveyEntity>(
              (json) => RemoteSurveyModel.fromJson(json).toEntity())
          .toList();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
