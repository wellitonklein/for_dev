import 'package:meta/meta.dart';

import '../../../domain/helpers/helpers.dart';
import '../../http/http.dart';

class RemoteSaveSurveyResult {
  final String url;
  final IHttpClient httpClient;

  RemoteSaveSurveyResult({
    @required this.url,
    @required this.httpClient,
  });

  Future<void> save({String answer}) async {
    try {
      await httpClient
          .request(url: url, method: 'PUT', body: {'answer': answer});
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}