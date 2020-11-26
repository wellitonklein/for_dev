import 'package:faker/faker.dart';

class FakeSurveyResultMock {
  static Map makeCacheJson() {
    return {
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
  }

  static Map makeInvalidCacheJson() {
    return {
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
    };
  }

  static Map makeApiJson() {
    return {
      'surveyId': faker.guid.guid(),
      'question': faker.randomGenerator.string(50, min: 5),
      'answers': [
        {
          'image': faker.internet.httpUrl(),
          'answer': faker.randomGenerator.string(20, min: 20),
          'percent': faker.randomGenerator.integer(100),
          'count': faker.randomGenerator.integer(1000),
          'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
        },
        {
          'answer': faker.randomGenerator.string(20, min: 20),
          'percent': faker.randomGenerator.integer(100),
          'count': faker.randomGenerator.integer(1000),
          'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
        },
      ],
      'date': faker.date.dateTime().toIso8601String(),
    };
  }
}
