import 'package:meta/meta.dart';

import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

class AuthorizeHttpClientDecorator implements IHttpClient {
  final IFetchSecureCacheStorage fetchSecureCacheStorage;
  final IDeleteSecureCacheStorage deleteSecureCacheStorage;
  final IHttpClient decoratee;

  AuthorizeHttpClientDecorator({
    @required this.fetchSecureCacheStorage,
    @required this.deleteSecureCacheStorage,
    @required this.decoratee,
  });

  Future<dynamic> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
  }) async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure(key: 'token');
      final authorizedHeaders = headers ?? {}
        ..addAll({'x-access-token': token});
      return await decoratee.request(
        url: url,
        method: method,
        body: body,
        headers: authorizedHeaders,
      );
    } catch (error) {
      if (error is HttpError && error != HttpError.forbidden) {
        rethrow;
      }
      await deleteSecureCacheStorage.deleteSecure(key: 'token');
      throw HttpError.forbidden;
    }
  }
}
