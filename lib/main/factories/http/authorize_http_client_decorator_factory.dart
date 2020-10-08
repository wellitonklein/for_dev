import '../../../data/http/http.dart';
import '../../decorators/decorators.dart';
import '../factories.dart';

IHttpClient makeAuthorizeHttpClientDecorator() => AuthorizeHttpClientDecorator(
      decoratee: makeHttpAdapter(),
      fetchSecureCacheStorage: makeSecureStorageAdapter(),
    );
