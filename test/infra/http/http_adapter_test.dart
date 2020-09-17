import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter({@required this.client});

  Future<void> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    await client.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientSpy client;
  String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client: client);
    url = faker.internet.httpUrl();
  });
  group('POST', () {
    test('should call POST with correct values', () async {
      // act
      await sut.request(
        url: url,
        method: 'POST',
        body: {'any_key': 'any_value'},
      );

      // assert
      verify(client.post(
        url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        body: '{"any_key":"any_value"}',
      ));
    });
  });
}
