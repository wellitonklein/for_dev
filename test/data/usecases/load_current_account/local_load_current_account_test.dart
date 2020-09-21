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
  LocalLoadCurrentAccount sut;
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
    );
  });

  test('should call FetchSecureCacheStorage with correct value', () async {
    // arrange

    // act
    sut.load();

    // assert
    verify(fetchSecureCacheStorage.fetchSecure(key: 'token'));
  });
}
