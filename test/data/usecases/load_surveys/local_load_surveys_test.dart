import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/data/cache/cache.dart';
import 'package:for_dev/data/usecases/usecases.dart';
import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/helpers/helpers.dart';

class CacheStorageSpy extends Mock implements ICacheStorage {}

void main() {
  group('load', () {
    CacheStorageSpy cacheStorage;
    LocalLoadSurveys sut;
    List<Map> data;

    List<Map> mockValidData() => [
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(50, min: 10),
            'date': '1969-07-20 00:00:00Z',
            'didAnswer': 'false',
          },
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(50, min: 10),
            'date': '1969-07-20 00:00:00Z',
            'didAnswer': 'true',
          },
        ];

    PostExpectation mockFetchCall() =>
        when(cacheStorage.fetch(key: anyNamed('key')));

    void mockFetch(List<Map> list) {
      data = list;

      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(mockValidData());
    });

    test('should call FetchCacheStorage with correct key', () async {
      // act
      await sut.load();
      // assert
      verify(cacheStorage.fetch(key: 'surveys')).called(1);
    });

    test('should return a list of surveys on success', () async {
      // act
      final surveys = await sut.load();
      // assert
      expect(surveys, [
        SurveyEntity(
          id: data[0]['id'],
          question: data[0]['question'],
          dateTime: DateTime.utc(1969, 07, 20),
          didAnswer: false,
        ),
        SurveyEntity(
          id: data[1]['id'],
          question: data[1]['question'],
          dateTime: DateTime.utc(1969, 07, 20),
          didAnswer: true,
        ),
      ]);
    });

    test('should throw UnexpectedError if cache is empty', () async {
      // arrange
      mockFetch([]);
      // act
      final future = sut.load();
      // assert
      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache is null', () async {
      // arrange
      mockFetch(null);
      // act
      final future = sut.load();
      // assert
      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache is invalid', () async {
      // arrange
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50, min: 10),
          'date': 'invalid_date',
          'didAnswer': 'false',
        }
      ]);
      // act
      final future = sut.load();
      // assert
      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache is incomplete', () async {
      // arrange
      mockFetch([
        {
          'date': '1969-07-20 00:00:00Z',
          'didAnswer': 'false',
        }
      ]);
      // act
      final future = sut.load();
      // assert
      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache throws', () async {
      // arrange
      mockFetchError();
      // act
      final future = sut.load();
      // assert
      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    CacheStorageSpy cacheStorage;
    LocalLoadSurveys sut;
    List<Map> data;

    List<Map> mockValidData() => [
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(50, min: 10),
            'date': '1969-07-20 00:00:00Z',
            'didAnswer': 'false',
          },
          {
            'id': faker.guid.guid(),
            'question': faker.randomGenerator.string(50, min: 10),
            'date': '1969-07-20 00:00:00Z',
            'didAnswer': 'true',
          },
        ];

    PostExpectation mockFetchCall() =>
        when(cacheStorage.fetch(key: anyNamed('key')));

    void mockFetch(List<Map> list) {
      data = list;

      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(mockValidData());
    });

    test('should call FetchCacheStorage with correct key', () async {
      // act
      await sut.validate();
      // assert
      verify(cacheStorage.fetch(key: 'surveys')).called(1);
    });

    test('should delete cache if it is invalid', () async {
      // arrange
      mockFetch([
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(50, min: 10),
          'date': 'invalid_date',
          'didAnswer': 'false',
        },
      ]);
      // act
      await sut.validate();
      // assert
      verify(cacheStorage.delete(key: 'surveys')).called(1);
    });

    test('should delete cache if it is incomplete', () async {
      // arrange
      mockFetch([
        {
          'id': faker.guid.guid(),
          'didAnswer': 'false',
        },
      ]);
      // act
      await sut.validate();
      // assert
      verify(cacheStorage.delete(key: 'surveys')).called(1);
    });

    test('should delete cache if return throws', () async {
      // arrange
      mockFetchError();
      // act
      await sut.validate();
      // assert
      verify(cacheStorage.delete(key: 'surveys')).called(1);
    });
  });
}
