import 'package:meta/meta.dart';

import '../../http/http.dart';

class RemoteSaveSurveyResult {
  final String url;
  final IHttpClient httpClient;

  RemoteSaveSurveyResult({
    @required this.url,
    @required this.httpClient,
  });

  Future<void> save({String answer}) async {
    await httpClient.request(url: url, method: 'PUT', body: {'answer': answer});
  }
}
