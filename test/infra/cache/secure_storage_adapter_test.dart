import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  SecureStorageAdapter sut;
  FlutterSecureStorageSpy secureStorage;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = SecureStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('saveSecure', () {
    test('should call save secure with correct values', () async {
      // act
      await sut.save(key: key, value: value);
      // assert
      verify(secureStorage.write(key: key, value: value));
    });

    test('should throws if save secure throws', () async {
      // arrange
      when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenThrow(Exception());

      // act
      final future = sut.save(key: key, value: value);
      // assert
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetchSecure', () {
    test('should call fetch secure with correct value', () async {
      // act
      await sut.fetch(key: key);
      // assert
      verify(secureStorage.read(key: key));
    });

    test('should return correct value on success', () async {
      // arrange
      when(secureStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => value);

      // act
      final response = await sut.fetch(key: key);
      // assert
      expect(response, value);
    });

    test('should throws if fetch secure throws', () async {
      // arrange
      when(secureStorage.read(key: anyNamed('key'))).thenThrow(Exception());

      // act
      final future = sut.fetch(key: key);
      // assert
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    void mockDeleteSecureError() =>
        when(secureStorage.delete(key: anyNamed('key'))).thenThrow(Exception());

    test('should call delete with correct key', () async {
      // act
      await sut.delete(key: key);
      // assert
      verify(secureStorage.delete(key: key)).called(1);
    });

    test('should throw if delete throws', () async {
      // arrange
      mockDeleteSecureError();
      // act
      final future = sut.delete(key: key);
      // assert
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
