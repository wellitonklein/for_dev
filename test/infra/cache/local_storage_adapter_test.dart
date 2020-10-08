import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:localstorage/localstorage.dart';

import 'package:for_dev/infra/cache/cache.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  LocalStorageAdapter sut;
  LocalStorageSpy localStorage;
  String key;
  dynamic value;

  void mockDeleteError() =>
      when(localStorage.deleteItem(any)).thenThrow(Exception());

  void mockSaveError() =>
      when(localStorage.setItem(any, any)).thenThrow(Exception());

  setUp(() {
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
    key = faker.randomGenerator.string(5, min: 5);
    value = faker.randomGenerator.string(50, min: 50);
  });

  group('save', () {
    test('should call localStorage with correct values', () async {
      // act
      await sut.save(key: key, value: value);
      // assert
      verify(localStorage.deleteItem(key)).called(1);
      verify(localStorage.setItem(key, value)).called(1);
    });

    test('should throw if deleteItem throws', () async {
      // arrange
      mockDeleteError();
      // act
      final future = sut.save(key: key, value: value);
      // assert
      expect(future, throwsA(TypeMatcher<Exception>()));
    });

    test('should throw if deleteItem throws', () async {
      // arrange
      mockSaveError();
      // act
      final future = sut.save(key: key, value: value);
      // assert
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('should call localStorage with correct values', () async {
      // act
      await sut.delete(key: key);
      // assert
      verify(localStorage.deleteItem(key)).called(1);
    });

    test('should throw if deleteItem throws', () async {
      // arrange
      mockDeleteError();
      // act
      final future = sut.delete(key: key);
      // assert
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetch', () {
    String response;

    PostExpectation mockFetchCall() => when(localStorage.getItem(any));

    void mockFetch() => mockFetchCall().thenAnswer((_) async => response);
    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      mockFetch();
    });

    test('should call localStorage with correct value', () async {
      // act
      await sut.fetch(key: key);
      // assert
      verify(localStorage.getItem(key)).called(1);
    });

    test('should return same value as localStorage', () async {
      // act
      final data = await sut.fetch(key: key);
      // assert
      expect(data, response);
    });

    test('should throw if getItem throws', () async {
      // arrange
      mockFetchError();
      // act
      final future = sut.fetch(key: key);
      // assert
      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
