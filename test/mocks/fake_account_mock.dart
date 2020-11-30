import 'package:faker/faker.dart';

import 'package:for_dev/domain/entities/entities.dart';

class FakeAccountMock {
  static Map makeApiJson() {
    return {
      'accessToken': faker.guid.guid(),
      'name': faker.person.name(),
    };
  }

  static AccountEntity makeEntity() {
    return AccountEntity(token: faker.guid.guid());
  }
}
