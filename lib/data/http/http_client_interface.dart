import 'package:meta/meta.dart';

abstract class IHttpClient<ResponseType> {
  Future<ResponseType> request({
    @required String url,
    @required String method,
    Map body,
  });
}
