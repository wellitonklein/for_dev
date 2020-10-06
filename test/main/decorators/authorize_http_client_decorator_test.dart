import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/data/cache/cache.dart';

class AuthorizeHttpClientDecorator {
  final IFetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({
    @required this.fetchSecureCacheStorage,
  });

  Future<void> request({
    @required String url,
    @required String method,
    Map body,
    Map headers,
  }) async {
    await fetchSecureCacheStorage.fetchSecure(key: 'token');
  }
}

class FetchSecureCacheStorageSpy extends Mock
    implements IFetchSecureCacheStorage {}

void main() {
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  AuthorizeHttpClientDecorator sut;
  String url;
  String method;
  Map body;

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
    );
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10, min: 3);
    body = {'any_key': 'any_value'};
  });

  test('should call IFetchSecureCacheStorage with correct key', () async {
    // act
    await sut.request(url: url, method: method, body: body);
    // assert
    verify(fetchSecureCacheStorage.fetchSecure(key: 'token')).called(1);
  });
}
