import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/data/usecases/usecases.dart';
import 'package:for_dev/data/http/http.dart';
import 'package:for_dev/domain/entities/entities.dart';
import 'package:for_dev/domain/helpers/helpers.dart';

class HttpClientSpy extends Mock implements IHttpClient<List<Map>> {}

void main() {
  String url;
  HttpClientSpy httpClient;
  RemoteLoadSurveys sut;
  List<Map> list;

  List<Map> mockValidData() => [
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

  PostExpectation mockRequest() => when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
      ));

  void mockRequestData(List<Map> data) {
    list = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    mockRequestData(mockValidData());
  });

  test('should call HttpClient with correct values', () async {
    // arrange

    // act
    await sut.load();
    // assert
    verify(httpClient.request(url: url, method: 'GET'));
  });

  test('should return surveys on 200', () async {
    // arrange

    // act
    final surveys = await sut.load();
    // assert
    expect(surveys, [
      SurveyEntity(
        id: list[0]['id'],
        question: list[0]['question'],
        dateTime: DateTime.parse(list[0]['date']),
        didAnswer: list[0]['didAnswer'],
      ),
      SurveyEntity(
        id: list[1]['id'],
        question: list[1]['question'],
        dateTime: DateTime.parse(list[1]['date']),
        didAnswer: list[1]['didAnswer'],
      ),
    ]);
  });

  test(
      'should throws UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    // arrange
    mockRequestData([
      {'invalid_key': 'invalid_value'}
    ]);
    // act
    final future = sut.load();
    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 404', () async {
    // arrange
    mockHttpError(HttpError.notFound);

    // act
    final future = sut.load();

    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw AccessDeniedError if HttpClient returns 403', () async {
    // arrange
    mockHttpError(HttpError.forbidden);

    // act
    final future = sut.load();

    // assert
    expect(future, throwsA(DomainError.accessDenied));
  });

  test('should throw UnexpectedError if HttpClient returns 500', () async {
    // arrange
    mockHttpError(HttpError.serverError);

    // act
    final future = sut.load();

    // assert
    expect(future, throwsA(DomainError.unexpected));
  });
}
