import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../data/http/http.dart';

class HttpAdapter implements IHttpClient {
  final Client client;

  HttpAdapter({@required this.client});

  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsonBody =
        (body != null && body.isNotEmpty) ? jsonEncode(body) : null;
    final response = await client.post(
      url,
      headers: headers,
      body: jsonBody,
    );
    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
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
    throw HttpError.serverError;
  }
}
