import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/data/models/models.dart';
import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/helpers/helpers.dart';

class LocalLoadSurveys {
  final IFetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({@required this.fetchCacheStorage});

  Future<List<SurveyEntity>> load() async {
    try {
      final response = await fetchCacheStorage.fetch(key: 'surveys');
      if (response?.isEmpty != false) {
        throw Exception();
      }
      return response
          .map<SurveyEntity>(
              (json) => LocalSurveyModel.fromJson(json).toEntity())
          .toList();
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}

abstract class IFetchCacheStorage {
  Future<dynamic> fetch({@required String key});
}

class FetchCacheStorageSpy extends Mock implements IFetchCacheStorage {}

void main() {
  FetchCacheStorageSpy fetchCacheStorage;
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
      when(fetchCacheStorage.fetch(key: anyNamed('key')));

  void mockFetch(List<Map> list) {
    data = list;

    mockFetchCall().thenAnswer((_) async => data);
  }

  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  setUp(() {
    fetchCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
    mockFetch(mockValidData());
  });

  test('should call FetchCacheStorage with correct key', () async {
    // act
    await sut.load();
    // assert
    verify(fetchCacheStorage.fetch(key: 'surveys')).called(1);
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
}
