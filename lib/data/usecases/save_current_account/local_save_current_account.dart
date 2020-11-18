import 'package:meta/meta.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../cache/cache.dart';

class LocalSaveCurrentAccount implements ISaveCurrentAccount {
  final ISaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({@required this.saveSecureCacheStorage});

  @override
  Future<void> save(AccountEntity account) async {
    try {
      await saveSecureCacheStorage.save(
        key: 'token',
        value: account.token,
      );
    } catch (_) {
      throw DomainError.unexpected;
    }
  }
}
