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
    final response = await fetchCacheStorage.fetch(key: 'surveys');
    if (response.isEmpty) {
      throw DomainError.unexpected;
    }
    return response
        .map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity())
        .toList();
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

  void mockFetch(List<Map> list) {
    data = list;
    when(fetchCacheStorage.fetch(key: anyNamed('key')))
        .thenAnswer((_) async => data);
  }

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
}
