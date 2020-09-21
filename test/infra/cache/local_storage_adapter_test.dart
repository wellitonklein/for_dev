import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  LocalStorageAdapter sut;
  FlutterSecureStorageSpy secureStorage;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('saveSecure', () {
    test('should call save secure with correct values', () async {
      // act
      await sut.saveSecure(key: key, value: value);
      // assert
      verify(secureStorage.write(key: key, value: value));
    });

    test('should throws if save secure throws', () async {
      // arrange
      when(secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenThrow(Exception());

      // act
      final future = sut.saveSecure(key: key, value: value);
      // assert
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetchSecure', () {
    test('should call fetch secure with correct value', () async {
      // act
      await sut.fetchSecure(key: key);
      // assert
      verify(secureStorage.read(key: key));
    });

    test('should return correct value on success', () async {
      // arrange
      when(secureStorage.read(key: anyNamed('key')))
          .thenAnswer((_) async => value);

      // act
      final response = await sut.fetchSecure(key: key);
      // assert
      expect(response, value);
    });
  });
}
