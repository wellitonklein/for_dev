import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/data/http/http.dart';
import 'package:for_dev/infra/http/http.dart';

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

  group('shared', () {
    test('should throw ServerError if invalid method is provided', () async {
      // act
      final future = sut.request(url: url, method: 'invalid_method');
      // assert
      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('POST', () {
    PostExpectation mockRequest() => when(
        client.post(any, body: anyNamed('body'), headers: anyNamed('headers')));

    void mockResponse({@required int statusCode, String body = ''}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception);
    }

    setUp(() {
      mockResponse(statusCode: 200, body: '{"any_key":"any_value"}');
    });

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

    test('should call POST without body', () async {
      // act
      await sut.request(
        url: url,
        method: 'POST',
      );

      // assert
      verify(client.post(
        any,
        headers: anyNamed('headers'),
      ));
    });

    test('should return data if POST returns 200', () async {
      // act
      final response = await sut.request(url: url, method: 'POST');

      // assert
      expect(response, {'any_key': 'any_value'});
    });

    test('should return null if POST returns 200 with no data', () async {
      // arrange
      mockResponse(statusCode: 200);

      // act
      final response = await sut.request(url: url, method: 'POST');

      // assert
      expect(response, null);
    });

    test('should return null if POST returns 204', () async {
      // arrange
      mockResponse(statusCode: 204);

      // act
      final response = await sut.request(url: url, method: 'POST');

      // assert
      expect(response, null);
    });

    test('should return null if POST returns 204 with data', () async {
      // arrange
      mockResponse(statusCode: 204, body: '{"any_key":"any_value"}');

      // act
      final response = await sut.request(url: url, method: 'POST');

      // assert
      expect(response, null);
    });

    test('should return BadRequestError if POST returns 400', () async {
      // arrange
      mockResponse(statusCode: 400);

      // act
      final future = sut.request(url: url, method: 'POST');

      // assert
      expect(future, throwsA(HttpError.badRequest));
    });

    test('should return UnauthorizedError if POST returns 401', () async {
      // arrange
      mockResponse(statusCode: 401);

      // act
      final future = sut.request(url: url, method: 'POST');

      // assert
      expect(future, throwsA(HttpError.unauthorized));
    });

    test('should return ForbiddenError if POST returns 403', () async {
      // arrange
      mockResponse(statusCode: 403);

      // act
      final future = sut.request(url: url, method: 'POST');

      // assert
      expect(future, throwsA(HttpError.forbidden));
    });

    test('should return NotFoundError if POST returns 404', () async {
      // arrange
      mockResponse(statusCode: 404);

      // act
      final future = sut.request(url: url, method: 'POST');

      // assert
      expect(future, throwsA(HttpError.notFound));
    });

    test('should return ServerError if POST returns 500', () async {
      // arrange
      mockResponse(statusCode: 500);

      // act
      final future = sut.request(url: url, method: 'POST');

      // assert
      expect(future, throwsA(HttpError.serverError));
    });

    test('should return ServerError if POST throws', () async {
      // arrange
      mockError();

      // act
      final future = sut.request(url: url, method: 'POST');

      // assert
      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('GET', () {
    PostExpectation mockRequest() =>
        when(client.get(any, headers: anyNamed('headers')));

    void mockResponse({@required int statusCode, String body = ''}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse(statusCode: 200, body: '{"any_key":"any_value"}');
    });

    test('should call GET with correct values', () async {
      // act
      await sut.request(
        url: url,
        method: 'GET',
      );

      // assert
      verify(client.get(
        url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      ));
    });

    test('should return data if GET returns 200', () async {
      // act
      final response = await sut.request(url: url, method: 'GET');

      // assert
      expect(response, {'any_key': 'any_value'});
    });

    test('should return null if GET returns 200 with no data', () async {
      // arrange
      mockResponse(statusCode: 200);

      // act
      final response = await sut.request(url: url, method: 'GET');

      // assert
      expect(response, null);
    });
  });
}
