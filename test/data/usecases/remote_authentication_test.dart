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

  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  PostExpectation mockRequest() => when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
        ),
      );

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    // arrange
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );
    mockHttpData(mockValidData());
  });

  test('should call HttpClient with correct value', () async {
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
    mockHttpError(HttpError.badRequest);

    // act
    final future = sut.auth(params: params);

    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 404', () async {
    // arrange
    mockHttpError(HttpError.notFound);

    // act
    final future = sut.auth(params: params);

    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 500', () async {
    // arrange
    mockHttpError(HttpError.serverError);

    // act
    final future = sut.auth(params: params);

    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test(
    'should throw InvalidCredentialsError if HttpClient returns 401',
    () async {
      // arrange
      mockHttpError(HttpError.unauthorized);

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
      final validData = mockValidData();
      mockHttpData(validData);

      // act
      final account = await sut.auth(params: params);

      // assert
      expect(account.token, validData['accessToken']);
    },
  );

  test(
    'should throw UnexpectedError if HttpClient returns 200 with invalid data',
    () async {
      // arrange
      mockHttpData({'invalid_key': 'invalid_value'});

      // act
      final future = sut.auth(params: params);

      // assert
      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
