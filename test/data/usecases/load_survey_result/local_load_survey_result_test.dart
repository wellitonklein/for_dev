import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/data/cache/cache.dart';
import 'package:for_dev/data/usecases/usecases.dart';
import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/helpers/helpers.dart';

class CacheStorageSpy extends Mock implements ICacheStorage {}

void main() {
  group('loadBySurvey', () {
    LocalLoadSurveyResult sut;
    CacheStorageSpy cacheStorage;
    Map data;
    String surveyId;

    Map mockValidData() => {
          'surveyId': faker.guid.guid(),
          'question': faker.lorem.sentence(),
          'answers': [
            {
              'image': faker.internet.httpUrl(),
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': 'true',
              'percent': '40',
            },
            {
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': 'false',
              'percent': '60',
            },
          ]
        };

    PostExpectation mockFetchCall() =>
        when(cacheStorage.fetch(key: anyNamed('key')));

    void mockFetch(Map json) {
      data = json;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      surveyId = faker.guid.guid();
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      mockFetch(mockValidData());
    });

    test('should call FetchCacheStorage with correct key', () async {
      // act
      await sut.loadBySurvey(surveyId: surveyId);
      // assert
      verify(cacheStorage.fetch(key: 'survey_result/$surveyId')).called(1);
    });

    test('should return SurveyResult on success', () async {
      // act
      final surveyResult = await sut.loadBySurvey(surveyId: surveyId);
      // assert
      expect(
          surveyResult,
          SurveyResultEntity(
            surveyId: data['surveyId'],
            question: data['question'],
            answers: [
              SurveyAnswerEntity(
                image: data['answers'][0]['image'],
                answer: data['answers'][0]['answer'],
                percent: 40,
                isCurrentAnswer: true,
              ),
              SurveyAnswerEntity(
                answer: data['answers'][1]['answer'],
                percent: 60,
                isCurrentAnswer: false,
              ),
            ],
          ));
    });

    test('should throw UnexpectedError if cache is empty', () async {
      // arrange
      mockFetch({});
      // act
      final future = sut.loadBySurvey(surveyId: surveyId);
      // assert
      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache is null', () async {
      // arrange
      mockFetch(null);
      // act
      final future = sut.loadBySurvey(surveyId: surveyId);
      // assert
      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache is invalid', () async {
      // arrange
      mockFetch({
        'surveyId': faker.guid.guid(),
        'question': faker.lorem.sentence(),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'invalid bool',
            'percent': 'invalid int',
          }
        ]
      });
      // act
      final future = sut.loadBySurvey(surveyId: surveyId);
      // assert
      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache is incomplete', () async {
      // arrange
      mockFetch({'surveyId': faker.guid.guid()});
      // act
      final future = sut.loadBySurvey(surveyId: surveyId);
      // assert
      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache throws', () async {
      // arrange
      mockFetchError();
      // act
      final future = sut.loadBySurvey(surveyId: surveyId);
      // assert
      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    LocalLoadSurveyResult sut;
    CacheStorageSpy cacheStorage;
    Map data;
    String surveyId;

    Map mockValidData() => {
          'surveyId': faker.guid.guid(),
          'question': faker.lorem.sentence(),
          'answers': [
            {
              'image': faker.internet.httpUrl(),
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': 'true',
              'percent': '40',
            },
            {
              'answer': faker.lorem.sentence(),
              'isCurrentAnswer': 'false',
              'percent': '60',
            },
          ]
        };

    PostExpectation mockFetchCall() =>
        when(cacheStorage.fetch(key: anyNamed('key')));

    void mockFetch(Map json) {
      data = json;

      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      surveyId = faker.guid.guid();
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      mockFetch(mockValidData());
    });

    test('should call FetchCacheStorage with correct key', () async {
      // act
      await sut.validate(surveyId: surveyId);
      // assert
      verify(cacheStorage.fetch(key: 'survey_result/$surveyId')).called(1);
    });

    test('should delete cache if it is invalid', () async {
      // arrange
      mockFetch({
        'surveyId': faker.guid.guid(),
        'question': faker.lorem.sentence(),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'invalid bool',
            'percent': 'invalid int',
          }
        ]
      });
      // act
      await sut.validate(surveyId: surveyId);
      // assert
      verify(cacheStorage.delete(key: 'survey_result/$surveyId')).called(1);
    });

    test('should delete cache if it is incomplete', () async {
      // arrange
      mockFetch({
        'surveyId': faker.guid.guid(),
      });
      // act
      await sut.validate(surveyId: surveyId);
      // assert
      verify(cacheStorage.delete(key: 'survey_result/$surveyId')).called(1);
    });

    test('should delete cache if return throws', () async {
      // arrange
      mockFetchError();
      // act
      await sut.validate(surveyId: surveyId);
      // assert
      verify(cacheStorage.delete(key: 'survey_result/$surveyId')).called(1);
    });
  });
}
