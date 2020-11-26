import 'package:faker/faker.dart';

class FakeAccountMock {
  static Map makeApiJson() {
    return {
      'accessToken': faker.guid.guid(),
      'name': faker.person.name(),
    };
  }
}
