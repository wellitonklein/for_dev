import 'package:meta/meta.dart';

abstract class IHttpClient {
  Future<dynamic> request({
    @required String url,
    @required String method,
    Map body,
  });
}
