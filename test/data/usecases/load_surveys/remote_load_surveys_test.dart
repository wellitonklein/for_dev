import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/data/http/http.dart';

class RemoteLoadSurveys {
  final String url;
  final IHttpClient httpClient;

  RemoteLoadSurveys({
    @required this.url,
    @required this.httpClient,
  });

  Future<void> load() async {
    await httpClient.request(url: url, method: 'GET');
  }
}

class HttpClientSpy extends Mock implements IHttpClient {}

void main() {
  String url;
  HttpClientSpy httpClient;
  RemoteLoadSurveys sut;

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
  });

  test('should call HttpClient with correct values', () async {
    // arrange

    // act
    await sut.load();
    // assert
    verify(httpClient.request(url: url, method: 'GET'));
  });
}
