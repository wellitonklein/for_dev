import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/data/cache/cache.dart';
import 'package:for_dev/data/http/http.dart';
import 'package:for_dev/main/decorators/decorators.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements IFetchSecureCacheStorage {}

class DeleteSecureCacheStorageSpy extends Mock
    implements IDeleteSecureCacheStorage {}

class HttpClientSpy extends Mock implements IHttpClient {}

void main() {
  AuthorizeHttpClientDecorator sut;
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  DeleteSecureCacheStorageSpy deleteSecureCacheStorage;
  HttpClientSpy httpClient;
  String url;
  String method;
  Map body;
  String token;
  String httpResponse;

  PostExpectation mockTokenCall() =>
      when(fetchSecureCacheStorage.fetchSecure(key: anyNamed('key')));

  void mockToken() {
    token = faker.guid.guid();
    mockTokenCall().thenAnswer((_) async => token);
  }

  void mockTokenError() {
    mockTokenCall().thenThrow(Exception());
  }

  PostExpectation mockHttpResponseCall() => when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body'),
          headers: anyNamed('headers'),
        ),
      );

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50, min: 50);
    mockHttpResponseCall().thenAnswer((_) async => httpResponse);
  }

  void mockHttpResponseError(HttpError error) =>
      mockHttpResponseCall().thenThrow(error);

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    deleteSecureCacheStorage = DeleteSecureCacheStorageSpy();
    httpClient = HttpClientSpy();
    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
      deleteSecureCacheStorage: deleteSecureCacheStorage,
      decoratee: httpClient,
    );
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10, min: 3);
    body = {'any_key': 'any_value'};
    mockToken();
    mockHttpResponse();
  });

  test('should call IFetchSecureCacheStorage with correct key', () async {
    // act
    await sut.request(url: url, method: method, body: body);
    // assert
    verify(fetchSecureCacheStorage.fetchSecure(key: 'token')).called(1);
  });

  test('should call decoratee with access token on header', () async {
    // act
    await sut.request(url: url, method: method, body: body);
    // assert
    verify(httpClient.request(
      url: url,
      method: method,
      body: body,
      headers: {'x-access-token': token},
    )).called(1);

    // act
    await sut.request(
      url: url,
      method: method,
      body: body,
      headers: {'any_header': 'any_value'},
    );
    // assert
    verify(httpClient.request(
      url: url,
      method: method,
      body: body,
      headers: {'x-access-token': token, 'any_header': 'any_value'},
    )).called(1);
  });

  test('should return same result as decoratee', () async {
    // act
    final response = await sut.request(url: url, method: method, body: body);
    // assert
    expect(response, httpResponse);
  });

  test('should throw ForbiddenError if FetchSecureCacheStorage throws',
      () async {
    // arrange
    mockTokenError();
    // act
    final future = sut.request(url: url, method: method, body: body);
    // assert
    expect(future, throwsA(HttpError.forbidden));
    verify(deleteSecureCacheStorage.deleteSecure(key: 'token')).called(1);
  });

  test('should rethrow if decoratee throws', () async {
    // arrange
    mockHttpResponseError(HttpError.badRequest);
    // act
    final future = sut.request(url: url, method: method, body: body);
    // assert
    expect(future, throwsA(HttpError.badRequest));
  });

  test('should delete cache if request throws ForbiddenError', () async {
    // arrange
    mockHttpResponseError(HttpError.forbidden);
    // act
    final future = sut.request(url: url, method: method, body: body);
    await untilCalled(deleteSecureCacheStorage.deleteSecure(key: 'token'));
    // assert
    expect(future, throwsA(HttpError.forbidden));
    verify(deleteSecureCacheStorage.deleteSecure(key: 'token')).called(1);
  });
}
