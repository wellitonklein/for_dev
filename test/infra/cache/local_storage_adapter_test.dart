import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';

class LocalStorageAdapter {
  final LocalStorage localStorage;

  LocalStorageAdapter({@required this.localStorage});

  Future<void> save({@required String key, @required dynamic value}) async {
    await localStorage.setItem(key, value);
  }
}

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  test('should call localStorage with correct values', () async {
    // arrange
    final key = faker.randomGenerator.string(5, min: 5);
    final value = faker.randomGenerator.string(50, min: 50);
    final localStorage = LocalStorageSpy();
    final sut = LocalStorageAdapter(localStorage: localStorage);
    // act
    await sut.save(key: key, value: value);
    // assert
    verify(localStorage.setItem(key, value)).called(1);
  });
}
