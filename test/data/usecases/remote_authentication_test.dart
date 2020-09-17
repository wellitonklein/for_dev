import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class RemoteAuthentication {
  final IHttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> auth() async {
    await httpClient.request(
      url: url,
      method: 'POST',
    );
  }
}

abstract class IHttpClient {
  Future<void> request({
    @required String url,
    @required String method,
  });
}

class HttpClientSpy extends Mock implements IHttpClient {}

void main() {
  test('should call HttpClient with correct value', () async {
    // arrange
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    // action
    await sut.auth();

    // assert
    verify(httpClient.request(
      url: url,
      method: 'POST',
    ));
  });
}
