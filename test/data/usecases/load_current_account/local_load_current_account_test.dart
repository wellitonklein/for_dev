import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/domain/helpers/helpers.dart';
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
    try {
      final token = await fetchSecureCacheStorage.fetchSecure(key: 'token');
      return AccountEntity(token: token);
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}

void main() {
  LocalLoadCurrentAccount sut;
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  String token;

  PostExpectation mockFetchSecureCall() =>
      when(fetchSecureCacheStorage.fetchSecure(key: anyNamed('key')));

  void mockFetchSecure() {
    mockFetchSecureCall().thenAnswer((_) async => token);
  }

  void mockFetchSecureError() {
    mockFetchSecureCall().thenThrow(Exception());
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

  test(
    'should throw UnexpectedError if FechSecureCacheStorage throws',
    () async {
      // arrange
      mockFetchSecureError();

      // act
      final future = sut.load();

      // assert
      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
