import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

ILoadCurrentAccount makeLocalLoadCurrentAccount() {
  return LocalLoadCurrentAccount(
    fetchSecureCacheStorage: makeSecureStorageAdapter(),
  );
}
