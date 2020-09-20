import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/data/cache/cache.dart';
import 'package:for_dev/data/usecases/save_current_account/save_current_account.dart';
import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/helpers/helpers.dart';

class SaveSecureCacheStorageSpy extends Mock
    implements ISaveSecureCacheStorage {}

void main() {
  LocalSaveCurrentAccount sut;
  SaveSecureCacheStorageSpy saveSecureCacheStorage;
  AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut =
        LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(token: faker.guid.guid());
  });

  void mockError() {
    when(saveSecureCacheStorage.saveSecure(
      key: anyNamed('key'),
      value: anyNamed('value'),
    )).thenThrow(Exception());
  }

  test('should call SaveSecureCacheStorage with correct values', () async {
    // act
    await sut.save(account);

    // assert
    verify(
        saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });

  test(
    'should throw UnexpectedError if SaveSecureCacheStorage throws',
    () async {
      // arrange
      mockError();

      // act
      final future = sut.save(account);

      // assert
      expect(future, throwsA(DomainError.unexpected));
    },
  );
}
