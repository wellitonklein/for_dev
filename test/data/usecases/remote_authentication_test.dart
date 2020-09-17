import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

import 'package:for_dev/domain/usecases/usecases.dart';

abstract class IHttpClient {
  Future<void> request({
    @required String url,
    @required String method,
    Map body,
  });
}

class RemoteAuthentication {
  final IHttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> auth({@required AuthenticationParams params}) async {
    final body = {
      'email': params.email,
      'password': params.secret,
    };
    await httpClient.request(
      url: url,
      method: 'POST',
      body: body,
    );
  }
}

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
