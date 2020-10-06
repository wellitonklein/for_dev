import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/data/cache/cache.dart';
import 'package:for_dev/data/usecases/usecases.dart';
import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/helpers/helpers.dart';

class FetchSecureCacheStorageSpy extends Mock
    implements IFetchSecureCacheStorage {}

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
