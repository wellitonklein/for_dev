import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter({@required this.client});

  Future<void> request({
    @required String url,
    @required String method,
  }) async {
    await client.post(url);
  }
}

class ClientSpy extends Mock implements Client {}

void main() {
  group('POST', () {
    test('should call POST with correct values', () async {
      // arrange
      final client = ClientSpy();
      final sut = HttpAdapter(client: client);
      final url = faker.internet.httpUrl();
      // act
      await sut.request(url: url, method: 'POST');

      // assert
      verify(client.post(url));
    });
  });
}
