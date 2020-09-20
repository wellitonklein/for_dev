import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/usecases/usecases.dart';

abstract class ISaveSecureCacheStorage {
  Future<void> saveSecure({
    @required String key,
    @required String value,
  });
}

class SaveSecureCacheStorageSpy extends Mock
    implements ISaveSecureCacheStorage {}

class LocalSaveCurrentAccount implements ISaveCurrentAccount {
  final ISaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({@required this.saveSecureCacheStorage});
  @override
  Future<void> save(AccountEntity account) async {
    await saveSecureCacheStorage.saveSecure(key: 'token', value: account.token);
  }
}

void main() {
  test('should call SaveCacheStorage with correct values', () async {
    // arrange
    final cacheStorage = SaveSecureCacheStorageSpy();
    final sut = LocalSaveCurrentAccount(saveSecureCacheStorage: cacheStorage);
    final account = AccountEntity(token: faker.guid.guid());
    // act
    await sut.save(account);

    // assert
    verify(cacheStorage.saveSecure(key: 'token', value: account.token));
  });
}
