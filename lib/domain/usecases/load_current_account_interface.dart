import '../entities/entities.dart';

abstract class ILoadCurrentAccount {
  Future<AccountEntity> load();
}
