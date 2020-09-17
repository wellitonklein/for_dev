import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/domain/usecases/usecases.dart';
import 'package:for_dev/domain/helpers/helpers.dart';

import 'package:for_dev/data/http/http.dart';
import 'package:for_dev/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements IHttpClient {}

void main() {
  RemoteAuthentication sut;
  IHttpClient httpClient;
  String url;
  AuthenticationParams params;

  setUp(() {
    // arrange
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );
  });

  test('should call HttpClient with correct value', () async {
    // arrange
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenAnswer(
      (_) async => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      },
    );

    // action
    await sut.auth(params: params);

    // assert
    verify(httpClient.request(
      url: url,
      method: 'POST',
      body: {'email': params.email, 'password': params.secret},
    ));
  });

  test('should throw UnexpectedError if HttpClient returns 400', () async {
    // arrange
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.badRequest);

    // act
    final future = sut.auth(params: params);

    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 404', () async {
    // arrange
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.notFound);

    // act
    final future = sut.auth(params: params);

    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 500', () async {
    // arrange
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
    )).thenThrow(HttpError.serverError);

    // act
    final future = sut.auth(params: params);

    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test(
    'should throw InvalidCredentialsError if HttpClient returns 401',
    () async {
      // arrange
      when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      )).thenThrow(HttpError.unauthorized);

      // act
      final future = sut.auth(params: params);

      // assert
      expect(future, throwsA(DomainError.invalidCredentials));
    },
  );

  test(
    'should return an Account if HttpClient returns 200',
    () async {
      // arrange
      final accessToken = faker.guid.guid();
      when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => {
          'accessToken': accessToken,
          'name': faker.person.name(),
        },
      );

      // act
      final account = await sut.auth(params: params);

      // assert
      expect(account.token, accessToken);
    },
  );
}
