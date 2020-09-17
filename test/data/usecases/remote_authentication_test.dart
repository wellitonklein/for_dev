import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:for_dev/domain/usecases/usecases.dart';
import 'package:for_dev/data/http/http.dart';
import 'package:for_dev/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements IHttpClient {}

void main() {
  RemoteAuthentication sut;
  IHttpClient httpClient;
  String url;

  setUp(() {
    // arrange
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('should call HttpClient with correct value', () async {
    // action
    final params = AuthenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );
    await sut.auth(params: params);

    // assert
    verify(httpClient.request(
      url: url,
      method: 'POST',
      body: {'email': params.email, 'password': params.secret},
    ));
  });
}
