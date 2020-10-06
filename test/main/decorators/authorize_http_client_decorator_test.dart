import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/data/cache/cache.dart';
import 'package:for_dev/data/http/http.dart';

class AuthorizeHttpClientDecorator implements IHttpClient {
  final IFetchSecureCacheStorage fetchSecureCacheStorage;
  final IHttpClient decoratee;

  AuthorizeHttpClientDecorator({
    @required this.fetchSecureCacheStorage,
    @required this.decoratee,
  });

  Future<dynamic> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
  }) async {
    final token = await fetchSecureCacheStorage.fetchSecure(key: 'token');
    final authorizedHeaders = headers ?? {}
      ..addAll({'x-access-token': token});
    return await decoratee.request(
      url: url,
      method: method,
      body: body,
      headers: authorizedHeaders,
    );
  }
}

class FetchSecureCacheStorageSpy extends Mock
    implements IFetchSecureCacheStorage {}

class HttpClientSpy extends Mock implements IHttpClient {}

void main() {
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  HttpClientSpy httpClient;
  AuthorizeHttpClientDecorator sut;
  String url;
  String method;
  Map body;
  String token;
  String httpResponse;

  void mockToken() {
    token = faker.guid.guid();
    when(fetchSecureCacheStorage.fetchSecure(key: anyNamed('key')))
        .thenAnswer((_) async => token);
  }

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50, min: 50);
    when(httpClient.request(
      url: anyNamed('url'),
      method: anyNamed('method'),
      body: anyNamed('body'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => httpResponse);
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    httpClient = HttpClientSpy();
    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
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
}
