import 'package:meta/meta.dart';

abstract class IHttpClient {
  Future<void> request({
    @required String url,
    @required String method,
    Map body,
  });
}
