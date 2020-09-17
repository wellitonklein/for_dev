import 'package:meta/meta.dart';

import '../../domain/usecases/usecases.dart';
import '../http/http.dart';

class RemoteAuthentication {
  final IHttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> auth({@required AuthenticationParams params}) async {
    await httpClient.request(
      url: url,
      method: 'POST',
      body: params.toJson(),
    );
  }
}
