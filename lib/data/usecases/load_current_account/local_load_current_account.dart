import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';

class LocalLoadCurrentAccount implements ILoadCurrentAccount {
  final IFecthSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  Future<AccountEntity> load() async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure(key: 'token');
      return AccountEntity(token: token);
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
