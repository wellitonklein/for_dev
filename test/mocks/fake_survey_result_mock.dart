import 'package:faker/faker.dart';
import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/ui/pages/pages.dart';

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

  static Map makeInvalidJson() {
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

  static SurveyResultEntity makeEntity() => SurveyResultEntity(
        surveyId: faker.guid.guid(),
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
            image: faker.internet.httpUrl(),
            answer: faker.lorem.sentence(),
            isCurrentAnswer: true,
            percent: 40,
          ),
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            isCurrentAnswer: false,
            percent: 60,
          ),
        ],
      );

  static SurveyResultViewModel makeViewModel() {
    return SurveyResultViewModel(
      surveyId: 'Any id',
      question: 'Question',
      answers: [
        SurveyAnswerViewModel(
          answer: 'Answer 0',
          isCurrentAnswer: true,
          percent: '60%',
        ),
        SurveyAnswerViewModel(
          answer: 'Answer 1',
          isCurrentAnswer: false,
          percent: '40%',
        ),
      ],
    );
  }
}
