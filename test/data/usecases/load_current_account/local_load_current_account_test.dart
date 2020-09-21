import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

abstract class IFecthSecureCacheStorage {
  Future<void> fetchSecure({@required String key});
}

class FetchSecureCacheStorageSpy extends Mock
    implements IFecthSecureCacheStorage {}

class LocalLoadCurrentAccount {
  final IFecthSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  Future<void> load() async {
    await fetchSecureCacheStorage.fetchSecure(key: 'token');
  }
}

void main() {
  test('should call FetchSecureCacheStorage with correct value', () async {
    // arrange
    final fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    final sut = LocalLoadCurrentAccount(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
    );

    // act
    sut.load();

    // assert
    verify(fetchSecureCacheStorage.fetchSecure(key: 'token'));
  });
}
