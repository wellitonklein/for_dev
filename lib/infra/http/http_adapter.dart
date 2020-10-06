import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../data/http/http.dart';

class HttpAdapter implements IHttpClient {
  final Client client;

  HttpAdapter({@required this.client});

  Future<dynamic> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
  }) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({
        'Content-type': 'application/json',
        'Accept': 'application/json',
      });
    final jsonBody =
        (body != null && body.isNotEmpty) ? jsonEncode(body) : null;
    var response = Response('', 500);
    try {
      if (method == 'POST') {
        response = await client.post(
          url,
          headers: defaultHeaders,
          body: jsonBody,
        );
      }
      if (method == 'GET') {
        response = await client.get(
          url,
          headers: defaultHeaders,
        );
      }
    } catch (_) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  dynamic _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    }
    if (response.statusCode == 204) {
      return null;
    }
    if (response.statusCode == 400) {
      throw HttpError.badRequest;
    }
    if (response.statusCode == 401) {
      throw HttpError.unauthorized;
    }
    if (response.statusCode == 403) {
      throw HttpError.forbidden;
    }
    if (response.statusCode == 404) {
      throw HttpError.notFound;
    }
    throw HttpError.serverError;
  }
}
