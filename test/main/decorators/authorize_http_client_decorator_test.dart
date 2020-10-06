import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/data/cache/cache.dart';

class AuthorizeHttpClientDecorator {
  final IFetchSecureCacheStorage fetchSecureCacheStorage;

  AuthorizeHttpClientDecorator({
    @required this.fetchSecureCacheStorage,
  });

  Future<void> request() async {
    await fetchSecureCacheStorage.fetchSecure(key: 'token');
  }
}

class FetchSecureCacheStorageSpy extends Mock
    implements IFetchSecureCacheStorage {}

void main() {
  test('should call IFetchSecureCacheStorage with correct key', () async {
    // arrange
    final fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    final sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
    );
    // act
    await sut.request();
    // assert
    verify(fetchSecureCacheStorage.fetchSecure(key: 'token')).called(1);
  });
}
