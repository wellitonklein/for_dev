import 'package:faker/faker.dart';
import 'package:for_dev/domain/entities/entities.dart';

class FakeSurveysMock {
  static List<Map> makeCacheJson() {
    return [
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
  }

  static List<Map> makeApiJson() {
    return [
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(50, min: 5),
        'didAnswer': faker.randomGenerator.boolean(),
        'date': faker.date.dateTime().toIso8601String(),
      },
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(50, min: 5),
        'didAnswer': faker.randomGenerator.boolean(),
        'date': faker.date.dateTime().toIso8601String(),
      },
    ];
  }

  static List<Map> makeIncompleteJson() {
    return [
      {
        'id': faker.guid.guid(),
        'didAnswer': 'false',
      },
    ];
  }

  static List<Map> makeInvalidJson() {
    return [
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(50, min: 10),
        'date': 'invalid_date',
        'didAnswer': 'false',
      },
    ];
  }

  static List<SurveyEntity> makeEntities() {
    return [
      SurveyEntity(
        id: faker.guid.guid(),
        question: faker.randomGenerator.string(50, min: 10),
        dateTime: DateTime.utc(1969, 07, 20),
        didAnswer: false,
      ),
      SurveyEntity(
        id: faker.guid.guid(),
        question: faker.randomGenerator.string(50, min: 10),
        dateTime: DateTime.utc(1970, 05, 12),
        didAnswer: true,
      ),
    ];
  }
}
