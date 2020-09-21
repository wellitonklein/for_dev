import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/domain/entities/entities.dart';

abstract class IFecthSecureCacheStorage {
  Future<String> fetchSecure({@required String key});
}

class FetchSecureCacheStorageSpy extends Mock
    implements IFecthSecureCacheStorage {}

class LocalLoadCurrentAccount {
  final IFecthSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  Future<AccountEntity> load() async {
    final token = await fetchSecureCacheStorage.fetchSecure(key: 'token');
    return AccountEntity(token: token);
  }
}

void main() {
  LocalLoadCurrentAccount sut;
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  String token;

  void mockFetchSecure() {
    when(fetchSecureCacheStorage.fetchSecure(key: anyNamed('key')))
        .thenAnswer((_) async => token);
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
    );
    token = faker.guid.guid();
    mockFetchSecure();
  });

  test('should call FetchSecureCacheStorage with correct value', () async {
    // arrange

    // act
    sut.load();

    // assert
    verify(fetchSecureCacheStorage.fetchSecure(key: 'token'));
  });

  test('should return an AccountEntity', () async {
    // arrange

    // act
    final account = await sut.load();

    // assert
    expect(account, AccountEntity(token: token));
  });
}
