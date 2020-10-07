import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class LocalLoadSurveys {
  final IFetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({@required this.fetchCacheStorage});

  Future<void> load() async {
    await fetchCacheStorage.fetch(key: 'surveys');
  }
}

abstract class IFetchCacheStorage {
  Future<void> fetch({@required String key});
}

class FetchCacheStorageSpy extends Mock implements IFetchCacheStorage {}

void main() {
  test('should call FetchCacheStorage with correct key', () async {
    // arrange
    final fetchCacheStorage = FetchCacheStorageSpy();
    final sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
    // act
    await sut.load();
    // assert
    verify(fetchCacheStorage.fetch(key: 'surveys')).called(1);
  });
}
